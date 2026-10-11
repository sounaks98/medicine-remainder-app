import 'package:flutter/material.dart';
import 'package:medicine_remainder_app/features/medicines/domain/medication_draft.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_import.dart';
import 'package:medicine_remainder_app/shared/models/field_confidence.dart';
import 'package:medicine_remainder_app/shared/validation/extraction_validator.dart';

class ExtractionReviewRouteArgs {
  const ExtractionReviewRouteArgs({
    required this.draft,
    required this.userId,
    this.imagePath,
    this.prescriptionImport,
  });

  final MedicationExtractionDraft draft;
  final String userId;
  final String? imagePath;
  final PrescriptionImport? prescriptionImport;
}

/// Field-level edit UI with warnings for uncertain values (P4-03).
class ExtractionReviewScreen extends StatefulWidget {
  const ExtractionReviewScreen({
    super.key,
    required this.draft,
    required this.userId,
    this.imagePath,
    this.prescriptionImport,
    this.validator = const ExtractionValidator(),
  });

  final MedicationExtractionDraft draft;
  final String userId;
  final String? imagePath;
  final PrescriptionImport? prescriptionImport;
  final ExtractionValidator validator;

  @override
  State<ExtractionReviewScreen> createState() => _ExtractionReviewScreenState();
}

class _ExtractionReviewScreenState extends State<ExtractionReviewScreen> {
  late List<_EditableMedicine> _medicines;
  String? _confirmError;

  @override
  void initState() {
    super.initState();
    _medicines = widget.draft.medicines
        .map(_EditableMedicine.fromDraft)
        .toList();
    if (_medicines.isEmpty) {
      _medicines.add(_EditableMedicine.empty());
    }
  }

  MedicationExtractionDraft _buildDraft() {
    return widget.draft.copyWith(
      userId: widget.userId,
      medicines: _medicines.map((m) => m.toDraft()).toList(),
    );
  }

  ExtractionValidationResult _validation() {
    return widget.validator.validateDraft(_buildDraft());
  }

