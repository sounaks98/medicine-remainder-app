import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_remainder_app/app/di/providers.dart';

final prescriptionImageBytesProvider = FutureProvider.autoDispose
    .family<List<int>, String>((ref, path) {
  return ref.watch(prescriptionImageStoreProvider).readBytes(path);
});

/// Displays a prescription image from [path], decrypting `.mrx` files when needed.
class PrescriptionStoredImage extends ConsumerWidget {
  const PrescriptionStoredImage({
    super.key,
    required this.path,
    this.fit = BoxFit.contain,
    this.height,
    this.width,
  });

  final String path;
  final BoxFit fit;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bytesAsync = ref.watch(prescriptionImageBytesProvider(path));

    return bytesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
      data: (bytes) => Image.memory(
        Uint8List.fromList(bytes),
        fit: fit,
        height: height,
        width: width,
        gaplessPlayback: true,
      ),
    );
  }
}
