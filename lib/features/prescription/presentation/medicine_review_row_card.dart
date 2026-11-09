import 'package:flutter/material.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/editable_medicine_row.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/medicine_review_schedule_section.dart';
import 'package:medicine_remainder_app/features/reminders/domain/meal_schedule_resolver.dart';
import 'package:medicine_remainder_app/features/reminders/domain/medication_reminder_schedule.dart';
import 'package:medicine_remainder_app/features/users/domain/user_meal_profile.dart';

class MedicineReviewRowCard extends StatefulWidget {
  const MedicineReviewRowCard({
    super.key,
    required this.index,
    required this.row,
    required this.userId,
    required this.mealProfile,
    required this.onChanged,
    required this.onConfirm,
    required this.onReject,
  });

  final int index;
  final EditableMedicineRow row;
  final String userId;
  final UserMealProfile mealProfile;
  final VoidCallback onChanged;
  final VoidCallback onConfirm;
  final VoidCallback onReject;

  @override
  State<MedicineReviewRowCard> createState() => _MedicineReviewRowCardState();
}

class _MedicineReviewRowCardState extends State<MedicineReviewRowCard> {
  late final TextEditingController _name;
  late final TextEditingController _strength;
  late final TextEditingController _count;
  late final TextEditingController _route;
  late final TextEditingController _prescriptionInstructions;
  late final TextEditingController _notes;

  EditableMedicineRow get row => widget.row;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: row.name);
    _strength = TextEditingController(text: row.strength);
    _count = TextEditingController(text: row.count);
    _route = TextEditingController(text: row.route);
    _prescriptionInstructions = TextEditingController(
      text: row.prescriptionInstructionsSummary,
    );
    _notes = TextEditingController(text: row.additionalNotes);
  }

  @override
  void dispose() {
    _name.dispose();
    _strength.dispose();
    _count.dispose();
    _route.dispose();
    _prescriptionInstructions.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _syncRowFromControllers() {
    row.name = _name.text;
    row.strength = _strength.text;
    row.count = _count.text;
    row.route = _route.text;
    row.additionalNotes = _notes.text;
    widget.onChanged();
  }

  bool _scheduleIsValid() {
    if (row.reminderSchedule.mode == ReminderScheduleMode.mealBased) {
      try {
        MealScheduleResolver.resolve(
          schedule: row.reminderSchedule.meal,
          profile: widget.mealProfile,
          onLocalDate: row.reminderSchedule.course.startDate,
        );
        return true;
      } on MissingMealTimeException {
        return false;
      }
    }
    return row.reminderSchedule.course.durationDays >= 1;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final readOnly = row.confirmed;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'Medicine ${widget.index + 1}',
                  style: theme.textTheme.titleSmall,
                ),
                const Spacer(),
                if (row.confirmed)
                  Chip(
                    label: const Text('Confirmed'),
                    backgroundColor: theme.colorScheme.primaryContainer,
                    visualDensity: VisualDensity.compact,
                  ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  tooltip: row.confirmed
                      ? 'Remove confirmed medicine'
                      : 'Reject this medicine',
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  onPressed: () {
                    _syncRowFromControllers();
                    widget.onReject();
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Medication details', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            _textField(_name, 'Medicine name', readOnly),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _textField(
                    _strength,
                    'Strength',
                    readOnly,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: EditableMedicineRow.strengthUnits
                            .contains(row.strengthUnit)
                        ? row.strengthUnit
                        : EditableMedicineRow.strengthUnits.first,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                      labelText: 'Unit',
                    ),
                    items: EditableMedicineRow.strengthUnits
                        .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                        .toList(),
                    onChanged: readOnly
                        ? null
                        : (value) {
                            if (value == null) return;
                            row.strengthUnit = value;
                            widget.onChanged();
                            setState(() {});
                          },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _textField(_count, 'Dose amount / instructions', readOnly),
            const SizedBox(height: 8),
            _textField(_route, 'Route (e.g. oral)', readOnly),
            const SizedBox(height: 16),
            MedicineReviewScheduleSection(
              row: row,
              readOnly: readOnly,
              mealProfile: widget.mealProfile,
              userId: widget.userId,
              onChanged: () {
                _syncRowFromControllers();
                widget.onChanged();
                setState(() {});
              },
            ),
            const SizedBox(height: 16),
            Text('Additional details', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            _textField(
              _prescriptionInstructions,
              'Original prescription instructions (frequency / timing)',
              readOnly,
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            _textField(_notes, 'Additional notes', readOnly, maxLines: 2),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: readOnly || !_scheduleIsValid()
                    ? null
                    : () {
                        _syncRowFromControllers();
                        widget.onConfirm();
                      },
                child: const Text('Confirm row'),
              ),
            ),
            if (!readOnly &&
                row.reminderSchedule.mode == ReminderScheduleMode.mealBased &&
                !_scheduleIsValid())
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Configure the required meal time in your profile before confirming.',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _textField(
    TextEditingController controller,
    String hint,
    bool readOnly, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        border: const OutlineInputBorder(),
      ),
      onChanged: readOnly ? null : (_) => _syncRowFromControllers(),
    );
  }
}