  Future<void> _confirm() async {
    final validation = _validation();
    if (!validation.canConfirm) {
      setState(() => _confirmError = validation.errors.join('\n'));
      return;
    }
    final import = widget.prescriptionImport;
    if (import == null) {
      setState(() {
        _confirmError = 'Confirm handler not configured.';
      });
      return;
    }
    try {
      final records = await import.confirmExtraction(
        draft: _buildDraft(),
        userId: widget.userId,
        imagePath: widget.imagePath,
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Confirmed ${records.length} medicine(s). Reminders unlock after scheduling.',
          ),
        ),
      );
      Navigator.of(context).pop(records);
    } on ConfirmExtractionException catch (e) {
      setState(() => _confirmError = e.errors.join('\n'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final validation = _validation();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Review extraction')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Edit extracted fields. Uncertain values are highlighted; '
            'nothing is saved until you confirm.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          for (final warning in validation.warnings)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: MaterialBanner(
                content: Text(warning),
                leading: const Icon(Icons.warning_amber_outlined),
                actions: [
                  TextButton(
                    onPressed: () =>
                        ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          if (_confirmError != null) ...[
            Text(
              _confirmError!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
          ],
          for (var i = 0; i < _medicines.length; i++)
            _MedicineCard(
              index: i,
              medicine: _medicines[i],
              onChanged: () => setState(() {}),
            ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _confirm,
            child: const Text('Confirm medicines'),
          ),
        ],
      ),
    );
  }
}

class _MedicineCard extends StatelessWidget {
  const _MedicineCard({
    required this.index,
    required this.medicine,
    required this.onChanged,
  });

  final int index;
  final _EditableMedicine medicine;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Medicine ${index + 1}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _FieldEditor(
              label: 'Name',
              value: medicine.name,
              confidence: medicine.nameConfidence,
              onChanged: (v) {
                medicine.name = v;
                medicine.nameConfidence = FieldConfidence.known;
                onChanged();
              },
            ),
            _FieldEditor(
              label: 'Strength',
              value: medicine.strength,
              confidence: medicine.strengthConfidence,
              onChanged: (v) {
                medicine.strength = v;
                medicine.strengthConfidence = FieldConfidence.known;
                onChanged();
              },
            ),
            _FieldEditor(
              label: 'Unit',
              value: medicine.strengthUnit,
              confidence: medicine.strengthUnitConfidence,
              onChanged: (v) {
                medicine.strengthUnit = v;
                medicine.strengthUnitConfidence = FieldConfidence.known;
                onChanged();
              },
            ),
            _FieldEditor(
              label: 'Frequency',
              value: medicine.frequency,
              confidence: medicine.frequencyConfidence,
              onChanged: (v) {
                medicine.frequency = v;
                medicine.frequencyConfidence = FieldConfidence.known;
                onChanged();
              },
            ),
            _FieldEditor(
              label: 'Dose instructions',
              value: medicine.doseInstructions,
              confidence: medicine.doseInstructionsConfidence,
              onChanged: (v) {
                medicine.doseInstructions = v;
                medicine.doseInstructionsConfidence = FieldConfidence.known;
                onChanged();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldEditor extends StatelessWidget {
  const _FieldEditor({
    required this.label,
    required this.value,
    required this.confidence,
    required this.onChanged,
  });

  final String label;
  final String value;
  final FieldConfidence confidence;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showWarning = confidence == FieldConfidence.uncertain;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          helperText: showWarning ? 'Uncertain — please verify' : null,
          helperStyle: showWarning
              ? theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.tertiary)
              : null,
          border: const OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _EditableMedicine {
  _EditableMedicine({
    required this.name,
    required this.strength,
    required this.strengthUnit,
    required this.frequency,
    required this.doseInstructions,
    required this.nameConfidence,
    required this.strengthConfidence,
    required this.strengthUnitConfidence,
    required this.frequencyConfidence,
    required this.doseInstructionsConfidence,
    required this.sourceLine,
  });

  factory _EditableMedicine.fromDraft(MedicineDraft draft) {
    return _EditableMedicine(
      name: draft.name.value ?? '',
      strength: draft.strength.value ?? '',
      strengthUnit: draft.strengthUnit.value ?? '',
      frequency: draft.frequency.value ?? '',
      doseInstructions: draft.doseInstructions.value ?? '',
      nameConfidence: draft.name.confidence,
      strengthConfidence: draft.strength.confidence,
      strengthUnitConfidence: draft.strengthUnit.confidence,
      frequencyConfidence: draft.frequency.confidence,
      doseInstructionsConfidence: draft.doseInstructions.confidence,
      sourceLine: draft.originalSourceText.value ?? '',
    );
  }

  factory _EditableMedicine.empty() {
    return _EditableMedicine(
      name: '',
      strength: '',
      strengthUnit: '',
      frequency: '',
      doseInstructions: '',
      nameConfidence: FieldConfidence.missing,
      strengthConfidence: FieldConfidence.missing,
      strengthUnitConfidence: FieldConfidence.missing,
      frequencyConfidence: FieldConfidence.missing,
      doseInstructionsConfidence: FieldConfidence.missing,
      sourceLine: '',
    );
  }

  String name;
  String strength;
  String strengthUnit;
  String frequency;
  String doseInstructions;
  FieldConfidence nameConfidence;
  FieldConfidence strengthConfidence;
  FieldConfidence strengthUnitConfidence;
  FieldConfidence frequencyConfidence;
  FieldConfidence doseInstructionsConfidence;
  String sourceLine;

  MedicineDraft toDraft() {
    MedicationField<String> field(
      String value,
      FieldConfidence confidence, {
      String? source,
    }) {
      final trimmed = value.trim();
      return MedicationField<String>(
        value: trimmed.isEmpty ? null : trimmed,
        confidence: trimmed.isEmpty ? FieldConfidence.missing : confidence,
        sourceText: source ?? (trimmed.isEmpty ? null : trimmed),
        provenance: Provenance.user,
      );
    }

    return MedicineDraft(
      name: field(name, nameConfidence),
      strength: field(strength, strengthConfidence),
      strengthUnit: field(strengthUnit, strengthUnitConfidence),
      doseInstructions: field(doseInstructions, doseInstructionsConfidence),
      route: field('', FieldConfidence.missing),
      frequency: field(frequency, frequencyConfidence),
      duration: field('', FieldConfidence.missing),
      timing: field('', FieldConfidence.missing),
      startAt: field('', FieldConfidence.missing),
      endAt: field('', FieldConfidence.missing),
      originalSourceText: field(sourceLine, FieldConfidence.uncertain),
    );
  }
}
