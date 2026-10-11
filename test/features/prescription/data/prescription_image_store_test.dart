import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/features/prescription/data/prescription_image_store.dart';
import 'package:medicine_remainder_app/services/security/prescription_image_cipher.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory rootDirectory;

  setUp(() async {
    rootDirectory = await Directory.systemTemp.createTemp('prescription_image_store');
  });

  tearDown(() async {
    if (await rootDirectory.exists()) {
      await rootDirectory.delete(recursive: true);
    }
  });

  group('PrescriptionImageStore', () {
    test('saveTemporary encrypts and readBytes decrypts', () async {
      final cipher = await PrescriptionImageCipher.loadOrCreate(
        testKeyBytes: List<int>.generate(32, (i) => i + 10),
      );
      final store = PrescriptionImageStore(
        rootDirectory: rootDirectory,
        cipher: cipher,
        encryptAtRest: true,
      );
      final path = await store.saveTemporary([1, 2, 3], mimeType: 'image/jpeg');
      final file = File(path);
      expect(await file.exists(), isTrue);
      expect(path.endsWith('.mrx'), isTrue);
      expect(path, contains(p.join('prescriptions', 'tmp')));
      expect(await file.readAsBytes(), isNot([1, 2, 3]));
      expect(await store.readBytes(path), [1, 2, 3]);
      await store.delete(path);
      expect(await file.exists(), isFalse);
    });

    test('delete rejects paths outside the store root', () async {
      final store = PrescriptionImageStore(
        rootDirectory: rootDirectory,
        encryptAtRest: false,
      );
      expect(
        () => store.delete(p.join(rootDirectory.parent.path, 'outside.jpg')),
        throwsArgumentError,
      );
    });
  });
}
