import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/features/medicines/domain/medication_draft.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_ehr_draft.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_review_bundle.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/prescription_review_screen.dart';
import 'package:medicine_remainder_app/services/ocr/prescription_image_verifier.dart';
import 'package:medicine_remainder_app/shared/models/field_confidence.dart';
import 'package:medicine_remainder_app/shared/models/prescription_likelihood.dart';

PrescriptionReviewBundle _sampleBundle() {
  return PrescriptionReviewBundle(
    verification: const PrescriptionVerificationResult(
      likelihood: PrescriptionLikelihood.likely,
      summary: 'ok',
      signals: [],
    ),
    extractionMethodLabel: 'On-device OCR + rules',
    ehr: PrescriptionEhrDraft(
      doctorName: const MedicationField(
        value: 'Dr. Smith',
        confidence: FieldConfidence.uncertain,
        provenance: Provenance.rules,
      ),
      facilityName: const MedicationField(
        confidence: FieldConfidence.missing,
        provenance: Provenance.rules,
      ),
      diagnosis: const MedicationField(
        confidence: FieldConfidence.missing,
        provenance: Provenance.rules,
      ),
      testsSuggested: const MedicationField(
        confidence: FieldConfidence.missing,
        provenance: Provenance.rules,
      ),
      notes: const MedicationField(
        confidence: FieldConfidence.missing,
        provenance: Provenance.rules,
      ),
    ),
    draft: MedicationExtractionDraft(
      schemaVersion: 1,
      prescriptionId: 'id',
      medicines: [
        MedicineDraft(
          name: const MedicationField(
            value: 'Amoxicillin',
            confidence: FieldConfidence.uncertain,
            provenance: Provenance.rules,
          ),
          strength: const MedicationField(
            value: '500',
            confidence: FieldConfidence.uncertain,
            provenance: Provenance.rules,
          ),
          strengthUnit: const MedicationField(
            value: 'mg',
            confidence: FieldConfidence.uncertain,
            provenance: Provenance.rules,
          ),
          doseInstructions: const MedicationField(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
          route: const MedicationField(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
          frequency: const MedicationField(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
          duration: const MedicationField(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
          timing: const MedicationField(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
          originalSourceText: const MedicationField(
            confidence: FieldConfidence.missing,
            provenance: Provenance.rules,
          ),
        ),
      ],
      rawOcrText: 'hidden',
      extractionMethod: ExtractionMethod.ocrRules,
      createdAt: DateTime.utc(2026),
    ),
  );
}

void main() {
  testWidgets('PrescriptionReviewScreen shows metadata and medicines only', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: PrescriptionReviewScreen(
          imagePath: '/tmp/rx.jpg',
          bundle: _sampleBundle(),
          imagePreview: const SizedBox.shrink(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Review prescription'), findsOneWidget);
    expect(find.text('Prescription details'), findsOneWidget);
    expect(find.text('Dr. Smith'), findsOneWidget);
    expect(find.text('Medicine 1'), findsOneWidget);
    expect(find.text('Confirm row'), findsOneWidget);
    expect(find.text('hidden'), findsNothing);
    expect(find.text('On-device OCR + rules'), findsOneWidget);
  });
}
