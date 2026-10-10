import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/features/prescription/data/prescription_image_store.dart';
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
    test('saveTemporary writes under app documents prescriptions/tmp', () async {
      final store = PrescriptionImageStore(rootDirectory: rootDirectory);
      final path = await store.saveTemporary([1, 2, 3], mimeType: 'image/jpeg');
      final file = File(path);
      expect(await file.exists(), isTrue);
      expect(path, contains(p.join('prescriptions', 'tmp')));
      expect(path.endsWith('.jpg'), isTrue);
      expect(p.basename(p.dirname(path)), 'tmp');
      expect(p.basename(p.dirname(p.dirname(path))), 'prescriptions');
      expect(await file.readAsBytes(), [1, 2, 3]);
      await store.delete(path);
      expect(await file.exists(), isFalse);
    });

    test('delete rejects paths outside the store root', () async {
      final store = PrescriptionImageStore(rootDirectory: rootDirectory);
      expect(
        () => store.delete(p.join(rootDirectory.parent.path, 'outside.jpg')),
        throwsArgumentError,
      );
    });
  });
}
