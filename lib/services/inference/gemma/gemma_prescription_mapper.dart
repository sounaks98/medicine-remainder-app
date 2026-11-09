import 'package:medicine_remainder_app/features/medicines/domain/medication_draft.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_ehr_draft.dart';
import 'package:medicine_remainder_app/shared/models/field_confidence.dart';
import 'package:uuid/uuid.dart';

class GemmaPrescriptionMapper {
  GemmaPrescriptionMapper({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  static const int medicationSchemaVersion = 1;

  final Uuid _uuid;

  PrescriptionEhrDraft toEhrDraft(Map<String, dynamic> json) {
    return PrescriptionEhrDraft(
      doctorName: _ehrField(json['prescriber']),
      facilityName: _ehrMissing(),
      diagnosis: _ehrMissing(),
      testsSuggested: _ehrMissing(),
      notes: _ehrNotes(json),
    );
  }

  MedicationField<String> _ehrNotes(Map<String, dynamic> json) {
    final parts = <String>[];
    final patient = json['patient_name']?.toString().trim();
    final date = json['prescription_date']?.toString().trim();
    final notes = json['notes']?.toString().trim();
    if (patient != null && patient.isNotEmpty) {
      parts.add('Patient: $patient');
    }
    if (date != null && date.isNotEmpty) {
      parts.add('Date: $date');
    }
    if (notes != null && notes.isNotEmpty) {
      parts.add(notes);
    }
    if (parts.isEmpty) {
      return _ehrMissing();
    }
    final text = parts.join(' · ');
    return MedicationField<String>(
      value: text,
      confidence: FieldConfidence.uncertain,
      provenance: Provenance.vlm,
      sourceText: text,
    );
  }

  MedicationField<String> _ehrField(Object? raw) {
    if (raw == null) {
      return _ehrMissing();
    }
    final text = raw.toString().trim();
    if (text.isEmpty) {
      return _ehrMissing();
    }
    return MedicationField<String>(
      value: text,
      confidence: FieldConfidence.uncertain,
      provenance: Provenance.vlm,
      sourceText: text,
    );
  }

  MedicationField<String> _ehrMissing() {
    return const MedicationField<String>(
      confidence: FieldConfidence.missing,
      provenance: Provenance.vlm,
    );
  }

  MedicationExtractionDraft toDraft({
    required Map<String, dynamic> json,
    required String rawModelOutput,
    required String ocrText,
    required String userId,
  }) {
    final medicinesRaw = json['medicines'];
    final medicines = <MedicineDraft>[];
    if (medicinesRaw is List) {
      for (final entry in medicinesRaw) {
        if (entry is! Map) continue;
        final map = Map<String, dynamic>.from(entry.cast<String, dynamic>());
        medicines.add(_medicineFromGemma(map));
      }
    }

    return MedicationExtractionDraft(
      schemaVersion: medicationSchemaVersion,
      prescriptionId: _uuid.v4(),
      userId: userId,
      medicines: medicines.isEmpty ? [_emptyMedicine()] : medicines,
      rawOcrText: ocrText,
      rawModelOutput: rawModelOutput,
      extractionMethod: ExtractionMethod.gemma3n,
      createdAt: DateTime.now().toUtc(),
    );
  }

  MedicineDraft _medicineFromGemma(Map<String, dynamic> json) {
    final confidenceLabel = (json['confidence'] as String?)?.toLowerCase();
    final needsVerification = json['needs_verification'] == true;
    final confidence = _confidenceFromGemma(confidenceLabel, needsVerification);

    final name = _field(json['name'], confidence);
    final strength = _field(json['strength'], confidence);
    final dose = _field(json['dose'], confidence);
    final frequency = _field(json['frequency'], confidence);
    final duration = _field(json['duration'], confidence);
    final route = _field(json['route'], confidence);
    final instructions = _field(json['instructions'], confidence);

    final resolvedConfidence = _downgradeIfNeeded(
      confidence,
      name: name,
      dose: dose,
      needsVerification: needsVerification,
    );

    return MedicineDraft(
      name: name.copyWith(confidence: resolvedConfidence),
      strength: strength.copyWith(confidence: resolvedConfidence),
      strengthUnit: const MedicationField<String>(
        confidence: FieldConfidence.missing,
        provenance: Provenance.vlm,
      ),
      doseInstructions: dose.copyWith(confidence: resolvedConfidence),
      route: route.copyWith(confidence: resolvedConfidence),
      frequency: frequency.copyWith(confidence: resolvedConfidence),
      duration: duration.copyWith(confidence: resolvedConfidence),
      timing: const MedicationField<String>(
        confidence: FieldConfidence.missing,
        provenance: Provenance.vlm,
      ),
      startAt: const MedicationField<String>(
        confidence: FieldConfidence.missing,
        provenance: Provenance.vlm,
      ),
      endAt: const MedicationField<String>(
        confidence: FieldConfidence.missing,
        provenance: Provenance.vlm,
      ),
      originalSourceText: instructions.copyWith(confidence: resolvedConfidence),
    );
  }

  MedicationField<String> _field(Object? raw, FieldConfidence base) {
    if (raw == null) {
      return MedicationField<String>(
        confidence: FieldConfidence.missing,
        provenance: Provenance.vlm,
        warnings: const ['missing_in_model_output'],
      );
    }
    final text = raw.toString().trim();
    if (text.isEmpty) {
      return MedicationField<String>(
        confidence: FieldConfidence.missing,
        provenance: Provenance.vlm,
        warnings: const ['empty_in_model_output'],
      );
    }
    return MedicationField<String>(
      value: text,
      confidence: base,
      provenance: Provenance.vlm,
      sourceText: text,
    );
  }

  FieldConfidence _confidenceFromGemma(String? label, bool needsVerification) {
    if (needsVerification) {
      return FieldConfidence.uncertain;
    }
    return switch (label) {
      'high' => FieldConfidence.known,
      'medium' => FieldConfidence.uncertain,
      'low' => FieldConfidence.uncertain,
      _ => FieldConfidence.uncertain,
    };
  }

  FieldConfidence _downgradeIfNeeded(
    FieldConfidence base, {
    required MedicationField<String> name,
    required MedicationField<String> dose,
    required bool needsVerification,
  }) {
    if (needsVerification) return FieldConfidence.uncertain;
    if (name.value == null || dose.value == null) {
      return FieldConfidence.uncertain;
    }
    if (base == FieldConfidence.known) return FieldConfidence.known;
    return base;
  }

  MedicineDraft _emptyMedicine() {
    return MedicineDraft(
      name: const MedicationField<String>(
        confidence: FieldConfidence.missing,
        provenance: Provenance.vlm,
      ),
      strength: const MedicationField<String>(
        confidence: FieldConfidence.missing,
        provenance: Provenance.vlm,
      ),
      strengthUnit: const MedicationField<String>(
        confidence: FieldConfidence.missing,
        provenance: Provenance.vlm,
      ),
      doseInstructions: const MedicationField<String>(
        confidence: FieldConfidence.missing,
        provenance: Provenance.vlm,
      ),
      route: const MedicationField<String>(
        confidence: FieldConfidence.missing,
        provenance: Provenance.vlm,
      ),
      frequency: const MedicationField<String>(
        confidence: FieldConfidence.missing,
        provenance: Provenance.vlm,
      ),
      duration: const MedicationField<String>(
        confidence: FieldConfidence.missing,
        provenance: Provenance.vlm,
      ),
      timing: const MedicationField<String>(
        confidence: FieldConfidence.missing,
        provenance: Provenance.vlm,
      ),
      startAt: const MedicationField<String>(
        confidence: FieldConfidence.missing,
        provenance: Provenance.vlm,
      ),
      endAt: const MedicationField<String>(
        confidence: FieldConfidence.missing,
        provenance: Provenance.vlm,
      ),
      originalSourceText: const MedicationField<String>(
        confidence: FieldConfidence.missing,
        provenance: Provenance.vlm,
      ),
    );
  }
}
