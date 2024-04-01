// lib/models/feedback_info.dart

class FeedbackInfo {
  final String sessionId;
  final String branchId;
  final int score;
  final String comment;

  FeedbackInfo({
    required this.sessionId,
    required this.branchId,
    required this.score,
    this.comment = "",
  });

  Map<String, dynamic> toJson() => {
        "sessionId": sessionId,
        "branchId": branchId,
        "score": score,
        "comment": comment,
      };
}
