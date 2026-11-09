import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_review_bundle.dart';

/// Holds prescription flow data across go_router refreshes (extras are lost on redirect).
class PrescriptionFlowState {
  const PrescriptionFlowState({
    this.documentImagePath,
    this.reviewBundle,
    this.reviewUserId,
  });

  final String? documentImagePath;
  final PrescriptionReviewBundle? reviewBundle;
  final String? reviewUserId;

  PrescriptionFlowState copyWith({
    String? documentImagePath,
    PrescriptionReviewBundle? reviewBundle,
    String? reviewUserId,
    bool clearReview = false,
  }) {
    return PrescriptionFlowState(
      documentImagePath: documentImagePath ?? this.documentImagePath,
      reviewBundle: clearReview ? null : (reviewBundle ?? this.reviewBundle),
      reviewUserId: clearReview ? null : (reviewUserId ?? this.reviewUserId),
    );
  }
}

class PrescriptionFlowNotifier extends Notifier<PrescriptionFlowState> {
  @override
  PrescriptionFlowState build() => const PrescriptionFlowState();

  void setDocumentImagePath(String path) {
    state = state.copyWith(documentImagePath: path, clearReview: true);
  }

  void setReviewSession({
    required String imagePath,
    required PrescriptionReviewBundle bundle,
    required String userId,
  }) {
    state = PrescriptionFlowState(
      documentImagePath: imagePath,
      reviewBundle: bundle,
      reviewUserId: userId,
    );
  }

  void clear() {
    state = const PrescriptionFlowState();
  }
}

final prescriptionFlowProvider =
    NotifierProvider<PrescriptionFlowNotifier, PrescriptionFlowState>(
  PrescriptionFlowNotifier.new,
);
