import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:medicine_remainder_app/services/inference/image_preprocessor.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory tempDir;
  const preprocessor = ImagePreprocessor();

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('image_preprocessor_test');
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('preprocessForOcr applies EXIF orientation', () async {
    final source = img.Image(width: 120, height: 80);
    img.fill(source, color: img.ColorRgb8(200, 100, 50));
    source.exif.imageIfd.orientation = 6;

    final sourcePath = p.join(tempDir.path, 'oriented.jpg');
    await File(sourcePath).writeAsBytes(img.encodeJpg(source));

    final output = await preprocessor.preprocessForOcr(sourcePath);
    final decoded = img.decodeImage(Uint8List.fromList(output));
    expect(decoded, isNotNull);
    expect(decoded!.width, 80);
    expect(decoded.height, 120);
  });

  test('preprocessForOcr scales down when longest edge exceeds cap', () async {
    final source = img.Image(width: 4000, height: 2000);
    img.fill(source, color: img.ColorRgb8(10, 20, 30));

    final sourcePath = p.join(tempDir.path, 'large.jpg');
    await File(sourcePath).writeAsBytes(img.encodeJpg(source));

    final output = await preprocessor.preprocessForOcr(sourcePath);
    final decoded = img.decodeImage(Uint8List.fromList(output));
    expect(decoded, isNotNull);
    expect(decoded!.width, ImagePreprocessor.maxOcrLongestEdge);
    expect(decoded.height, 1024);
  });

  test('preprocessForOcr leaves small images unchanged in dimensions', () async {
    final source = img.Image(width: 640, height: 480);
    final sourcePath = p.join(tempDir.path, 'small.jpg');
    await File(sourcePath).writeAsBytes(img.encodeJpg(source));

    final output = await preprocessor.preprocessForOcr(sourcePath);
    final decoded = img.decodeImage(Uint8List.fromList(output));
    expect(decoded, isNotNull);
    expect(decoded!.width, 640);
    expect(decoded.height, 480);
  });
}
