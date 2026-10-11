import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import 'package:flutter_edge_ai/flutter_edge_ai.dart';

import 'package:image/image.dart' as img;



/// Longest edge for vision input (memory / encoder stability on 4–6 GB devices).

const int kGemma3nSpikeMaxImageLongestEdge = 1024;



/// Thin wrapper over `flutter_edge_ai` for tests and spike isolation.

abstract class Gemma3nLitertClient {

  Future<bool> isModelInstalled(String modelFileName);



  /// Installs from [hfRepo] (e.g. `google/gemma-3n-E2B-it-litert-lm`).

  Future<void> installFromHuggingFace({

    required String hfRepo,

    String? artifactFileName,

    String? huggingFaceToken,

    void Function(int percent)? onProgress,

    CancelToken? cancelToken,

  });



  /// Loads LiteRT-LM native runtime + weights once; reuse for later inference.

  Future<void> warmUpRuntime({

    required String hfRepo,

    String? huggingFaceToken,

  });



  Future<String> analyzeImage({

    required String hfRepo,

    required Uint8List imageBytes,

    required String instruction,

    String? huggingFaceToken,

    void Function(String token)? onToken,

  });



  Future<void> cancelInference();



  Future<void> releaseRuntime();

}



class FlutterEdgeGemma3nClient implements Gemma3nLitertClient {

  InferenceChat? _activeChat;

  InferenceModel? _loadedModel;

  ModelRuntimeDefaults? _runtimeDefaults;

  String? _cachedHfRepo;



  @override

  Future<bool> isModelInstalled(String modelFileName) {

    return FlutterEdgeAi.isModelInstalled(modelFileName);

  }



  @override

  Future<void> installFromHuggingFace({

    required String hfRepo,

    String? artifactFileName,

    String? huggingFaceToken,

    void Function(int percent)? onProgress,

    CancelToken? cancelToken,

  }) async {

    var builder = FlutterEdgeAi.installModel(

      modelType: ModelType.gemmaIt,

      fileType: ModelFileType.litertlm,

    );

    final file = artifactFileName?.trim();

    if (file != null && file.isNotEmpty) {

      builder = builder.fromHuggingFace(

        hfRepo,

        file: file,

        token: huggingFaceToken,

        foreground: true,

      );

    } else {

      builder = builder.fromHuggingFace(

        hfRepo,

        token: huggingFaceToken,

        foreground: true,

      );

    }

    builder = builder.withProgress(onProgress ?? (_) {});

    if (cancelToken != null) {

      builder = builder.withCancelToken(cancelToken);

    }

    await builder.install();

    await releaseRuntime();

  }



  @override

  Future<void> warmUpRuntime({

    required String hfRepo,

    String? huggingFaceToken,

  }) async {

    await _ensureModel(hfRepo: hfRepo, huggingFaceToken: huggingFaceToken);

  }



  @override

  Future<String> analyzeImage({

    required String hfRepo,

    required Uint8List imageBytes,

    required String instruction,

    String? huggingFaceToken,

    void Function(String token)? onToken,

  }) async {

    final model = await _ensureModel(

      hfRepo: hfRepo,

      huggingFaceToken: huggingFaceToken,

    );

    final prepared = _prepareImageForVision(imageBytes);



    await _activeChat?.close();

    _activeChat = null;



    final chat = await model.createChat(

      supportImage: true,

      modelType: ModelType.gemmaIt,

      maxOutputTokens: 1024,

      topK: 64,

      temperature: 1.0,

    );

    _activeChat = chat;

    try {

      await chat.addQueryChunk(

        Message.withImages(

          text: instruction,

          imageBytes: [prepared],

          isUser: true,

        ),

      );

      final buffer = StringBuffer();

      await for (final response in chat.generateChatResponseAsync()) {

        if (response is TextResponse) {

          buffer.write(response.token);

          onToken?.call(response.token);

        }

      }

      final text = buffer.toString();

      if (text.isEmpty) {

        throw StateError(

          'Model returned no text. Check Logcat for LiteRtLmFfi errors '

          '(OOM, GPU init, or vision encoder).',

        );

      }

      return text;

    } finally {

      await chat.close();

      _activeChat = null;

    }

  }



  @override

  Future<void> cancelInference() async {

    await _activeChat?.stopGeneration();

  }



  @override

  Future<void> releaseRuntime() async {

    await _activeChat?.close();

    _activeChat = null;

    await _loadedModel?.close();

    _loadedModel = null;

    _cachedHfRepo = null;

    _runtimeDefaults = null;

  }



  Future<InferenceModel> _ensureModel({

    required String hfRepo,

    String? huggingFaceToken,

  }) async {

    if (_loadedModel != null && _cachedHfRepo == hfRepo) {

      return _loadedModel!;

    }

    await releaseRuntime();

    _cachedHfRepo = hfRepo;



    _runtimeDefaults = await _resolveRuntimeDefaults(

      hfRepo,

      huggingFaceToken: huggingFaceToken,

    );



    debugPrint(

      'Gemma3nLitertClient: loading LiteRT-LM runtime for $hfRepo '

      '(this can take 1–3+ min on device)…',

    );

    final sw = Stopwatch()..start();

    _loadedModel = await FlutterEdgeAi.getActiveModel(

      defaults: _runtimeDefaults,

      maxTokens: 2048,

      supportImage: true,

      maxNumImages: 1,

      preferredBackend: PreferredBackend.gpu,

    );

    debugPrint(

      'Gemma3nLitertClient: runtime ready in ${sw.elapsed.inSeconds}s',

    );

    return _loadedModel!;

  }



  Future<ModelRuntimeDefaults?> _resolveRuntimeDefaults(

    String hfRepo, {

    String? huggingFaceToken,

  }) async {

    try {

      final resolved = await FlutterEdgeAi.resolveHuggingFace(

        hfRepo,

        fileType: ModelFileType.litertlm,

        token: huggingFaceToken,

      );

      return resolved.runtime;

    } catch (e) {

      debugPrint('Gemma3nLitertClient: HF manifest resolve skipped: $e');

      return null;

    }

  }



  Uint8List _prepareImageForVision(Uint8List raw) {

    final decoded = img.decodeImage(raw);

    if (decoded == null) {

      throw FormatException('Could not decode image for vision input');

    }

    final oriented = img.bakeOrientation(decoded);

    final longest = math.max(oriented.width, oriented.height);

    if (longest <= kGemma3nSpikeMaxImageLongestEdge) {

      return Uint8List.fromList(img.encodeJpg(oriented, quality: 88));

    }

    final scale = kGemma3nSpikeMaxImageLongestEdge / longest;

    final resized = img.copyResize(

      oriented,

      width: (oriented.width * scale).round(),

      height: (oriented.height * scale).round(),

    );

    return Uint8List.fromList(img.encodeJpg(resized, quality: 88));

  }

}


