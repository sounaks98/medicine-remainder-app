import 'package:medicine_remainder_app/features/medicines/domain/medication_draft.dart';

/// In-memory editable row for prescription review (not persisted until Phase 5).
class EditableMedicineRow {
  EditableMedicineRow({
    required this.id,
    this.name = '',
    this.strength = '',
    this.strengthUnit = 'mg',
    this.count = '',
    this.frequency = '',
    this.duration = '',
    this.route = '',
    this.timing = '',
    this.doseInstructions = '',
    this.confirmed = false,
  });

  factory EditableMedicineRow.fromDraft(MedicineDraft draft, {required String id}) {
    return EditableMedicineRow(
      id: id,
      name: draft.name.value ?? '',
      strength: draft.strength.value ?? '',
      strengthUnit: draft.strengthUnit.value?.isNotEmpty == true
          ? draft.strengthUnit.value!
          : 'mg',
      count: draft.doseInstructions.value ?? '',
      frequency: draft.frequency.value ?? '',
      duration: draft.duration.value ?? '',
      route: draft.route.value ?? '',
      timing: draft.timing.value ?? '',
      doseInstructions: draft.doseInstructions.value ?? '',
    );
  }

  final String id;
  String name;
  String strength;
  String strengthUnit;
  String count;
  String frequency;
  String duration;
  String route;
  String timing;
  String doseInstructions;
  bool confirmed;

  bool get hasUncertainFields => !confirmed;

  static const strengthUnits = ['mg', 'ml', 'g', 'mcg', 'IU', '%'];
}
