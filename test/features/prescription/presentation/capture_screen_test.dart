import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:medicine_remainder_app/app/di/providers.dart';
import 'package:medicine_remainder_app/app/router.dart';
import 'package:medicine_remainder_app/features/medicines/domain/medication_draft.dart';
import 'package:medicine_remainder_app/features/prescription/data/prescription_image_store.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_ehr_draft.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_extraction_pipeline.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_import.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_review_bundle.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/capture_screen.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/document_verify_screen.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/prescription_review_screen.dart';
import 'package:medicine_remainder_app/services/ocr/ocr_result.dart';
import 'package:medicine_remainder_app/services/ocr/prescription_image_verifier.dart';
import 'package:medicine_remainder_app/shared/models/prescription_likelihood.dart';

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

class _FakePipeline implements PrescriptionExtractionPipeline {
  @override
  Future<DocumentCheckResult> checkDocument({required String imagePath}) async {
    return DocumentCheckResult(
      ocr: const OcrResult(version: 1, fullText: 'Dr. Test\nDrug 500 mg tab'),
      verification: const PrescriptionVerificationResult(
        likelihood: PrescriptionLikelihood.likely,
        summary: 'ok',
        signals: ['test'],
      ),
    );
  }

  @override
  Future<PrescriptionReviewBundle> extractUnified({
    required String imagePath,
    required OcrResult cachedOcr,
  }) async {
    return PrescriptionReviewBundle(
      verification: const PrescriptionVerificationResult(
        likelihood: PrescriptionLikelihood.likely,
        summary: 'ok',
        signals: [],
      ),
      extractionMethodLabel: 'test',
      ehr: PrescriptionEhrDraft.empty(),
      draft: MedicationExtractionDraft(
        schemaVersion: 1,
        prescriptionId: 'p',
        medicines: const [],
        rawOcrText: cachedOcr.fullText,
        extractionMethod: ExtractionMethod.ocrRules,
        createdAt: DateTime.utc(2026),
      ),
    );
  }
}

void main() {
  testWidgets('CaptureScreen opens document verify after gallery import', (
    tester,
  ) async {
    const savedPath = '/data/user/0/app/files/prescriptions/tmp/test.jpg';
    final fakeImport = _FakePrescriptionImport(
      onImportFromGallery: () async => savedPath,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          prescriptionImportProvider.overrideWithValue(fakeImport),
          prescriptionExtractionPipelineProvider.overrideWithValue(
            _FakePipeline(),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: GoRouter(
            initialLocation: AppRoutes.capture,
            routes: [
              GoRoute(
                path: AppRoutes.capture,
                builder: (context, state) => const CaptureScreen(),
              ),
              GoRoute(
                path: AppRoutes.documentVerify,
                builder: (context, state) {
                  final extra = state.extra! as DocumentVerifyRouteArgs;
                  return DocumentVerifyScreen(
                    imagePath: extra.imagePath,
                    imagePreview: const SizedBox.shrink(),
                  );
                },
              ),
              GoRoute(
                path: AppRoutes.prescriptionReview,
                builder: (context, state) {
                  final extra = state.extra! as PrescriptionReviewRouteArgs;
                  return PrescriptionReviewScreen(
                    imagePath: extra.imagePath,
                    bundle: extra.bundle,
                    imagePreview: const SizedBox.shrink(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('Choose from gallery'));
    await tester.pumpAndSettle();

    expect(fakeImport.galleryCalls, 1);
    expect(find.text('Check document'), findsOneWidget);
    expect(find.text('Likely prescription'), findsOneWidget);
  });
}
