import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_review_bundle.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/editable_medicine_row.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/editable_prescription_ehr.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/medicine_review_row_card.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/prescription_metadata_section.dart';
import 'package:uuid/uuid.dart';

/// Step 2 — single merged extraction review (no separate OCR / VLM panes).
class PrescriptionReviewScreen extends StatefulWidget {
  const PrescriptionReviewScreen({
    super.key,
    required this.imagePath,
    required this.bundle,
    this.imagePreview,
  });

  final String imagePath;
  final PrescriptionReviewBundle bundle;
  final Widget? imagePreview;

  @override
  State<PrescriptionReviewScreen> createState() =>
      _PrescriptionReviewScreenState();
}

class _PrescriptionReviewScreenState extends State<PrescriptionReviewScreen> {
  final _uuid = const Uuid();
  late final EditablePrescriptionEhr _ehr;
  late List<EditableMedicineRow> _rows;

  @override
  void initState() {
    super.initState();
    _ehr = EditablePrescriptionEhr.fromDraft(widget.bundle.ehr);
    _rows = widget.bundle.draft.medicines
        .map((m) => EditableMedicineRow.fromDraft(m, id: _uuid.v4()))
        .toList();
    if (_rows.isEmpty) {
      _rows = [EditableMedicineRow(id: _uuid.v4())];
    }
  }

  void _confirmRow(int index) {
    final row = _rows[index];
    if (row.name.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a medicine name before confirming.')),
      );
      return;
    }
    setState(() => row.confirmed = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${row.name.trim()} confirmed for this session.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Review prescription')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Step 2 of 2 — One combined result from on-device extraction. '
            'Edit any field, then confirm each medicine row.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              label: Text(widget.bundle.extractionMethodLabel),
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: widget.imagePreview ??
                  Image.file(File(widget.imagePath), fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 16),
          PrescriptionMetadataSection(ehr: _ehr, onChanged: () {}),
          const SizedBox(height: 16),
          Text(
            'Medicines (${_rows.length})',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          ...List.generate(_rows.length, (index) {
            final row = _rows[index];
            return MedicineReviewRowCard(
              key: ValueKey(row.id),
              index: index,
              row: row,
              onChanged: () {},
              onConfirm: () => _confirmRow(index),
            );
          }),
        ],
      ),
    );
  }
}

class PrescriptionReviewRouteArgs {
  const PrescriptionReviewRouteArgs({
    required this.imagePath,
    required this.bundle,
  });

  final String imagePath;
  final PrescriptionReviewBundle bundle;
}
