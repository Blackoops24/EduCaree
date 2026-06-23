import 'package:educare/features/students/domain/entities/admission_request.dart';

class AdmissionRequestModel extends AdmissionRequest {
  const AdmissionRequestModel({
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.dateOfBirth,
    required super.grade,
    required super.section,
    required super.guardianName,
    required super.guardianPhone,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'date_of_birth': dateOfBirth,
      'grade': grade,
      'section': section,
      'guardian_name': guardianName,
      'guardian_phone': guardianPhone,
    };
  }
}
