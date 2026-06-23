import 'package:educare/features/students/domain/entities/admission_request.dart';
import 'package:educare/features/students/domain/entities/alumni_record.dart';
import 'package:educare/features/students/domain/entities/student.dart';
import 'package:educare/features/students/domain/entities/student_document.dart';
import 'package:educare/features/students/domain/entities/transfer_certificate.dart';

abstract class StudentRepository {
  Future<List<Student>> fetchStudents();
  Future<Student> fetchStudentProfile(int studentId);
  Future<bool> submitAdmission(AdmissionRequest request);
  Future<List<StudentDocument>> fetchDocuments(int studentId);
  Future<TransferCertificate> requestTransferCertificate(int studentId, String toSchool, String reason);
  Future<List<AlumniRecord>> fetchAlumni();
}
