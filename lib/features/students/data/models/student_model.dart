import 'package:educare/features/students/domain/entities/student.dart';

class StudentModel extends Student {
  const StudentModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.admissionNumber,
    required super.grade,
    required super.section,
    required super.active,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      admissionNumber: json['admission_number'] as String,
      grade: json['grade'] as String,
      section: json['section'] as String,
      active: json['active'] as bool,
    );
  }
}
