import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Shared image preprocessing (OCR rotate/resize; Idefics3 tensors for VLM).
class ImagePreprocessor {
  const ImagePreprocessor();

  /// Longest edge cap for ML Kit OCR input (memory and latency).
  static const int maxOcrLongestEdge = 2048;

  /// Applies EXIF orientation, scales down if needed, returns JPEG bytes.
  Future<List<int>> preprocessForOcr(String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw FormatException('Could not decode image at $imagePath');
    }
    final oriented = img.bakeOrientation(decoded);
    final resized = _resizeToMaxLongestEdge(oriented, maxOcrLongestEdge);
    return Uint8List.fromList(img.encodeJpg(resized, quality: 90));
  }

  Future<Object?> preprocessForVlm(String imagePath) {
    throw UnimplementedError('P3-04');
  }

  static img.Image _resizeToMaxLongestEdge(img.Image image, int maxLongestEdge) {
    final longest = math.max(image.width, image.height);
    if (longest <= maxLongestEdge) {
      return image;
    }
    final scale = maxLongestEdge / longest;
    final targetWidth = (image.width * scale).round();
    final targetHeight = (image.height * scale).round();
    return img.copyResize(
      image,
      width: targetWidth,
      height: targetHeight,
      interpolation: img.Interpolation.linear,
    );
  }
}
