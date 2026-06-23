import 'package:educare/features/students/data/datasources/student_remote_datasource.dart';
import 'package:educare/features/students/data/models/admission_request_model.dart';
import 'package:educare/features/students/domain/entities/admission_request.dart';
import 'package:educare/features/students/domain/entities/alumni_record.dart';
import 'package:educare/features/students/domain/entities/student.dart';
import 'package:educare/features/students/domain/entities/student_document.dart';
import 'package:educare/features/students/domain/entities/transfer_certificate.dart';
import 'package:educare/features/students/domain/repositories/student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentRemoteDatasource _datasource;

  StudentRepositoryImpl(this._datasource);

  @override
  Future<List<Student>> fetchStudents() {
    return _datasource.fetchStudents();
  }

  @override
  Future<Student> fetchStudentProfile(int studentId) {
    return _datasource.fetchStudentProfile(studentId);
  }

  @override
  Future<bool> submitAdmission(AdmissionRequest request) {
    final admissionModel = AdmissionRequestModel(
      firstName: request.firstName,
      lastName: request.lastName,
      email: request.email,
      dateOfBirth: request.dateOfBirth,
      grade: request.grade,
      section: request.section,
      guardianName: request.guardianName,
      guardianPhone: request.guardianPhone,
    );
    return _datasource.submitAdmission(admissionModel);
  }

  @override
  Future<List<StudentDocument>> fetchDocuments(int studentId) {
    return _datasource.fetchDocuments(studentId);
  }

  @override
  Future<TransferCertificate> requestTransferCertificate(int studentId, String toSchool, String reason) {
    return _datasource.requestTransferCertificate(studentId, toSchool, reason);
  }

  @override
  Future<List<AlumniRecord>> fetchAlumni() {
    return _datasource.fetchAlumni();
  }
}
