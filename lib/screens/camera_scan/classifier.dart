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
