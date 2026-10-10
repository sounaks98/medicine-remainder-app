import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_remainder_app/features/prescription/data/prescription_image_store.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_import.dart';
import 'package:medicine_remainder_app/services/inference/image_preprocessor.dart';

final prescriptionImageStoreProvider = Provider<PrescriptionImageStore>(
  (ref) => const PrescriptionImageStore(),
);

final prescriptionImportProvider = Provider<PrescriptionImport>(
  (ref) => PrescriptionImport(
    imageStore: ref.watch(prescriptionImageStoreProvider),
  ),
);

final imagePreprocessorProvider = Provider<ImagePreprocessor>(
  (ref) => const ImagePreprocessor(),
);
