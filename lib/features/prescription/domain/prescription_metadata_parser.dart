import 'package:medicine_remainder_app/features/medicines/domain/medication_draft.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_ehr_draft.dart';
import 'package:medicine_remainder_app/shared/models/field_confidence.dart';

/// Heuristic EHR field extraction from OCR text (merged into unified review).
class PrescriptionMetadataParser {
  const PrescriptionMetadataParser();

  PrescriptionEhrDraft parse(String ocrText) {
    final lines = ocrText
        .split(RegExp(r'\r?\n'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    return PrescriptionEhrDraft(
      doctorName: _field(_matchLine(lines, _doctorPattern)),
      facilityName: _field(_matchLine(lines, _facilityPattern)),
      diagnosis: _field(_matchLine(lines, _diagnosisPattern)),
      testsSuggested: _field(_matchLine(lines, _testsPattern)),
      notes: _field(_matchLine(lines, _notesPattern)),
    );
  }

  static final _doctorPattern = RegExp(
    r'^(?:dr\.?|doctor|physician)\s*[:\-]?\s*(.+)$',
    caseSensitive: false,
  );

  static final _facilityPattern = RegExp(
    r'^(?:hospital|clinic|pharmacy|medical\s+center)\s*[:\-]?\s*(.+)$',
    caseSensitive: false,
  );

  static final _diagnosisPattern = RegExp(
    r'^(?:diagnosis|dx)\s*[:\-]?\s*(.+)$',
    caseSensitive: false,
  );

  static final _testsPattern = RegExp(
    r'^(?:tests?|investigations?)\s*(?:suggested)?\s*[:\-]?\s*(.+)$',
    caseSensitive: false,
  );

  static final _notesPattern = RegExp(
    r'^(?:notes?|advice)\s*[:\-]?\s*(.+)$',
    caseSensitive: false,
  );

  static String? _matchLine(List<String> lines, RegExp pattern) {
    for (final line in lines) {
      final match = pattern.firstMatch(line);
      if (match != null) {
        final value = match.group(1)?.trim();
        if (value != null && value.isNotEmpty) {
          return value;
        }
      }
    }
    return null;
  }

  static MedicationField<String> _field(String? value) {
    if (value == null) {
      return const MedicationField<String>(
        confidence: FieldConfidence.missing,
        provenance: Provenance.rules,
      );
    }
    return MedicationField<String>(
      value: value,
      confidence: FieldConfidence.uncertain,
      sourceText: value,
      provenance: Provenance.rules,
    );
  }
}
