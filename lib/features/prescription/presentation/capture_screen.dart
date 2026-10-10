import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_remainder_app/app/di/providers.dart';

class CaptureScreen extends ConsumerStatefulWidget {
  const CaptureScreen({super.key});

  @override
  ConsumerState<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends ConsumerState<CaptureScreen> {
  bool _busy = false;
  String? _savedImagePath;

  Future<void> _importFromGallery() => _import(
        ref.read(prescriptionImportProvider).importFromGallery,
      );

  Future<void> _importFromCamera() => _import(
        ref.read(prescriptionImportProvider).importFromCamera,
      );

  Future<void> _import(Future<String?> Function() import) async {
    if (_busy) {
      return;
    }
    setState(() => _busy = true);
    try {
      final path = await import();
      if (!mounted) {
        return;
      }
      if (path == null) {
        return;
      }
      setState(() => _savedImagePath = path);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prescription image saved on device.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save image: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capture prescription')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Take a photo or choose an image from your gallery. '
              'Images are stored only in this app\'s private storage.',
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _busy ? null : _importFromCamera,
              icon: const Icon(Icons.photo_camera_outlined),
              label: const Text('Take photo'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _busy ? null : _importFromGallery,
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Choose from gallery'),
            ),
            if (_busy) ...[
              const SizedBox(height: 24),
              const Center(child: CircularProgressIndicator()),
            ],
            if (_savedImagePath != null) ...[
              const SizedBox(height: 24),
              Text(
                'Saved to app storage:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              SelectableText(
                _savedImagePath!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
