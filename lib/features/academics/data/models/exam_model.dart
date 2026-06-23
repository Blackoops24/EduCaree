import 'package:educare/features/academics/domain/entities/exam.dart';

class ExamModel extends Exam {
  const ExamModel({
    required super.id,
    required super.examName,
    required super.examType,
    required super.startDate,
    required super.endDate,
    required super.totalMarks,
    required super.passingMarks,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'] as int,
      examName: json['exam_name'] as String,
      examType: json['exam_type'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      totalMarks: json['total_marks'] as int,
      passingMarks: json['passing_marks'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exam_name': examName,
      'exam_type': examType,
      'start_date': startDate,
      'end_date': endDate,
      'total_marks': totalMarks,
      'passing_marks': passingMarks,
    };
  }
}
