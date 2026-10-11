import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicine_remainder_app/app/di/providers.dart';
import 'package:medicine_remainder_app/services/inference/gemma3n_litert_service.dart';
import 'package:medicine_remainder_app/services/inference/inference_result.dart';
import 'package:medicine_remainder_app/shared/config/huggingface_token.dart';
import 'package:medicine_remainder_app/shared/platform/device_abi.dart';

/// Development-only Gemma 3n LiteRT-LM feasibility UI (not a medication workflow).
class ModelSpikeScreen extends ConsumerStatefulWidget {
  const ModelSpikeScreen({super.key});

  @override
  ConsumerState<ModelSpikeScreen> createState() => _ModelSpikeScreenState();
}

class _ModelSpikeScreenState extends ConsumerState<ModelSpikeScreen> {
  String? _imagePath;
  String _output = '';
  int _downloadPercent = 0;
  InferenceResult? _lastResult;
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return const Scaffold(
        body: Center(child: Text('Spike screen is debug-only.')),
      );
    }

    final service = ref.watch(gemma3nLitertServiceProvider);
    final manifest = service.manifest;

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final state = service.state;
        final litertOk = deviceSupportsLitertLm;
        final abi = deviceAbiDescription();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Gemma 3n spike'),
          ),
          body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'HF repo: ${manifest?.hfRepo ?? "google/gemma-3n-E2B-it-litert-lm"}\n'
            'Artifact: ${manifest?.artifactFileName ?? "gemma-3n-E2B-it-int4.litertlm"} · arm64 · ~3.7 GB\n'
            'HF token: ${resolveHuggingFaceToken() != null ? "configured" : "missing — set HUGGINGFACE_TOKEN and full restart"}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          if (!litertOk)
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'This ABI cannot run Gemma (.litertlm).\n'
                  'Detected: ${abi ?? "non-Android"}.\n'
                  'Use a physical arm64 phone or an emulator image labeled '
                  '"ARM 64" (not x86_64).',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ),
          Text('State: $state'),
          if (service.lastError != null)
            Text(
              service.lastError!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          if (state == Gemma3nServiceState.loading)
            LinearProgressIndicator(
              value: _downloadPercent > 0 ? _downloadPercent / 100 : null,
            ),
          if (state == Gemma3nServiceState.loading && _downloadPercent >= 100)
            const Text(
              'Loading model into memory (1–3+ min first time)…',
              style: TextStyle(fontSize: 12),
            ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton(
                onPressed: !litertOk ||
                        state == Gemma3nServiceState.loading ||
                        state == Gemma3nServiceState.running
                    ? null
                    : () => _loadModel(service),
                child: const Text('Download / load model'),
              ),
              OutlinedButton(
                onPressed: state == Gemma3nServiceState.loading
                    ? service.cancelDownload
                    : null,
                child: const Text('Cancel download'),
              ),
              OutlinedButton(
                onPressed: _pickImage,
                child: const Text('Pick test image'),
              ),
              FilledButton.tonal(
                onPressed: _imagePath == null ||
                        state == Gemma3nServiceState.running ||
                        state != Gemma3nServiceState.ready
                    ? null
                    : () => _runInference(service),
                child: const Text('Run image + text'),
              ),
              OutlinedButton(
                onPressed: state == Gemma3nServiceState.running
                    ? () => service.cancelInference()
                    : null,
                child: const Text('Cancel inference'),
              ),
            ],
          ),
          if (_imagePath != null) ...[
            const SizedBox(height: 16),
            Text('Image: $_imagePath', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(_imagePath!),
                height: 160,
                fit: BoxFit.contain,
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (_lastResult != null) _MetricsCard(result: _lastResult!),
          const SizedBox(height: 8),
          SelectableText(_output.isEmpty ? '(no output yet)' : _output),
            ],
          ),
        );
      },
    );
  }

  Future<void> _loadModel(Gemma3nLitertService service) async {
    setState(() => _downloadPercent = 0);
    await service.loadModel(
      onProgress: (p) => setState(() => _downloadPercent = p),
    );
  }

  Future<void> _pickImage() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _imagePath = file.path);
    }
  }

  Future<void> _runInference(Gemma3nLitertService service) async {
    final path = _imagePath;
    if (path == null) return;
    setState(() {
      _output = '';
      _lastResult = null;
    });
    final result = await service.analyzeImage(
      imagePath: path,
      onPartial: (t) => setState(() => _output += t),
    );
    setState(() {
      _lastResult = result;
      if (result.text != null && _output.isEmpty) {
        _output = result.text!;
      }
    });
  }
}

class _MetricsCard extends StatelessWidget {
  const _MetricsCard({required this.result});
  final InferenceResult result;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Success: ${result.isSuccess}'),
            if (result.inferenceDuration != null)
              Text('Inference: ${result.inferenceDuration!.inMilliseconds} ms'),
            if (result.tokensApprox != null)
              Text('~${result.tokensApprox} words'),
            if (result.errorKind != null) Text('Error: ${result.errorKind}'),
            if (result.errorMessage != null)
              Text(
                result.errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
          ],
        ),
      ),
    );
  }
}
