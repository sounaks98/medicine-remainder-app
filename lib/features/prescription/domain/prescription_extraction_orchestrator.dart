import 'package:medicine_remainder_app/features/medicines/domain/medication_draft.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_extraction_pipeline.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_metadata_parser.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_review_bundle.dart';
import 'package:medicine_remainder_app/services/inference/medication_extraction_service.dart';
import 'package:medicine_remainder_app/services/inference/ocr_rules_extraction_service.dart';
import 'package:medicine_remainder_app/services/inference/smolvlm_onnx_extraction_service.dart';
import 'package:medicine_remainder_app/services/ocr/mlkit_ocr_service.dart';
import 'package:medicine_remainder_app/services/ocr/ocr_result.dart';
import 'package:medicine_remainder_app/services/ocr/prescription_image_verifier.dart';

/// Runs OCR, verification, rules, and optional VLM; returns one merged bundle.
class PrescriptionExtractionOrchestrator implements PrescriptionExtractionPipeline {
  PrescriptionExtractionOrchestrator({
    required MlkitOcrService ocrService,
    required PrescriptionImageVerifier verifier,
    required OcrRulesExtractionService rulesExtractor,
    SmolVlmOnnxExtractionService? vlmExtractor,
    PrescriptionMetadataParser? metadataParser,
  })  : _ocrService = ocrService,
        _verifier = verifier,
        _rulesExtractor = rulesExtractor,
        _vlmExtractor = vlmExtractor ?? SmolVlmOnnxExtractionService(),
        _metadataParser = metadataParser ?? const PrescriptionMetadataParser();

  final MlkitOcrService _ocrService;
  final PrescriptionImageVerifier _verifier;
  final OcrRulesExtractionService _rulesExtractor;
  final SmolVlmOnnxExtractionService _vlmExtractor;
  final PrescriptionMetadataParser _metadataParser;

  @override
  Future<DocumentCheckResult> checkDocument({required String imagePath}) async {
    final ocr = await _ocrService.recognizeFromPath(imagePath);
    final verification = await _verifier.verify(
      imagePath: imagePath,
      ocrText: ocr.fullText,
    );
    return DocumentCheckResult(ocr: ocr, verification: verification);
  }

  @override
  Future<PrescriptionReviewBundle> extractUnified({
    required String imagePath,
    required OcrResult cachedOcr,
  }) async {
    final ocr = cachedOcr;
    final verification = await _verifier.verify(
      imagePath: imagePath,
      ocrText: ocr.fullText,
    );

    final rulesDraft = await _rulesExtractor.extract(
      ExtractionRequest(imagePath: imagePath, ocrText: ocr.fullText),
    );

    final vlmCapability = await _vlmExtractor.getCapability();
    MedicationExtractionDraft merged = rulesDraft;
    var methodLabel = 'On-device OCR + rules';

    if (vlmCapability.modelDownloaded) {
      try {
        final vlmDraft = await _vlmExtractor.extract(
          ExtractionRequest(imagePath: imagePath, ocrText: ocr.fullText),
        );
        merged = _mergeDrafts(rulesDraft, vlmDraft);
        methodLabel = 'Unified (OCR + rules + SmolVLM)';
      } catch (_) {
        methodLabel = 'On-device OCR + rules (VLM unavailable)';
      }
    }

    final ehr = _metadataParser.parse(ocr.fullText);

    return PrescriptionReviewBundle(
      verification: verification,
      draft: merged,
      ehr: ehr,
      extractionMethodLabel: methodLabel,
    );
  }

  static MedicationExtractionDraft _mergeDrafts(
    MedicationExtractionDraft rules,
    MedicationExtractionDraft vlm,
  ) {
    return MedicationExtractionDraft(
      schemaVersion: rules.schemaVersion,
      prescriptionId: rules.prescriptionId,
      medicines: vlm.medicines.isNotEmpty ? vlm.medicines : rules.medicines,
      rawOcrText: rules.rawOcrText,
      rawModelOutput: vlm.rawModelOutput,
      extractionMethod: ExtractionMethod.smolvlmOnnx,
      createdAt: rules.createdAt,
    );
  }
}
