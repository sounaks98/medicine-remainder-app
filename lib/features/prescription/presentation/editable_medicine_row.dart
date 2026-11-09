import 'package:medicine_remainder_app/features/medicines/domain/medication_draft.dart';
import 'package:medicine_remainder_app/features/reminders/domain/medication_reminder_schedule.dart';

/// In-memory editable row for prescription review (not persisted until confirm).
class EditableMedicineRow {
  EditableMedicineRow({
    required this.id,
    this.name = '',
    this.strength = '',
    this.strengthUnit = 'mg',
    this.count = '',
    this.route = '',
    this.prescriptionFrequency = '',
    this.prescriptionTiming = '',
    this.additionalNotes = '',
    MedicationReminderSchedule? reminderSchedule,
    this.confirmed = false,
  }) : reminderSchedule = reminderSchedule ?? MedicationReminderSchedule.defaults();

  factory EditableMedicineRow.fromDraft(MedicineDraft draft, {required String id}) {
    final frequency = draft.frequency.value ?? '';
    final timing = draft.timing.value ?? '';
    return EditableMedicineRow(
      id: id,
      name: draft.name.value ?? '',
      strength: draft.strength.value ?? '',
      strengthUnit: draft.strengthUnit.value?.isNotEmpty == true
          ? draft.strengthUnit.value!
          : 'mg',
      count: draft.doseInstructions.value ?? '',
      route: draft.route.value ?? '',
      prescriptionFrequency: frequency,
      prescriptionTiming: timing,
      additionalNotes: draft.originalSourceText.value ?? '',
      reminderSchedule: MedicationReminderSchedule.defaults(),
    );
  }

  final String id;
  String name;
  String strength;
  String strengthUnit;
  String count;
  String route;
  /// OCR / prescription frequency text (not used to infer interval hours).
  String prescriptionFrequency;
  /// OCR / prescription timing text (shown for review; offset defaults stay UI-only).
  String prescriptionTiming;
  String additionalNotes;
  MedicationReminderSchedule reminderSchedule;
  bool confirmed;

  bool get hasUncertainFields => !confirmed;

  String get prescriptionInstructionsSummary {
    final parts = <String>[
      if (prescriptionFrequency.trim().isNotEmpty) prescriptionFrequency.trim(),
      if (prescriptionTiming.trim().isNotEmpty) prescriptionTiming.trim(),
    ];
    return parts.join(' · ');
  }

  static const strengthUnits = ['mg', 'ml', 'g', 'mcg', 'IU', '%'];
}
