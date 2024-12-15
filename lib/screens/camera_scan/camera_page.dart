import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:autophile/services/image_modal_helper.dart';

class Classifier {
  late Interpreter interpreter;
  final int inputSize = 224;

  Future<void> init() async {
    try {
      interpreter = await Interpreter.fromAsset("assets/best.tflite");
      print("Model loaded successfully.");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  Future<List<dynamic>> classifyImage(File image) async {
    var tensorImage = preprocessImage(image).reshape([1, inputSize, inputSize, 3]);
    var outputBuffer = List<double>.filled(8, 0.0).reshape([1, 8]);
    interpreter.run(tensorImage, outputBuffer);
    print(outputBuffer);

    List<String> labels = await loadLabels('assets/labels.txt');

    double highestProb = 0;
    String resultLabel = '';
    for (int i = 0; i < outputBuffer[0].length; i++) {
      double probability = outputBuffer[0][i];
      if (probability > highestProb) {
        highestProb = probability;
        resultLabel = labels[i];
      }
    }

    String confidence = (highestProb * 100).toStringAsFixed(1);
    return [resultLabel, confidence];
  }

  List<double> preprocessImage(File image) {
    img.Image? originalImage = img.decodeImage(image.readAsBytesSync());
    img.Image resizedImage = img.copyResize(originalImage!, width: inputSize, height: inputSize);

    List<double> inputBuffer = List.filled(inputSize * inputSize * 3, 0.0);
    int bufferIndex = 0;

    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        int pixel = resizedImage.getPixel(x, y);
        inputBuffer[bufferIndex++] = img.getRed(pixel) / 255.0;
        inputBuffer[bufferIndex++] = img.getGreen(pixel) / 255.0;
        inputBuffer[bufferIndex++] = img.getBlue(pixel) / 255.0;
      }
    }

    return inputBuffer;
  }

  Future<List<String>> loadLabels(String path) async {
    final labelData = await rootBundle.loadString(path);
    return labelData.split('\n').where((label) => label.isNotEmpty).toList();
  }
}

class CameraScreen extends StatefulWidget {

  final List<CameraDescription> cameras;
  CameraScreen({required this.cameras});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImageModalService _imageModalService = ImageModalService();
  late File _capturedImage;
  late CameraController _controller;
  late Classifier classifier;
  String detectedLabel = 'Detecting...';
  String confidence = '';
  bool isClassifierReady = false;
  bool isProcessing = false;

  bool isFlashOn = false;
  int selectedCameraIndex = 0;
  double currentZoomLevel = 1.0;
  double maxZoomLevel = 1.0;
  double minZoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    classifier = Classifier();
    _initializeClassifier();
    _initializeCamera(selectedCameraIndex);
  }

  Future<void> _initializeClassifier() async {
    await classifier.init();
    setState(() {
      isClassifierReady = true;
    });
  }

  Future<void> _initializeCamera(int cameraIndex) async {
    _controller = CameraController(
      widget.cameras[cameraIndex],
      ResolutionPreset.max,
    );
    try {
      await _controller.initialize();
      minZoomLevel = await _controller.getMinZoomLevel();
      maxZoomLevel = await _controller.getMaxZoomLevel();
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void _captureAndClassify() async {
    if (!isClassifierReady || isProcessing) return;

    setState(() {
      isProcessing = true;
      detectedLabel = 'Processing...';
      confidence = '';
    });

    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/temp_image.jpg';

    try {
      XFile picture = await _controller.takePicture();
      File imageFile = File(picture.path);

      var result = await classifier.classifyImage(imageFile);
      print(result);
      setState(() {
        detectedLabel = result[0];
        confidence = result[1];
        _capturedImage = imageFile;
      });
    } catch (e) {
      print('Error during classification: $e');
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  void _toggleFlash() async {
    isFlashOn = !isFlashOn;
    await _controller.setFlashMode(isFlashOn ? FlashMode.torch : FlashMode.off);
    setState(() {});
  }

  void _switchCamera() async {
    selectedCameraIndex = (selectedCameraIndex + 1) % widget.cameras.length;
    await _initializeCamera(selectedCameraIndex);
  }

  void _onZoomChange(double zoomValue) async {
    await _controller.setZoomLevel(zoomValue);
    setState(() {
      currentZoomLevel = zoomValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Stack(
        children: [
          // Camera preview
          Positioned.fill(
            child: CameraPreview(_controller),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
            ),
          ),
          // Green capture box
          Center(

            child: Container(
              width: 224,
              height: 224,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
              ),
            ),
          ),

          // Detected label display
          Positioned(
            bottom: 120,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detected: $detectedLabel',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  if (confidence.isNotEmpty)
                    Text(
                      'Confidence: $confidence%',
                      style: TextStyle(color: Colors.green, fontSize: 16),
                    ),
                ],
              ),
            ),
          ),

          // Processing overlay
          if (isProcessing)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),

          // Flash button
          Positioned(
            top: 50,
            right: 40,
            child: IconButton(
              icon: Icon(
                isFlashOn ? Icons.flash_on : Icons.flash_off,
                color: Colors.white,
                size: 30,
              ),
              onPressed: _toggleFlash,
            ),
          ),

          // Camera switch button
          Positioned(
            bottom: 20,
            left: 50,
            child: IconButton(
              icon: Icon(
                Icons.switch_camera,
                color: Colors.white,
                size: 40,
              ),
              onPressed: _switchCamera,
            ),
          ),

          // Zoom slider
          Positioned(
            bottom: 200,
            left: 20,
            right: 20,
            child: Slider(
              value: currentZoomLevel,
              min: minZoomLevel,
              max: maxZoomLevel,
              activeColor: Colors.white,
              inactiveColor: Colors.grey,
              onChanged: _onZoomChange,
            ),
          ),

          // Centered floating action button overlay
          Positioned(

            width: 80,
            height: 80,
            bottom: 20,
            left: MediaQuery.of(context).size.width / 2 - 40, // Center the button
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              onPressed: isProcessing ? null : _captureAndClassify,
              child: Icon(Icons.camera, size: 60 ,color: Colors.white70),
            ),
          ),
          if (!isProcessing && detectedLabel != 'Detecting...')
            Positioned(
              bottom: 20,
              right:50,
              // left: MediaQuery.of(context).size.width / 2 - 20, // Center the button
              child: FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: () {
                  _imageModalService.showSaveModal(context, detectedLabel, confidence, _capturedImage);
                },
                child: Icon(Icons.save, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


