import 'package:image_picker/image_picker.dart';
import 'package:medicine_remainder_app/features/medicines/domain/medication_draft.dart';
import 'package:medicine_remainder_app/features/prescription/data/prescription_image_store.dart';
import 'package:medicine_remainder_app/services/ocr/ocr_result.dart';

/// Use cases: import image, run OCR, request structured extraction.
class PrescriptionImport {
  PrescriptionImport({
    required this.imageStore,
    ImagePicker? picker,
  }) : _picker = picker ?? ImagePicker();

  final PrescriptionImageStore imageStore;
  final ImagePicker _picker;

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
