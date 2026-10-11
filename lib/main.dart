import 'package:flutter/material.dart';
import 'package:flutter_edge_ai/flutter_edge_ai.dart';
import 'package:flutter_edge_ai_litertlm/flutter_edge_ai_litertlm.dart';
import 'package:medicine_remainder_app/app/app.dart';
import 'package:medicine_remainder_app/shared/config/huggingface_token.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterEdgeAi.initialize(
    inferenceEngines: const [LiteRtLmEngine()],
    huggingFaceToken: resolveHuggingFaceToken(),
  );
  runApp(const MedicineReminderApp());
}
