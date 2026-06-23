import 'package:educare/features/academics/domain/entities/report_card.dart';

class ReportCardModel extends ReportCard {
  const ReportCardModel({
    required super.id,
    required super.studentId,
    required super.studentName,
    required super.rollNumber,
    required super.classId,
    required super.className,
    required super.academicYear,
    required super.gpa,
    required super.cgpa,
    required super.overallGrade,
    required super.remarks,
    required super.generatedDate,
    required super.subjectMarks,
  });

  factory ReportCardModel.fromJson(Map<String, dynamic> json) {
    return ReportCardModel(
      id: json['id'] as int,
      studentId: json['student_id'] as int,
      studentName: json['student_name'] as String,
      rollNumber: json['roll_number'] as String,
      classId: json['class_id'] as int,
      className: json['class_name'] as String,
      academicYear: json['academic_year'] as String,
      gpa: (json['gpa'] as num).toDouble(),
      cgpa: (json['cgpa'] as num).toDouble(),
      overallGrade: json['overall_grade'] as String,
      remarks: json['remarks'] as String,
      generatedDate: json['generated_date'] as String,
      subjectMarks: List<String>.from(json['subject_marks'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'student_name': studentName,
      'roll_number': rollNumber,
      'class_id': classId,
      'class_name': className,
      'academic_year': academicYear,
      'gpa': gpa,
      'cgpa': cgpa,
      'overall_grade': overallGrade,
      'remarks': remarks,
      'generated_date': generatedDate,
      'subject_marks': subjectMarks,
    };
  }
}
