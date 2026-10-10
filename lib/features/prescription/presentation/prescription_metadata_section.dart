import 'package:flutter/material.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/editable_prescription_ehr.dart';

class PrescriptionMetadataSection extends StatefulWidget {
  const PrescriptionMetadataSection({
    super.key,
    required this.ehr,
    required this.onChanged,
  });

  final EditablePrescriptionEhr ehr;
  final VoidCallback onChanged;

  @override
  State<PrescriptionMetadataSection> createState() =>
      _PrescriptionMetadataSectionState();
}

class _PrescriptionMetadataSectionState extends State<PrescriptionMetadataSection> {
  late final TextEditingController _doctor;
  late final TextEditingController _facility;
  late final TextEditingController _diagnosis;
  late final TextEditingController _tests;
  late final TextEditingController _notes;

  @override
  void initState() {
    super.initState();
    _doctor = TextEditingController(text: widget.ehr.doctorName);
    _facility = TextEditingController(text: widget.ehr.facilityName);
    _diagnosis = TextEditingController(text: widget.ehr.diagnosis);
    _tests = TextEditingController(text: widget.ehr.testsSuggested);
    _notes = TextEditingController(text: widget.ehr.notes);
  }

  @override
  void dispose() {
    _doctor.dispose();
    _facility.dispose();
    _diagnosis.dispose();
    _tests.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _sync() {
    widget.ehr.doctorName = _doctor.text;
    widget.ehr.facilityName = _facility.text;
    widget.ehr.diagnosis = _diagnosis.text;
    widget.ehr.testsSuggested = _tests.text;
    widget.ehr.notes = _notes.text;
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Prescription details', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            _row('Doctor', _doctor, 'Dr. name'),
            _row('Facility', _facility, 'Hospital or clinic'),
            _row('Diagnosis', _diagnosis, 'Condition or ICD note'),
            _row('Tests suggested', _tests, 'Labs or imaging'),
            _row('Notes', _notes, 'Additional advice', maxLines: 2),
          ],
        ),
      ),
    );
  }

  Widget _row(
    String label,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(label),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              decoration: InputDecoration(
                hintText: hint,
                isDense: true,
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => _sync(),
            ),
          ),
        ],
      ),
    );
  }
}
