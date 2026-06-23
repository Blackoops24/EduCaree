import 'package:educare/features/staff/domain/entities/performance_review.dart';

class PerformanceReviewModel extends PerformanceReview {
  const PerformanceReviewModel({
    required super.id,
    required super.staffId,
    required super.reviewDate,
    required super.score,
    required super.comments,
  });

  factory PerformanceReviewModel.fromJson(Map<String, dynamic> json) {
    return PerformanceReviewModel(
      id: json['id'] as int,
      staffId: json['staff_id'] as int,
      reviewDate: json['review_date'] as String,
      score: json['score'] as String,
      comments: json['comments'] as String,
    );
  }
}
