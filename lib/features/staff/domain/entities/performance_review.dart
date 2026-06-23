class PerformanceReview {
  final int id;
  final int staffId;
  final String reviewDate;
  final String score;
  final String comments;

  const PerformanceReview({
    required this.id,
    required this.staffId,
    required this.reviewDate,
    required this.score,
    required this.comments,
  });
}
