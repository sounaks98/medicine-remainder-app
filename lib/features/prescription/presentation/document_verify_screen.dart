import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicine_remainder_app/app/di/providers.dart';
import 'package:medicine_remainder_app/app/router.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/prescription_review_screen.dart';
import 'package:medicine_remainder_app/services/ocr/ocr_result.dart';
import 'package:medicine_remainder_app/services/ocr/prescription_image_verifier.dart';
import 'package:medicine_remainder_app/shared/models/prescription_likelihood.dart';

/// First step after capture: is this image a prescription? (rules now, VLM later).
class DocumentVerifyScreen extends ConsumerStatefulWidget {
  const DocumentVerifyScreen({
    super.key,
    required this.imagePath,
    this.imagePreview,
  });

  final String imagePath;
  final Widget? imagePreview;

  @override
  ConsumerState<DocumentVerifyScreen> createState() =>
      _DocumentVerifyScreenState();
}

class _DocumentVerifyScreenState extends ConsumerState<DocumentVerifyScreen> {
  OcrResult? _ocr;
  PrescriptionVerificationResult? _verification;
  String? _error;
  bool _checking = true;
  bool _extracting = false;

  @override
  void initState() {
    super.initState();
    _runVerification();
  }

  Future<void> _runVerification() async {
    setState(() {
      _checking = true;
      _error = null;
    });
    try {
      final check = await ref
          .read(prescriptionExtractionPipelineProvider)
          .checkDocument(imagePath: widget.imagePath);
      if (!mounted) {
        return;
      }
      setState(() {
        _ocr = check.ocr;
        _verification = check.verification;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _error = error.toString());
    } finally {
      if (mounted) {
        setState(() => _checking = false);
      }
    }
  }

  Future<void> _continueToExtraction() async {
    if (_ocr == null) {
      return;
    }
    setState(() => _extracting = true);
    try {
      final bundle = await ref
          .read(prescriptionExtractionPipelineProvider)
          .extractUnified(
            imagePath: widget.imagePath,
            cachedOcr: _ocr!,
          );
      if (!mounted) {
        return;
      }
      await context.push(
        AppRoutes.prescriptionReview,
        extra: PrescriptionReviewRouteArgs(
          imagePath: widget.imagePath,
          bundle: bundle,
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Extraction failed: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _extracting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final verification = _verification;

    return Scaffold(
      appBar: AppBar(title: const Text('Check document')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Step 1 of 2 — We check whether this looks like a prescription '
            'before extracting medicines. SmolVLM can assist here when installed.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: widget.imagePreview ??
                  Image.file(
                    File(widget.imagePath),
                    fit: BoxFit.contain,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          if (_checking)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            Text(_error!, style: TextStyle(color: theme.colorScheme.error))
          else if (verification != null) ...[
            _LikelihoodBanner(result: verification),
            const SizedBox(height: 12),
            Text(verification.summary, style: theme.textTheme.bodyLarge),
            if (verification.signals.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Signals', style: theme.textTheme.titleSmall),
              const SizedBox(height: 4),
              ...verification.signals.map(
                (signal) => ListTile(
                  dense: true,
                  leading: const Icon(Icons.check_circle_outline, size: 20),
                  title: Text(signal),
                ),
              ),
            ],
            const SizedBox(height: 24),
            if (verification.likelihood == PrescriptionLikelihood.unlikely)
              FilledButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.photo_camera_outlined),
                label: const Text('Choose another image'),
              )
            else
              FilledButton.icon(
                onPressed: _extracting ? null : _continueToExtraction,
                icon: _extracting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.arrow_forward),
                label: Text(
                  _extracting
                      ? 'Extracting prescription…'
                      : 'Continue to review',
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _LikelihoodBanner extends StatelessWidget {
  const _LikelihoodBanner({required this.result});

  final PrescriptionVerificationResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (Color bg, String label) = switch (result.likelihood) {
      PrescriptionLikelihood.likely => (
          theme.colorScheme.primaryContainer,
          'Likely prescription',
        ),
      PrescriptionLikelihood.uncertain => (
          theme.colorScheme.tertiaryContainer,
          'Uncertain — verify',
        ),
      PrescriptionLikelihood.unlikely => (
          theme.colorScheme.errorContainer,
          'Unlikely prescription',
        ),
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            result.vlmAssisted ? Icons.psychology_outlined : Icons.rule_outlined,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              result.vlmAssisted ? '$label (VLM)' : label,
              style: theme.textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}

class DocumentVerifyRouteArgs {
  const DocumentVerifyRouteArgs({required this.imagePath});

  final String imagePath;
}
