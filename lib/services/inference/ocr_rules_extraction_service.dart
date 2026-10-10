import 'package:medicine_remainder_app/features/medicines/domain/medication_draft.dart';
import 'package:medicine_remainder_app/services/inference/medication_extraction_service.dart';
import 'package:medicine_remainder_app/shared/models/field_confidence.dart';
import 'package:uuid/uuid.dart';

/// Baseline parser over OCR text (P1-06). One row per non-instruction line;
/// light regex for strength (mg/ml) and count hints.
class OcrRulesExtractionService implements MedicationExtractionService {
  OcrRulesExtractionService({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  static const int medicationSchemaVersion = 1;

  static final _strengthPattern = RegExp(
    r'(\d+(?:\.\d+)?)\s*(mg|ml|g|mcg|iu|%)\b',
    caseSensitive: false,
  );

  static final _countPattern = RegExp(
    r'\b(\d+)\s*(tablet|tablets|tab|tabs|cap|caps|capsule|capsules|puff|puffs)\b',
    caseSensitive: false,
  );

  final Uuid _uuid;

  @override
  Future<ExtractionCapability> getCapability() async {
    return const ExtractionCapability(
      supportsVlm: false,
      modelDownloaded: false,
    );
  }

  @override
  Future<MedicationExtractionDraft> extract(ExtractionRequest request) async {
    final lines = _medicineLines(request.ocrText);
    final medicines = lines.map(_medicineFromLine).toList();
    if (medicines.isEmpty) {
      medicines.add(_emptyMedicine());
    }

    return MedicationExtractionDraft(
      schemaVersion: medicationSchemaVersion,
      prescriptionId: _uuid.v4(),
      medicines: medicines,
      rawOcrText: request.ocrText,
      extractionMethod: ExtractionMethod.ocrRules,
      createdAt: DateTime.now().toUtc(),
    );
  }

  @override
  Future<void> dispose() async {}

  static List<String> _medicineLines(String text) {
    return text
        .split(RegExp(r'\r?\n'))
        .map((line) => line.trim())
        .where((line) => line.length >= 2)
        .where((line) => !_looksLikeInstructionOnly(line))
        .toList();
  }

  static bool _looksLikeInstructionOnly(String line) {
    final lower = line.toLowerCase();
    const prefixes = [
      'take ',
      'apply ',
      'use ',
      'continue ',
      'stop ',
      'repeat ',
      'before ',
      'after ',
    ];
    for (final prefix in prefixes) {
      if (lower.startsWith(prefix)) {
        return true;
      }
    }
    return false;
  }

  MedicineDraft _medicineFromLine(String line) {
    final strengthMatch = _strengthPattern.firstMatch(line);
    final countMatch = _countPattern.firstMatch(line);

    String? strength;
    String? unit;
    if (strengthMatch != null) {
      strength = strengthMatch.group(1);
      unit = strengthMatch.group(2)?.toLowerCase();
      if (unit == 'iu') {
        unit = 'IU';
      }
    }

    var name = line;
    if (strengthMatch != null) {
      name = line.substring(0, strengthMatch.start).trim();
      name = name.replaceAll(RegExp(r'[,\-–]+$'), '').trim();
    }
    if (name.isEmpty) {
      name = line;
    }

    final strengthConfidence = strength != null
        ? FieldConfidence.uncertain
        : FieldConfidence.missing;
    final unitConfidence = unit != null
        ? FieldConfidence.uncertain
        : FieldConfidence.missing;
    final countText = countMatch?.group(0);

    return MedicineDraft(
      name: _field(name, FieldConfidence.uncertain),
      strength: _field(strength, strengthConfidence),
      strengthUnit: _field(unit, unitConfidence),
      doseInstructions: _field(countText, countText != null
          ? FieldConfidence.uncertain
          : FieldConfidence.missing),
      route: _missingString(),
      frequency: _missingString(),
      duration: _missingString(),
      timing: _missingString(),
      originalSourceText: MedicationField<String>(
        value: line,
        confidence: FieldConfidence.uncertain,
        sourceText: line,
        provenance: Provenance.rules,
        warnings: const ['Baseline rules parser; confirm all fields manually.'],
      ),
    );
  }

  MedicineDraft _emptyMedicine() {
    return MedicineDraft(
      name: _missingString(),
      strength: _missingString(),
      strengthUnit: _missingString(),
      doseInstructions: _missingString(),
      route: _missingString(),
      frequency: _missingString(),
      duration: _missingString(),
      timing: _missingString(),
      originalSourceText: _missingString(),
    );
  }

  static MedicationField<String> _field(
    String? value,
    FieldConfidence confidence,
  ) {
    return MedicationField<String>(
      value: value,
      confidence: confidence,
      sourceText: value,
      provenance: Provenance.rules,
    );
  }

  static MedicationField<String> _missingString() {
    return const MedicationField<String>(
      confidence: FieldConfidence.missing,
      provenance: Provenance.rules,
    );
  }
}
