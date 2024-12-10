// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:image/image.dart' as img;
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:path_provider/path_provider.dart';
//
// class Classifier {
//   late Interpreter interpreter;
//   final int inputSize = 224;
//
//   Future<void> init() async {
//     try {
//       interpreter = await Interpreter.fromAsset("assets/best.tflite");
//       print("Model loaded successfully.");
//     } catch (e) {
//       print("Error loading model: $e");
//     }
//   }
//
//   Future<List<dynamic>> classifyImage(File image) async {
//     var tensorImage = preprocessImage(image).reshape([1, inputSize, inputSize, 3]);
//     var outputBuffer = List<double>.filled(8, 0.0).reshape([1, 8]);
//     interpreter.run(tensorImage, outputBuffer);
//     print(outputBuffer);
//
//     List<String> labels = await loadLabels('assets/labels.txt');
//
//     double highestProb = 0;
//     String resultLabel = '';
//     for (int i = 0; i < outputBuffer[0].length; i++) {
//       double probability = outputBuffer[0][i];
//       if (probability > highestProb) {
//         highestProb = probability;
//         resultLabel = labels[i];
//       }
//     }
//
//     String confidence = (highestProb * 100).toStringAsFixed(1);
//     return [resultLabel, confidence];
//   }
//
//   List<double> preprocessImage(File image) {
//     img.Image? originalImage = img.decodeImage(image.readAsBytesSync());
//     img.Image resizedImage = img.copyResize(originalImage!, width: inputSize, height: inputSize);
//
//     List<double> inputBuffer = List.filled(inputSize * inputSize * 3, 0.0);
//     int bufferIndex = 0;
//
//     for (int y = 0; y < inputSize; y++) {
//       for (int x = 0; x < inputSize; x++) {
//         int pixel = resizedImage.getPixel(x, y);
//         inputBuffer[bufferIndex++] = img.getRed(pixel) / 255.0;
//         inputBuffer[bufferIndex++] = img.getGreen(pixel) / 255.0;
//         inputBuffer[bufferIndex++] = img.getBlue(pixel) / 255.0;
//       }
//     }
//
//     return inputBuffer;
//   }
//
//   Future<List<String>> loadLabels(String path) async {
//     final labelData = await rootBundle.loadString(path);
//     return labelData.split('\n').where((label) => label.isNotEmpty).toList();
//   }
// }
//
// class CameraScreen extends StatefulWidget {
//   final List<CameraDescription> cameras;
//   CameraScreen({required this.cameras});
//
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }
//
// class _CameraScreenState extends State<CameraScreen> {
//   late CameraController _controller;
//   late Classifier classifier;
//   String detectedLabel = 'Detecting...';
//   String confidence = '';
//   bool isClassifierReady = false;
//   bool isProcessing = false;
//
//   @override
//   void initState() {
//     super.initState();
//     classifier = Classifier();
//     _initializeClassifier();
//     _initializeCamera();
//   }
//
//   Future<void> _initializeClassifier() async {
//     await classifier.init();
//     setState(() {
//       isClassifierReady = true;
//     });
//   }
//
//   Future<void> _initializeCamera() async {
//     _controller = CameraController(widget.cameras.first, ResolutionPreset.medium);
//     try {
//       await _controller.initialize();
//       setState(() {});
//     } catch (e) {
//       print('Error initializing camera: $e');
//     }
//   }
//
//   void _captureAndClassify() async {
//     if (!isClassifierReady || isProcessing) return;
//
//     setState(() {
//       isProcessing = true;
//       detectedLabel = 'Processing...';
//       confidence = '';
//     });
//
//     final tempDir = await getTemporaryDirectory();
//     final filePath = '${tempDir.path}/temp_image.jpg';
//
//     try {
//       XFile picture = await _controller.takePicture();
//       File imageFile = File(picture.path);
//
//       var result = await classifier.classifyImage(imageFile);
//       print(result);
//       setState(() {
//         detectedLabel = result[0];
//         confidence = result[1];
//       });
//     } catch (e) {
//       print('Error during classification: $e');
//     } finally {
//       setState(() {
//         isProcessing = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!_controller.value.isInitialized) {
//       return Center(child: CircularProgressIndicator());
//     }
//
//     return Scaffold(
//       appBar: AppBar(title: Text('Car Model Detection')),
//       body: Stack(
//         children: [
//           CameraPreview(_controller),
//           Positioned(
//             top: 20,
//             left: 20,
//             child: Text(
//               isProcessing
//                   ? 'Processing...'
//                   : 'Detected: $detectedLabel\nConfidence: $confidence%',
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//           ),
//           if (isProcessing)
//             Container(
//               color: Colors.black.withOpacity(0.5),
//               child: Center(
//                 child: CircularProgressIndicator(color: Colors.white),
//               ),
//             ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: isProcessing ? null : _captureAndClassify,
//         child: Icon(Icons.camera),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:remove_bg/remove_bg.dart';
import 'package:path_provider/path_provider.dart';

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

  const CameraScreen({required this.cameras});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Classifier classifier;
  String detectedLabel = 'Detecting...';
  String confidence = '';
  bool isClassifierReady = false;
  bool isProcessing = false;
  double linearProgress = 0.0;
  File? processedImage;

  @override
  void initState() {
    super.initState();
    classifier = Classifier();
    _initializeClassifier();
    _initializeCamera();
  }

  Future<void> _initializeClassifier() async {
    await classifier.init();
    setState(() {
      isClassifierReady = true;
    });
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(widget.cameras.first, ResolutionPreset.medium);
    try {
      await _controller.initialize();
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _captureAndProcessImage() async {
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

      // Remove background using Remove.bg
      await Remove().bg(
        imageFile,
        privateKey: "was5vPd4bqMX6v63H5nRkBuF", // Replace with your actual key
        onUploadProgressCallback: (progressValue) {
          setState(() {
            linearProgress = progressValue;
          });
        },
      ).then((data) async {
        processedImage = File('$filePath/processed_image.png');
        await processedImage!.writeAsBytes(data!);
        print('Background removed successfully.');
      });

      // Classify the processed image
      if (processedImage != null) {
        var result = await classifier.classifyImage(processedImage!);
        print(result);
        setState(() {
          detectedLabel = result[0];
          confidence = result[1];
        });
      }
    } catch (e) {
      print('Error during processing: $e');
    } finally {
      setState(() {
        isProcessing = false;
        linearProgress = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text('Car Model Detection')),
      body: Stack(
        children: [
          CameraPreview(_controller),
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              isProcessing
                  ? 'Processing...'
                  : 'Detected: $detectedLabel\nConfidence: $confidence%',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: LinearProgressIndicator(value: linearProgress),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _captureAndProcessImage,
        child: Icon(Icons.camera),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
