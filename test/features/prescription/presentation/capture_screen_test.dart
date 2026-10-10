import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/app/di/providers.dart';
import 'package:medicine_remainder_app/features/prescription/data/prescription_image_store.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_import.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/capture_screen.dart';

class _FakePrescriptionImport extends PrescriptionImport {
  _FakePrescriptionImport({required this.onImportFromGallery})
      : super(imageStore: const PrescriptionImageStore());

  final Future<String?> Function() onImportFromGallery;
  int galleryCalls = 0;

  @override
  Future<String?> importFromGallery() async {
    galleryCalls++;
    return onImportFromGallery();
  }
}

void main() {
  testWidgets('CaptureScreen shows import actions and saved path', (tester) async {
    const savedPath = '/data/user/0/app/files/prescriptions/tmp/test.jpg';
    final fakeImport = _FakePrescriptionImport(
      onImportFromGallery: () async => savedPath,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          prescriptionImportProvider.overrideWithValue(fakeImport),
        ],
        child: const MaterialApp(home: CaptureScreen()),
      ),
    );

    expect(find.text('Take photo'), findsOneWidget);
    expect(find.text('Choose from gallery'), findsOneWidget);

    await tester.tap(find.text('Choose from gallery'));
    await tester.pump();
    await tester.pump();

    expect(fakeImport.galleryCalls, 1);
    expect(find.textContaining('prescriptions/tmp/test.jpg'), findsOneWidget);
    expect(find.text('Prescription image saved on device.'), findsOneWidget);
  });
}
