import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicine_remainder_app/features/medicines/presentation/medicine_list_screen.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/capture_screen.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/document_verify_screen.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/extraction_review_screen.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/prescription_review_screen.dart';
import 'package:medicine_remainder_app/features/reminders/presentation/adherence_screen.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const capture = '/capture';
  static const documentVerify = '/document-verify';
  static const prescriptionReview = '/prescription-review';
  /// Legacy path kept for deep links; prefer [documentVerify].
  static const ocrReview = '/ocr-review';
  static const extractionReview = '/extraction-review';
  static const adherence = '/adherence';
}

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MedicineListScreen(),
      ),
      GoRoute(
        path: AppRoutes.capture,
        builder: (context, state) => const CaptureScreen(),
      ),
      GoRoute(
        path: AppRoutes.documentVerify,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! DocumentVerifyRouteArgs) {
            return const _RouteErrorScreen(
              message: 'Missing document verification arguments.',
            );
          }
          return DocumentVerifyScreen(imagePath: extra.imagePath);
        },
      ),

      GoRoute(
        path: AppRoutes.prescriptionReview,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! PrescriptionReviewRouteArgs) {
            return const _RouteErrorScreen(
              message: 'Missing prescription review arguments.',
            );
          }
          return PrescriptionReviewScreen(
            imagePath: extra.imagePath,
            bundle: extra.bundle,
          );
        },
      ),

      GoRoute(
        path: AppRoutes.extractionReview,
        builder: (context, state) => const ExtractionReviewScreen(),
      ),

      GoRoute(
        path: AppRoutes.adherence,
        builder: (context, state) => const AdherenceScreen(),
      ),

    ],
  );
}

class _RouteErrorScreen extends StatelessWidget {
  const _RouteErrorScreen({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation error')),
      body: Center(child: Text(message)),
    );
  }
}