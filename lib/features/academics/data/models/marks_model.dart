import 'package:educare/features/academics/domain/entities/marks.dart';

class MarksModel extends Marks {
  const MarksModel({
    required super.id,
    required super.studentId,
    required super.studentName,
    required super.examId,
    required super.subjectId,
    required super.subjectName,
    required super.obtainedMarks,
    required super.totalMarks,
    required super.percentage,
    required super.grade,
  });

  factory MarksModel.fromJson(Map<String, dynamic> json) {
    return MarksModel(
      id: json['id'] as int,
      studentId: json['student_id'] as int,
      studentName: json['student_name'] as String,
      examId: json['exam_id'] as int,
      subjectId: json['subject_id'] as int,
      subjectName: json['subject_name'] as String,
      obtainedMarks: (json['obtained_marks'] as num).toDouble(),
      totalMarks: json['total_marks'] as int,
      percentage: (json['percentage'] as num).toDouble(),
      grade: json['grade'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'student_name': studentName,
      'exam_id': examId,
      'subject_id': subjectId,
      'subject_name': subjectName,
      'obtained_marks': obtainedMarks,
      'total_marks': totalMarks,
      'percentage': percentage,
      'grade': grade,
    };
  }
}
