import 'package:image_picker/image_picker.dart';
import 'package:medicine_remainder_app/features/medicines/data/medicine_repository.dart';
import 'package:medicine_remainder_app/features/medicines/domain/medication_record.dart';
import 'package:medicine_remainder_app/features/prescription/data/prescription_image_store.dart';
import 'package:medicine_remainder_app/features/prescription/data/prescription_repository.dart';
import 'package:medicine_remainder_app/services/ocr/ocr_result.dart';
import 'package:medicine_remainder_app/shared/models/field_confidence.dart';
import 'package:medicine_remainder_app/shared/models/medication_extraction_draft.dart';
import 'package:medicine_remainder_app/shared/validation/extraction_validator.dart';
import 'package:uuid/uuid.dart';

/// Use cases: import image, run OCR, request structured extraction, confirm (P4-04).
class PrescriptionImport {
  PrescriptionImport({
    required this.imageStore,
    ImagePicker? picker,
    MedicineRepository? medicineRepository,
    PrescriptionRepository? prescriptionRepository,
    ExtractionValidator? validator,
    Uuid? uuid,
  })  : _picker = picker ?? ImagePicker(),
        _medicineRepository = medicineRepository,
        _prescriptionRepository = prescriptionRepository,
        _validator = validator ?? const ExtractionValidator(),
        _uuid = uuid ?? const Uuid();

  final PrescriptionImageStore imageStore;
  final ImagePicker _picker;
  final MedicineRepository? _medicineRepository;
  final PrescriptionRepository? _prescriptionRepository;
  final ExtractionValidator _validator;
  final Uuid _uuid;

  final List<MedicationRecord> _sessionConfirmed = [];

  List<MedicationRecord> get sessionConfirmed =>
      List<MedicationRecord>.unmodifiable(_sessionConfirmed);

  /// Returns the app-private path, or `null` if the user cancelled the picker.
  Future<String?> importFromGallery() => _importImage(ImageSource.gallery);

  /// Returns the app-private path, or `null` if the user cancelled the picker.
  Future<String?> importFromCamera() => _importImage(ImageSource.camera);

  Future<String?> _importImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 100,
    );
    if (picked == null) {
      return null;
    }
    final bytes = await picked.readAsBytes();
    final mimeType = _mimeTypeFromPath(picked.path) ?? 'image/jpeg';
    return imageStore.saveTemporary(bytes, mimeType: mimeType);
  }

  Future<OcrResult> runOcr(String imagePath) {
    throw UnimplementedError('P1-03');
  }

  Future<MedicationExtractionDraft> requestExtraction({
    required String imagePath,
    required OcrResult ocr,
  }) {
    throw UnimplementedError('P1-06');
  }

  /// Confirms a reviewed draft into immutable [MedicationRecord]s.
  ///
  /// Without an explicit confirm call, nothing is written to [MedicineRepository].
  Future<List<MedicationRecord>> confirmExtraction({
    required MedicationExtractionDraft draft,
    required String userId,
    String? imagePath,
    String source = 'gallery',
  }) async {
    final reviewed = draft.copyWith(userId: userId);
    final validation = _validator.validateDraft(reviewed);
    if (!validation.canConfirm) {
      throw ConfirmExtractionException(validation.errors);
    }

    final confirmedAt = DateTime.now().toUtc();
    final records = reviewed.medicines
        .map(
          (medicine) => MedicationRecord.fromConfirmedDraft(
            medicineId: _uuid.v4(),
            userId: userId,
            medicine: medicine,
            prescriptionId: reviewed.prescriptionId,
            confirmedAt: confirmedAt,
          ),
        )
        .toList();

    if (_prescriptionRepository != null) {
      await _prescriptionRepository.save(
        PrescriptionRecord(
          id: reviewed.prescriptionId,
          userId: userId,
          capturedAt: reviewed.createdAt,
          source: source,
          imagePath: imagePath,
          reviewStatus: ReviewStatus.confirmed,
          humanReviewedAt: confirmedAt,
          createdAt: reviewed.createdAt,
          updatedAt: confirmedAt,
        ),
      );
    }

    for (final record in records) {
      if (_medicineRepository != null) {
        await _medicineRepository.save(record);
      } else {
        _sessionConfirmed.add(record);
      }
    }

    return records;
  }

  static String? _mimeTypeFromPath(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) {
      return 'image/png';
    }
    if (lower.endsWith('.webp')) {
      return 'image/webp';
    }
    if (lower.endsWith('.heic') || lower.endsWith('.heif')) {
      return 'image/heic';
    }
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) {
      return 'image/jpeg';
    }
    return null;
  }
}

class ConfirmExtractionException implements Exception {
  ConfirmExtractionException(this.errors);

  final List<String> errors;

  @override
  String toString() => 'ConfirmExtractionException: ${errors.join('; ')}';
}
