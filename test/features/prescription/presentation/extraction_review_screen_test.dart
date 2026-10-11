import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/features/prescription/data/prescription_image_store.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_import.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/extraction_review_screen.dart';
import 'package:medicine_remainder_app/shared/models/field_confidence.dart';
import 'package:medicine_remainder_app/shared/models/medication_extraction_draft.dart';
import 'package:medicine_remainder_app/shared/models/medication_field.dart';

void main() {
  testWidgets('shows uncertain warning and confirms medicine', (tester) async {
    final import = PrescriptionImport(
      imageStore: const PrescriptionImageStore(encryptAtRest: false),
    );
    final draft = MedicationExtractionDraft(
      schemaVersion: 1,
      prescriptionId: 'rx',
      userId: 'user',
      medicines: [
        MedicineDraft(
          name: const MedicationField<String>(
            value: 'Aspirin',
            confidence: FieldConfidence.uncertain,
            provenance: Provenance.rules,
          ),
          strength: const MedicationField<String>(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
          strengthUnit: const MedicationField<String>(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
          doseInstructions: const MedicationField<String>(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
          route: const MedicationField<String>(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
          frequency: const MedicationField<String>(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
          duration: const MedicationField<String>(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
          timing: const MedicationField<String>(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
          startAt: const MedicationField<String>(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
          endAt: const MedicationField<String>(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
          originalSourceText: const MedicationField<String>(
            value: 'Aspirin',
            confidence: FieldConfidence.uncertain,
            provenance: Provenance.rules,
          ),
        ),
      ],
      extractionMethod: ExtractionMethod.ocrRules,
      createdAt: DateTime.now().toUtc(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ExtractionReviewScreen(
          draft: draft,
          userId: 'user-1',
          prescriptionImport: import,
        ),
      ),
    );

    expect(find.textContaining('Uncertain'), findsWidgets);
    await tester.scrollUntilVisible(
      find.text('Confirm medicines'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Confirm medicines'));
    await tester.pumpAndSettle();
    expect(import.sessionConfirmed, hasLength(1));
  });
}
