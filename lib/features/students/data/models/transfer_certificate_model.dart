import 'package:educare/features/students/domain/entities/transfer_certificate.dart';

class TransferCertificateModel extends TransferCertificate {
  const TransferCertificateModel({
    required super.studentId,
    required super.studentName,
    required super.fromSchool,
    required super.toSchool,
    required super.issuedDate,
    required super.reason,
  });

  factory TransferCertificateModel.fromJson(Map<String, dynamic> json) {
    return TransferCertificateModel(
      studentId: json['student_id'] as int,
      studentName: json['student_name'] as String,
      fromSchool: json['from_school'] as String,
      toSchool: json['to_school'] as String,
      issuedDate: json['issued_date'] as String,
      reason: json['reason'] as String,
    );
  }
}
