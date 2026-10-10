import 'package:flutter/material.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/editable_medicine_row.dart';

class MedicineReviewRowCard extends StatefulWidget {
  const MedicineReviewRowCard({
    super.key,
    required this.index,
    required this.row,
    required this.onChanged,
    required this.onConfirm,
  });

  final int index;
  final EditableMedicineRow row;
  final VoidCallback onChanged;
  final VoidCallback onConfirm;

  @override
  State<MedicineReviewRowCard> createState() => _MedicineReviewRowCardState();
}

class _MedicineReviewRowCardState extends State<MedicineReviewRowCard> {
  late final TextEditingController _name;
  late final TextEditingController _strength;
  late final TextEditingController _count;
  late final TextEditingController _frequency;
  late final TextEditingController _duration;
  late final TextEditingController _route;
  late final TextEditingController _timing;
  late final TextEditingController _instructions;

  EditableMedicineRow get row => widget.row;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: row.name);
    _strength = TextEditingController(text: row.strength);
    _count = TextEditingController(text: row.count);
    _frequency = TextEditingController(text: row.frequency);
    _duration = TextEditingController(text: row.duration);
    _route = TextEditingController(text: row.route);
    _timing = TextEditingController(text: row.timing);
    _instructions = TextEditingController(text: row.doseInstructions);
  }

  @override
  void dispose() {
    _name.dispose();
    _strength.dispose();
    _count.dispose();
    _frequency.dispose();
    _duration.dispose();
    _route.dispose();
    _timing.dispose();
    _instructions.dispose();
    super.dispose();
  }

  void _syncRowFromControllers() {
    row.name = _name.text;
    row.strength = _strength.text;
    row.count = _count.text;
    row.frequency = _frequency.text;
    row.duration = _duration.text;
    row.route = _route.text;
    row.timing = _timing.text;
    row.doseInstructions = _instructions.text;
    widget.onChanged();
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
              ],
            ),
            const SizedBox(height: 8),
            Table(
              columnWidths: const {
                0: FixedColumnWidth(110),
                1: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                _fieldRow(
                  label: 'Name',
                  child: _textField(_name, 'Medicine name', readOnly),
                ),
                _fieldRow(
                  label: 'Strength',
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _textField(
                          _strength,
                          '500',
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
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                          ),
                          items: EditableMedicineRow.strengthUnits
                              .map(
                                (unit) => DropdownMenuItem(
                                  value: unit,
                                  child: Text(unit),
                                ),
                              )
                              .toList(),
                          onChanged: readOnly
                              ? null
                              : (value) {
                                  if (value == null) {
                                    return;
                                  }
                                  row.strengthUnit = value;
                                  widget.onChanged();
                                  setState(() {});
                                },
                        ),
                      ),
                    ],
                  ),
                ),
                _fieldRow(
                  label: 'Count / dose',
                  child: _textField(_count, 'e.g. 1 tablet, 5 ml', readOnly),
                ),
                _fieldRow(
                  label: 'Frequency',
                  child: _textField(_frequency, 'Twice daily', readOnly),
                ),
                _fieldRow(
                  label: 'Duration',
                  child: _textField(_duration, '7 days', readOnly),
                ),
                _fieldRow(
                  label: 'Route',
                  child: _textField(_route, 'Oral', readOnly),
                ),
                _fieldRow(
                  label: 'Timing',
                  child: _textField(_timing, 'After meals', readOnly),
                ),
                _fieldRow(
                  label: 'Instructions',
                  child: _textField(
                    _instructions,
                    'Additional notes',
                    readOnly,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: readOnly
                    ? null
                    : () {
                        _syncRowFromControllers();
                        widget.onConfirm();
                      },
                child: const Text('Confirm row'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _fieldRow({required String label, required Widget child}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
          child: Text(label),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: child,
        ),
      ],
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      ),
      onChanged: readOnly ? null : (_) => _syncRowFromControllers(),
    );
  }
}
