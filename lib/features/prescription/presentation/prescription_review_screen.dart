import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicine_remainder_app/features/prescription/application/prescription_flow_state.dart';
import 'package:medicine_remainder_app/app/di/reminder_providers.dart';
import 'package:medicine_remainder_app/app/router.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_review_bundle.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/editable_medicine_row.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/editable_prescription_ehr.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/medicine_review_row_card.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/prescription_metadata_section.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/prescription_stored_image.dart';
import 'package:medicine_remainder_app/features/users/application/user_meal_profile_actions.dart';
import 'package:uuid/uuid.dart';

/// Step 2 — single merged extraction review (no separate OCR / VLM panes).
class PrescriptionReviewScreen extends ConsumerStatefulWidget {
  const PrescriptionReviewScreen({
    super.key,
    required this.imagePath,
    required this.bundle,
    required this.userId,
    this.imagePreview,
  });

  final String imagePath;
  final PrescriptionReviewBundle bundle;
  final String userId;
  final Widget? imagePreview;

  @override
  ConsumerState<PrescriptionReviewScreen> createState() =>
      _PrescriptionReviewScreenState();
}

class _PrescriptionReviewScreenState
    extends ConsumerState<PrescriptionReviewScreen> {
  final _uuid = const Uuid();
  late final EditablePrescriptionEhr _ehr;
  late List<EditableMedicineRow> _rows;
  bool _submitting = false;

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

  void _rejectRow(int index) {
    final row = _rows[index];
    final label =
        row.name.trim().isEmpty ? 'Medicine ${index + 1}' : row.name.trim();
    setState(() => _rows.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label removed from this prescription.')),
    );
  }

  void _addMedicine() {
    setState(() => _rows.add(EditableMedicineRow(id: _uuid.v4())));
  }

  Future<void> _submitPrescription() async {
    final confirmedCount = _rows.where((r) => r.confirmed).length;
    if (confirmedCount == 0 || _submitting) {
      return;
    }
    setState(() => _submitting = true);
    try {
      final result = await ref.read(prescriptionReviewSubmitterProvider).submit(
            userId: widget.userId,
            imagePath: widget.imagePath,
            bundle: widget.bundle,
            rows: _rows,
          );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Saved ${result.medicinesSaved} medicine(s); '
            '${result.remindersScheduled} reminder(s) scheduled.',
          ),
        ),
      );
      ref.read(prescriptionFlowProvider.notifier).clear();
      context.go(AppRoutes.userHome(widget.userId));
    } on StateError catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not submit: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final confirmedCount = _rows.where((r) => r.confirmed).length;
    final mealProfile = ref.watch(userMealProfileProvider(widget.userId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review prescription'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Step 2 of 2 — One combined result from on-device extraction. '
            'Edit any field, confirm rows you want to keep, or remove mistakes with ✕.',
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
                  PrescriptionStoredImage(
                    path: widget.imagePath,
                    fit: BoxFit.contain,
                  ),
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
          if (_rows.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'No medicines yet. Add one manually or go back to capture.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ...List.generate(_rows.length, (index) {
            final row = _rows[index];
            return MedicineReviewRowCard(
              key: ValueKey(row.id),
              index: index,
              row: row,
              userId: widget.userId,
              mealProfile: mealProfile,
              onChanged: () => setState(() {}),
              onConfirm: () => _confirmRow(index),
              onReject: () => _rejectRow(index),
            );
          }),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _addMedicine,
            icon: const Icon(Icons.add_outlined),
            label: const Text('Add medicine'),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: FilledButton.icon(
          onPressed: confirmedCount == 0 || _submitting
              ? null
              : _submitPrescription,
          icon: _submitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.alarm_outlined),
          label: Text(
            confirmedCount == 0
                ? 'Confirm medicines to submit'
                : 'Submit & set reminders ($confirmedCount)',
          ),
        ),
      ),
    );
  }
}

class PrescriptionReviewRouteArgs {
  const PrescriptionReviewRouteArgs({
    required this.imagePath,
    required this.bundle,
    required this.userId,
  });

  final String imagePath;
  final PrescriptionReviewBundle bundle;
  final String userId;
}
