import 'package:medicine_remainder_app/features/prescription/domain/prescription_ehr_draft.dart';

class EditablePrescriptionEhr {
  EditablePrescriptionEhr({
    this.doctorName = '',
    this.facilityName = '',
    this.diagnosis = '',
    this.testsSuggested = '',
    this.notes = '',
  });

  factory EditablePrescriptionEhr.fromDraft(PrescriptionEhrDraft draft) {
    return EditablePrescriptionEhr(
      doctorName: draft.doctorName.value ?? '',
      facilityName: draft.facilityName.value ?? '',
      diagnosis: draft.diagnosis.value ?? '',
      testsSuggested: draft.testsSuggested.value ?? '',
      notes: draft.notes.value ?? '',
    );
  }

  String doctorName;
  String facilityName;
  String diagnosis;
  String testsSuggested;
  String notes;
}
