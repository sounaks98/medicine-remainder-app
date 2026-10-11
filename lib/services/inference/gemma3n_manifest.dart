import 'dart:convert';

import 'package:flutter/services.dart';

/// Pinned Gemma 3n E2B LiteRT-LM artifact metadata (`assets/models/gemma3n_manifest.json`).
class Gemma3nManifest {
  Gemma3nManifest({
    required this.artifactFileName,
    required this.url,
    required this.sizeBytes,
    required this.hfRepo,
  });

  final String artifactFileName;
  final String url;
  final int sizeBytes;
  final String hfRepo;

  static const assetPath = 'assets/models/gemma3n_manifest.json';

  static Future<Gemma3nManifest> load() async {
    final raw = await rootBundle.loadString(assetPath);
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return Gemma3nManifest(
      artifactFileName: map['artifactFileName'] as String,
      url: map['url'] as String,
      sizeBytes: (map['sizeBytes'] as num).toInt(),
      hfRepo: map['modelId'] as String,
    );
  }
}
