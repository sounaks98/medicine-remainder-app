import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicine_remainder_app/features/medicines/presentation/medicine_list_screen.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/capture_screen.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/document_verify_screen.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/extraction_review_screen.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/model_spike_screen.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/prescription_review_screen.dart';
import 'package:medicine_remainder_app/features/reminders/presentation/adherence_screen.dart';
import 'package:medicine_remainder_app/features/users/application/active_user_controller.dart';
import 'package:medicine_remainder_app/features/users/presentation/add_user_screen.dart';
import 'package:medicine_remainder_app/features/prescription/application/prescription_flow_state.dart';
import 'package:medicine_remainder_app/features/users/presentation/user_list_screen.dart';
import 'package:medicine_remainder_app/features/users/presentation/user_profile_settings_screen.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const users = '/users';
  static const usersAdd = '/users/add';
  static String userHome(String userId) => '/users/$userId/home';
  static String userSettings(String userId) => '/users/$userId/settings';
  static const capture = '/capture';
  static const documentVerify = '/document-verify';
  static const prescriptionReview = '/prescription-review';
  /// Legacy path kept for deep links; prefer [documentVerify].
  static const ocrReview = '/ocr-review';
  static const extractionReview = '/extraction-review';
  static const adherence = '/adherence';
  static const modelSpike = '/dev/model-spike';

  static bool isPrescriptionFlowPath(String path) {
    return path == capture ||
        path == documentVerify ||
        path == prescriptionReview ||
        path == extractionReview ||
        path == ocrReview;
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  // [read] only: [watch] would rebuild this provider on every session refresh and
  // recreate GoRouter, which can stall navigation/tests.
  final refresh = ref.read(activeUserSessionRefreshListenableProvider);

  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: refresh,
    redirect: (context, state) {
      final session = ref.read(activeUserSessionProvider);
      if (!session.isReady) {
        return null;
      }

      final path = state.uri.path;
      if (AppRoutes.isPrescriptionFlowPath(path)) {
        return null;
      }
      final onUsersList = path == AppRoutes.users;
      final onUsersAdd = path == AppRoutes.usersAdd;
      final onUserScopedRoute = path.startsWith('/users/');

      if (!session.hasUsers && !onUsersAdd) {
        return AppRoutes.usersAdd;
      }

      if (session.hasUsers && session.activeUserId == null) {
        if (!onUsersList && !onUsersAdd) {
          return AppRoutes.users;
        }
        return null;
      }

      final activeId = session.activeUserId;
      if (activeId != null) {
        if (path == AppRoutes.home) {
          return AppRoutes.userHome(activeId);
        }
      }

      if (onUserScopedRoute && path.endsWith('/home')) {
        final segments = state.uri.pathSegments;
        if (segments.length >= 2 && segments[0] == 'users') {
          final routeUserId = segments[1];
          if (activeId != null && routeUserId != activeId) {
            return AppRoutes.userHome(activeId);
          }
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.users,
        builder: (context, state) => const UserListScreen(),
      ),
      GoRoute(
        path: AppRoutes.usersAdd,
        builder: (context, state) => const AddUserScreen(),
      ),
      GoRoute(
        path: '/users/:userId/home',
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          return MedicineListScreen(userId: userId);
        },
      ),
      GoRoute(
        path: '/users/:userId/settings',
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          return UserProfileSettingsScreen(userId: userId);
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        redirect: (context, state) {
          final session = ref.read(activeUserSessionProvider);
          if (session.activeUserId != null) {
            return AppRoutes.userHome(session.activeUserId!);
          }
          return AppRoutes.users;
        },
      ),
      GoRoute(
        path: AppRoutes.capture,
        builder: (context, state) => const CaptureScreen(),
      ),
      GoRoute(
        path: AppRoutes.documentVerify,
        builder: (context, state) {
          final extra = state.extra;
          final flow = ref.read(prescriptionFlowProvider);
          final imagePath = extra is DocumentVerifyRouteArgs
              ? extra.imagePath
              : flow.documentImagePath;
          if (imagePath == null || imagePath.isEmpty) {
            return const _RouteErrorScreen(
              message: 'Missing document verification arguments.',
            );
          }
          return DocumentVerifyScreen(imagePath: imagePath);
        },
      ),
      GoRoute(
        path: AppRoutes.prescriptionReview,
        builder: (context, state) {
          final extra = state.extra;
          final flow = ref.read(prescriptionFlowProvider);
          if (extra is PrescriptionReviewRouteArgs) {
            return PrescriptionReviewScreen(
              imagePath: extra.imagePath,
              bundle: extra.bundle,
              userId: extra.userId,
            );
          }
          if (flow.reviewBundle != null &&
              flow.documentImagePath != null &&
              flow.reviewUserId != null) {
            return PrescriptionReviewScreen(
              imagePath: flow.documentImagePath!,
              bundle: flow.reviewBundle!,
              userId: flow.reviewUserId!,
            );
          }
          return const _RouteErrorScreen(
            message: 'Missing prescription review arguments.',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.extractionReview,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! ExtractionReviewRouteArgs) {
            return const _RouteErrorScreen(
              message: 'Missing extraction review arguments.',
            );
          }
          return ExtractionReviewScreen(
            draft: extra.draft,
            userId: extra.userId,
            imagePath: extra.imagePath,
            prescriptionImport: extra.prescriptionImport,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.adherence,
        builder: (context, state) => const AdherenceScreen(),
      ),
      if (kDebugMode)
        GoRoute(
          path: AppRoutes.modelSpike,
          builder: (context, state) => const ModelSpikeScreen(),
        ),
    ],
  );
});

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
