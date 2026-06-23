import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educare/features/students/domain/entities/admission_request.dart';
import 'package:educare/features/students/domain/entities/alumni_record.dart';
import 'package:educare/features/students/domain/entities/student.dart';
import 'package:educare/features/students/domain/entities/student_document.dart';
import 'package:educare/features/students/domain/entities/transfer_certificate.dart';
import 'package:educare/features/students/domain/usecases/fetch_alumni_usecase.dart';
import 'package:educare/features/students/domain/usecases/fetch_documents_usecase.dart';
import 'package:educare/features/students/domain/usecases/fetch_student_profile_usecase.dart';
import 'package:educare/features/students/domain/usecases/fetch_students_usecase.dart';
import 'package:educare/features/students/domain/usecases/request_transfer_certificate_usecase.dart';
import 'package:educare/features/students/domain/usecases/submit_admission_usecase.dart';

class StudentState {
  final bool loading;
  final String? error;
  final List<Student> students;
  final Student? selectedStudent;
  final List<StudentDocument> documents;
  final bool admissionSuccess;
  final TransferCertificate? transferCertificate;
  final List<AlumniRecord> alumni;

  const StudentState({
    this.loading = false,
    this.error,
    this.students = const [],
    this.selectedStudent,
    this.documents = const [],
    this.admissionSuccess = false,
    this.transferCertificate,
    this.alumni = const [],
  });

  StudentState copyWith({
    bool? loading,
    String? error,
    List<Student>? students,
    Student? selectedStudent,
    List<StudentDocument>? documents,
    bool? admissionSuccess,
    TransferCertificate? transferCertificate,
    List<AlumniRecord>? alumni,
  }) {
    return StudentState(
      loading: loading ?? this.loading,
      error: error,
      students: students ?? this.students,
      selectedStudent: selectedStudent ?? this.selectedStudent,
      documents: documents ?? this.documents,
      admissionSuccess: admissionSuccess ?? this.admissionSuccess,
      transferCertificate: transferCertificate ?? this.transferCertificate,
      alumni: alumni ?? this.alumni,
    );
  }
}

class StudentViewModel extends StateNotifier<StudentState> {
  final FetchStudentsUseCase _fetchStudents;
  final FetchStudentProfileUseCase _fetchStudentProfile;
  final SubmitAdmissionUseCase _submitAdmission;
  final FetchDocumentsUseCase _fetchDocuments;
  final RequestTransferCertificateUseCase _requestTransferCertificate;
  final FetchAlumniUseCase _fetchAlumni;

  StudentViewModel(
    this._fetchStudents,
    this._fetchStudentProfile,
    this._submitAdmission,
    this._fetchDocuments,
    this._requestTransferCertificate,
    this._fetchAlumni,
  ) : super(const StudentState());

  Future<void> loadStudents() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final students = await _fetchStudents.execute();
      state = state.copyWith(students: students, loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Unable to load students.');
    }
  }

  Future<void> loadStudentProfile(int studentId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final profile = await _fetchStudentProfile.execute(studentId);
      state = state.copyWith(selectedStudent: profile, loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Could not load student profile.');
    }
  }

  Future<void> submitAdmission(AdmissionRequest request) async {
    state = state.copyWith(loading: true, error: null, admissionSuccess: false);
    try {
      final success = await _submitAdmission.execute(request);
      state = state.copyWith(admissionSuccess: success, loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Admission submission failed.');
    }
  }

  Future<void> loadDocuments(int studentId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final documents = await _fetchDocuments.execute(studentId);
      state = state.copyWith(documents: documents, loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Unable to load documents.');
    }
  }

  Future<void> requestTransferCertificate(int studentId, String toSchool, String reason) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final certificate = await _requestTransferCertificate.execute(studentId, toSchool, reason);
      state = state.copyWith(transferCertificate: certificate, loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Transfer certificate request failed.');
    }
  }

  Future<void> loadAlumni() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final alumni = await _fetchAlumni.execute();
      state = state.copyWith(alumni: alumni, loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Unable to load alumni records.');
    }
  }
}
