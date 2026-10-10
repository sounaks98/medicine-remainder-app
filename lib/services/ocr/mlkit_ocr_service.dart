import 'dart:convert';
import 'dart:io';
import 'dart:ui' show Rect;

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:medicine_remainder_app/services/inference/image_preprocessor.dart';
import 'package:medicine_remainder_app/services/ocr/ocr_result.dart';
import 'package:path_provider/path_provider.dart';

/// ML Kit Latin text recognition wrapper (P1-03).
class MlkitOcrService {
  MlkitOcrService({
    ImagePreprocessor? preprocessor,
    TextRecognizer? recognizer,
  })  : _preprocessor = preprocessor ?? const ImagePreprocessor(),
        _recognizer = recognizer ??
            TextRecognizer(script: TextRecognitionScript.latin);

  static const int resultVersion = 1;

  final ImagePreprocessor _preprocessor;
  final TextRecognizer _recognizer;

  Future<OcrResult> recognizeFromPath(String imagePath) async {
    final jpegBytes = await _preprocessor.preprocessForOcr(imagePath);
    final tempFile = await _writeTempJpeg(jpegBytes);
    try {
      final inputImage = InputImage.fromFilePath(tempFile.path);
      final recognized = await _recognizer.processImage(inputImage);
      return OcrResult(
        version: resultVersion,
        fullText: recognized.text,
        blocksJson: jsonEncode(_blocksToJson(recognized)),
      );
    } finally {
      await _deleteIfExists(tempFile);
    }
  }

  Future<void> dispose() => _recognizer.close();

  static Future<File> _writeTempJpeg(List<int> bytes) async {
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/ocr_${DateTime.now().microsecondsSinceEpoch}.jpg',
    );
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static Future<void> _deleteIfExists(File file) async {
    if (await file.exists()) {
      await file.delete();
    }
  }

  static List<Map<String, Object?>> _blocksToJson(RecognizedText recognized) {
    return recognized.blocks.map((block) {
      return <String, Object?>{
        'text': block.text,
        'boundingBox': _rectToJson(block.boundingBox),
        'lines': block.lines
            .map(
              (line) => <String, Object?>{
                'text': line.text,
                'boundingBox': _rectToJson(line.boundingBox),
              },
            )
            .toList(),
      };
    }).toList();
  }

  static Map<String, double> _rectToJson(Rect rect) {
    return {
      'left': rect.left,
      'top': rect.top,
      'right': rect.right,
      'bottom': rect.bottom,
    };
  }
}
