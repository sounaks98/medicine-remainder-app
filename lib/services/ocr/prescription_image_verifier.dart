import 'package:medicine_remainder_app/services/ocr/prescription_vlm_classifier.dart';
import 'package:medicine_remainder_app/shared/models/prescription_likelihood.dart';

class PrescriptionVerificationResult {
  const PrescriptionVerificationResult({
    required this.likelihood,
    required this.summary,
    required this.signals,
    this.vlmAssisted = false,
  });

  final PrescriptionLikelihood likelihood;
  final String summary;
  final List<String> signals;
  final bool vlmAssisted;
}

/// Rules-first prescription detection; VLM may override when available.
class PrescriptionImageVerifier {
  PrescriptionImageVerifier({
    PrescriptionVlmClassifier? vlmClassifier,
  }) : _vlmClassifier = vlmClassifier ?? UnavailablePrescriptionVlmClassifier();

  static final _medicationKeywords = RegExp(
    r'\b(tab|tablet|capsule|cap|syrup|injection|mg|ml|mcg|dose|rx|prescription)\b',
    caseSensitive: false,
  );

  static final _clinicianKeywords = RegExp(
    r'\b(dr\.?|doctor|physician|clinic|hospital|mbbs|md)\b',
    caseSensitive: false,
  );

  final PrescriptionVlmClassifier _vlmClassifier;

  Future<PrescriptionVerificationResult> verify({
    required String imagePath,
    required String ocrText,
  }) async {
    final vlmLikelihood = await _vlmClassifier.classifyPrescription(
      imagePath: imagePath,
    );
    if (vlmLikelihood != null) {
      return PrescriptionVerificationResult(
        likelihood: vlmLikelihood,
        summary: _summaryFor(vlmLikelihood),
        signals: const ['SmolVLM document classification'],
        vlmAssisted: true,
      );
    }

    return _verifyWithRules(ocrText);
  }

  PrescriptionVerificationResult _verifyWithRules(String ocrText) {
    final trimmed = ocrText.trim();
    if (trimmed.length < 12) {
      return const PrescriptionVerificationResult(
        likelihood: PrescriptionLikelihood.unlikely,
        summary: 'Very little text was found on this image.',
        signals: ['Insufficient OCR text length'],
      );
    }

    final signals = <String>[];
    var score = 0;

    if (_medicationKeywords.hasMatch(trimmed)) {
      score += 2;
      signals.add('Medication or dosage keywords detected');
    }
    if (_clinicianKeywords.hasMatch(trimmed)) {
      score += 1;
      signals.add('Clinician or facility keywords detected');
    }
    if (RegExp(r'\d').hasMatch(trimmed)) {
      score += 1;
      signals.add('Numeric dosage patterns present');
    }
    if (trimmed.split(RegExp(r'\r?\n')).where((l) => l.trim().length > 2).length >= 2) {
      score += 1;
      signals.add('Structured multi-line layout');
    }

    final likelihood = switch (score) {
      >= 4 => PrescriptionLikelihood.likely,
      >= 2 => PrescriptionLikelihood.uncertain,
      _ => PrescriptionLikelihood.unlikely,
    };

    return PrescriptionVerificationResult(
      likelihood: likelihood,
      summary: _summaryFor(likelihood),
      signals: signals,
    );
  }

  static String _summaryFor(PrescriptionLikelihood likelihood) {
    return switch (likelihood) {
      PrescriptionLikelihood.likely =>
        'This image looks like a prescription or clinical order.',
      PrescriptionLikelihood.uncertain =>
        'This may be a prescription. Please verify before continuing.',
      PrescriptionLikelihood.unlikely =>
        'This does not look like a prescription. Try a clearer Rx photo.',
    };
  }
}
