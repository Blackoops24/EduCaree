import 'package:educare/features/students/data/models/admission_request_model.dart';
import 'package:educare/features/students/data/models/alumni_record_model.dart';
import 'package:educare/features/students/data/models/student_document_model.dart';
import 'package:educare/features/students/data/models/student_model.dart';
import 'package:educare/features/students/data/models/transfer_certificate_model.dart';
import 'package:educare/features/students/data/services/student_service.dart';

class StudentRemoteDatasource {
  final StudentService _studentService;

  StudentRemoteDatasource(this._studentService);

  Future<List<StudentModel>> fetchStudents() async {
    final response = await _studentService.fetch('/students');
    final rawList = List<Map<String, dynamic>>.from(response.data as List<dynamic>);
    return rawList.map(StudentModel.fromJson).toList();
  }

  Future<StudentModel> fetchStudentProfile(int studentId) async {
    final response = await _studentService.fetch('/students/$studentId');
    return StudentModel.fromJson(Map<String, dynamic>.from(response.data as Map<String, dynamic>));
  }

  Future<bool> submitAdmission(AdmissionRequestModel request) async {
    final response = await _studentService.post('/students/admission', data: request.toJson());
    return response.statusCode == 201 || response.statusCode == 200;
  }

  Future<List<StudentDocumentModel>> fetchDocuments(int studentId) async {
    final response = await _studentService.fetch('/students/$studentId/documents');
    final rawList = List<Map<String, dynamic>>.from(response.data as List<dynamic>);
    return rawList.map(StudentDocumentModel.fromJson).toList();
  }

  Future<TransferCertificateModel> requestTransferCertificate(int studentId, String toSchool, String reason) async {
    final response = await _studentService.post(
      '/students/$studentId/transfer-certificate',
      data: {
        'to_school': toSchool,
        'reason': reason,
      },
    );
    return TransferCertificateModel.fromJson(Map<String, dynamic>.from(response.data as Map<String, dynamic>));
  }

  Future<List<AlumniRecordModel>> fetchAlumni() async {
    final response = await _studentService.fetch('/students/alumni');
    final rawList = List<Map<String, dynamic>>.from(response.data as List<dynamic>);
    return rawList.map(AlumniRecordModel.fromJson).toList();
  }
}
