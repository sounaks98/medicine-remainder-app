import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:medicine_remainder_app/features/prescription/data/prescription_image_store.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_extraction_orchestrator.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_extraction_pipeline.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_import.dart';
import 'package:medicine_remainder_app/services/inference/image_preprocessor.dart';
import 'package:medicine_remainder_app/services/inference/ocr_rules_extraction_service.dart';
import 'package:medicine_remainder_app/services/ocr/mlkit_ocr_service.dart';
import 'package:medicine_remainder_app/services/inference/gemma3n_litert_service.dart';
import 'package:medicine_remainder_app/services/ocr/prescription_image_verifier.dart';

final prescriptionImageStoreProvider = Provider<PrescriptionImageStore>(
  (ref) => const PrescriptionImageStore(),
);

final prescriptionImportProvider = Provider<PrescriptionImport>(
  (ref) => PrescriptionImport(
    imageStore: ref.watch(prescriptionImageStoreProvider),
  ),
);

final imagePreprocessorProvider = Provider<ImagePreprocessor>(
  (ref) => const ImagePreprocessor(),
);

final mlkitOcrServiceProvider = Provider<MlkitOcrService>((ref) {
  final service = MlkitOcrService(
    preprocessor: ref.watch(imagePreprocessorProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});

final ocrRulesExtractionServiceProvider = Provider<OcrRulesExtractionService>(
  (ref) => OcrRulesExtractionService(),
);

final prescriptionImageVerifierProvider = Provider<PrescriptionImageVerifier>(
  (ref) => PrescriptionImageVerifier(),
);

final gemma3nLitertServiceProvider =
    ChangeNotifierProvider<Gemma3nLitertService>((ref) {
      final service = Gemma3nLitertService();
      ref.onDispose(service.dispose);
      return service;
    });

final prescriptionExtractionPipelineProvider =
    Provider<PrescriptionExtractionPipeline>((ref) {
      return PrescriptionExtractionOrchestrator(
        ocrService: ref.watch(mlkitOcrServiceProvider),
        verifier: ref.watch(prescriptionImageVerifierProvider),
        rulesExtractor: ref.watch(ocrRulesExtractionServiceProvider),
      );
    });
