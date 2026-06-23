import 'package:educare/features/students/domain/entities/student_document.dart';

class StudentDocumentModel extends StudentDocument {
  const StudentDocumentModel({
    required super.id,
    required super.studentId,
    required super.title,
    required super.documentType,
    required super.url,
  });

  factory StudentDocumentModel.fromJson(Map<String, dynamic> json) {
    return StudentDocumentModel(
      id: json['id'] as int,
      studentId: json['student_id'] as int,
      title: json['title'] as String,
      documentType: json['document_type'] as String,
      url: json['url'] as String,
    );
  }
}
