import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class MlKitService {
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  final ImageLabeler _labeler = ImageLabeler(
    options: ImageLabelerOptions(confidenceThreshold: 0.6),
  );

  Future<String> recognizeTextFromFile(File file) async {
    final inputImage = InputImage.fromFile(file);
    final recognized = await _textRecognizer.processImage(inputImage);
    return recognized.text;
  }

  Future<List<ImageLabel>> labelImageFromFile(File file) async {
    final inputImage = InputImage.fromFile(file);
    return _labeler.processImage(inputImage);
  }

  Future<void> dispose() async {
    await _textRecognizer.close();
    await _labeler.close();
  }
}
