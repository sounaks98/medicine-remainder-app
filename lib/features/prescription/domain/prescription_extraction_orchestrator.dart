import 'dart:convert';

import 'package:medicine_remainder_app/features/medicines/domain/medication_draft.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_extraction_pipeline.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_ehr_draft.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_review_bundle.dart';
import 'package:medicine_remainder_app/services/inference/gemma/gemma_prescription_mapper.dart';
import 'package:medicine_remainder_app/services/inference/gemma_extraction_service.dart';
import 'package:medicine_remainder_app/services/inference/medication_extraction_service.dart';
import 'package:medicine_remainder_app/services/ocr/ocr_result.dart';
import 'package:medicine_remainder_app/services/ocr/prescription_image_verifier.dart';
import 'package:medicine_remainder_app/shared/models/prescription_likelihood.dart';

/// Prescription flow: on-device Gemma 3n vision extraction only (no ML Kit OCR / rules).
class PrescriptionExtractionOrchestrator implements PrescriptionExtractionPipeline {
  PrescriptionExtractionOrchestrator({
    GemmaExtractionService? gemmaExtractor,
    GemmaPrescriptionMapper? gemmaMapper,
  })  : _gemmaExtractor = gemmaExtractor ?? GemmaExtractionService(),
        _gemmaMapper = gemmaMapper ?? GemmaPrescriptionMapper();

  final GemmaExtractionService _gemmaExtractor;
  final GemmaPrescriptionMapper _gemmaMapper;

  static const _emptyOcr = OcrResult(version: 1, fullText: '');

  @override
  Future<DocumentCheckResult> checkDocument({required String imagePath}) async {
    final status = await _gemmaExtractor.modelStatus();
    final capability = await _gemmaExtractor.getCapability();

    if (!capability.modelDownloaded) {
      return DocumentCheckResult(
        ocr: _emptyOcr,
        verification: PrescriptionVerificationResult(
          likelihood: PrescriptionLikelihood.unlikely,
          summary:
              'Gemma weights are not in the installed APK (still ~300 MB?). '
              'Rebuild with packageGemmaInDebug=true, then reinstall the ~4 GB APK. '
              '${status.error != null ? "Native: ${status.error}" : ""}',
          signals: const [
            'Gemma CHECKSUM not found in app assets',
            'Uninstall old app, then flutter run -d <device>',
          ],
        ),
      );
    }

    if (!capability.supportsVlm) {
      return DocumentCheckResult(
        ocr: _emptyOcr,
        verification: PrescriptionVerificationResult(
          likelihood: PrescriptionLikelihood.unlikely,
          summary: status.compatibilityError ??
              'This device cannot run Gemma 3n right now.',
          signals: const ['Gemma packaged but device check failed'],
        ),
      );
    }

    return DocumentCheckResult(
      ocr: _emptyOcr,
      verification: const PrescriptionVerificationResult(
        likelihood: PrescriptionLikelihood.likely,
        summary:
            'Ready for on-device Gemma 3n. The image will be analyzed directly '
            '(no OCR step).',
        signals: ['On-device Gemma 3n'],
      ),
    );
  }

  @override
  Future<PrescriptionReviewBundle> extractUnified({
    required String imagePath,
    required OcrResult cachedOcr,
    void Function(String stageLabel)? onProgress,
  }) async {
    assert(cachedOcr.version >= 1);
    final capability = await _gemmaExtractor.getCapability();
    if (!capability.supportsVlm || !capability.modelDownloaded) {
      throw StateError(
        'Gemma 3n is not packaged on this device. '
        'Build and install a release APK with model weights.',
      );
    }

    _gemmaExtractor.onProgress = (progress) {
      onProgress?.call(progress.label);
    };
    try {
      final gemmaDraft = await _gemmaExtractor.extract(
        ExtractionRequest(imagePath: imagePath, ocrText: ''),
      );

      if (!_gemmaHasUsableMedicines(gemmaDraft)) {
        throw StateError(
          'Gemma could not extract medicine rows from this image. '
          'Try a clearer photo or another prescription.',
        );
      }

      final ehr = _ehrFromGemmaOutput(gemmaDraft.rawModelOutput);

      return PrescriptionReviewBundle(
        verification: const PrescriptionVerificationResult(
          likelihood: PrescriptionLikelihood.likely,
          summary: 'Extracted with on-device Gemma 3n.',
          signals: ['On-device Gemma 3n vision'],
        ),
        draft: gemmaDraft,
        ehr: ehr,
        extractionMethodLabel: 'On-device Gemma 3n',
      );
    } finally {
      _gemmaExtractor.onProgress = null;
    }
  }

  PrescriptionEhrDraft _ehrFromGemmaOutput(String? rawModelOutput) {
    if (rawModelOutput == null || rawModelOutput.isEmpty) {
      return PrescriptionEhrDraft.empty();
    }
    try {
      final decoded = jsonDecode(rawModelOutput);
      if (decoded is! Map) {
        return PrescriptionEhrDraft.empty();
      }
      return _gemmaMapper.toEhrDraft(
        Map<String, dynamic>.from(decoded.cast<String, dynamic>()),
      );
    } catch (_) {
      return PrescriptionEhrDraft.empty();
    }
  }

  static bool _gemmaHasUsableMedicines(MedicationExtractionDraft draft) {
    if (draft.medicines.isEmpty) return false;
    return draft.medicines.any(
      (medicine) =>
          medicine.name.value != null && medicine.name.value!.trim().isNotEmpty,
    );
  }
}
