import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educare/core/services/api_service.dart';
import 'package:educare/features/academics/data/datasources/academic_remote_datasource.dart';
import 'package:educare/features/academics/data/repositories/academic_repository_impl.dart';
import 'package:educare/features/academics/data/services/academic_service.dart';
import 'package:educare/features/academics/domain/usecases/create_class_usecase.dart';
import 'package:educare/features/academics/domain/usecases/fetch_classes_usecase.dart';
import 'package:educare/features/academics/domain/usecases/fetch_exams_usecase.dart';
import 'package:educare/features/academics/domain/usecases/fetch_marks_usecase.dart';
import 'package:educare/features/academics/domain/usecases/fetch_report_card_usecase.dart';
import 'package:educare/features/academics/domain/usecases/fetch_sections_usecase.dart';
import 'package:educare/features/academics/domain/usecases/fetch_subjects_usecase.dart';
import 'package:educare/features/academics/domain/usecases/fetch_weekly_timetable_usecase.dart';
import 'package:educare/features/academics/presentation/viewmodels/academic_view_model.dart';
import 'package:educare/features/attendance/data/datasources/attendance_remote_datasource.dart';
import 'package:educare/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:educare/features/attendance/data/services/attendance_service.dart';
import 'package:educare/features/attendance/domain/usecases/detect_face_usecase.dart';
import 'package:educare/features/attendance/domain/usecases/fetch_biometric_devices_usecase.dart';
import 'package:educare/features/attendance/domain/usecases/fetch_face_recognition_records_usecase.dart';
import 'package:educare/features/attendance/domain/usecases/fetch_staff_daily_attendance_usecase.dart';
import 'package:educare/features/attendance/domain/usecases/fetch_staff_monthly_attendance_usecase.dart';
import 'package:educare/features/attendance/domain/usecases/fetch_student_daily_attendance_usecase.dart';
import 'package:educare/features/attendance/domain/usecases/fetch_student_monthly_attendance_usecase.dart';
import 'package:educare/features/attendance/domain/usecases/generate_attendance_report_usecase.dart';
import 'package:educare/features/attendance/domain/usecases/initialize_face_recognition_usecase.dart';
import 'package:educare/features/attendance/domain/usecases/mark_staff_check_in_usecase.dart';
import 'package:educare/features/attendance/domain/usecases/mark_staff_check_out_usecase.dart';
import 'package:educare/features/attendance/domain/usecases/mark_student_attendance_usecase.dart';
import 'package:educare/features/attendance/domain/usecases/record_face_recognition_usecase.dart';
import 'package:educare/features/attendance/domain/usecases/sync_biometric_device_usecase.dart';
import 'package:educare/features/attendance/presentation/viewmodels/attendance_view_model.dart';
import 'package:educare/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:educare/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:educare/features/authentication/domain/usecases/login_usecase.dart';
import 'package:educare/features/authentication/presentation/viewmodels/auth_view_model.dart';
import 'package:educare/features/students/data/datasources/student_remote_datasource.dart';
import 'package:educare/features/students/data/repositories/student_repository_impl.dart';
import 'package:educare/features/students/data/services/student_service.dart';
import 'package:educare/features/students/domain/usecases/fetch_alumni_usecase.dart';
import 'package:educare/features/students/domain/usecases/fetch_documents_usecase.dart';
import 'package:educare/features/students/domain/usecases/fetch_student_profile_usecase.dart';
import 'package:educare/features/students/domain/usecases/fetch_students_usecase.dart';
import 'package:educare/features/students/domain/usecases/request_transfer_certificate_usecase.dart';
import 'package:educare/features/students/domain/usecases/submit_admission_usecase.dart';
import 'package:educare/features/students/presentation/viewmodels/student_view_model.dart';
import 'package:educare/features/staff/data/datasources/staff_remote_datasource.dart';
import 'package:educare/features/staff/data/repositories/staff_repository_impl.dart';
import 'package:educare/features/staff/data/services/staff_service.dart';
import 'package:educare/features/staff/domain/usecases/fetch_attendance_usecase.dart';
import 'package:educare/features/staff/domain/usecases/fetch_leave_requests_usecase.dart';
import 'package:educare/features/staff/domain/usecases/fetch_performance_usecase.dart';
import 'package:educare/features/staff/domain/usecases/fetch_salary_details_usecase.dart';
import 'package:educare/features/staff/domain/usecases/fetch_staff_profile_usecase.dart';
import 'package:educare/features/staff/domain/usecases/fetch_staff_usecase.dart';
import 'package:educare/features/staff/domain/usecases/register_staff_usecase.dart';
import 'package:educare/features/staff/presentation/viewmodels/staff_view_model.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system);

  void toggleTheme() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>(
  (ref) => AuthRemoteDatasource(ref.watch(apiServiceProvider)),
);

final authRepositoryProvider = Provider<AuthRepositoryImpl>(
  (ref) => AuthRepositoryImpl(ref.watch(authRemoteDatasourceProvider)),
);

final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.watch(authRepositoryProvider)),
);

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>(
  (ref) => AuthViewModel(
    ref.watch(loginUseCaseProvider),
    ref.watch(authRepositoryProvider),
  ),
);

final studentServiceProvider = Provider<StudentService>(
  (ref) => StudentService(ref.watch(apiServiceProvider)),
);

final studentRemoteDatasourceProvider = Provider<StudentRemoteDatasource>(
  (ref) => StudentRemoteDatasource(ref.watch(studentServiceProvider)),
);

final studentRepositoryProvider = Provider<StudentRepositoryImpl>(
  (ref) => StudentRepositoryImpl(ref.watch(studentRemoteDatasourceProvider)),
);

final fetchStudentsUseCaseProvider = Provider<FetchStudentsUseCase>(
  (ref) => FetchStudentsUseCase(ref.watch(studentRepositoryProvider)),
);

final fetchStudentProfileUseCaseProvider = Provider<FetchStudentProfileUseCase>(
  (ref) => FetchStudentProfileUseCase(ref.watch(studentRepositoryProvider)),
);

final submitAdmissionUseCaseProvider = Provider<SubmitAdmissionUseCase>(
  (ref) => SubmitAdmissionUseCase(ref.watch(studentRepositoryProvider)),
);

final fetchDocumentsUseCaseProvider = Provider<FetchDocumentsUseCase>(
  (ref) => FetchDocumentsUseCase(ref.watch(studentRepositoryProvider)),
);

final requestTransferCertificateUseCaseProvider = Provider<RequestTransferCertificateUseCase>(
  (ref) => RequestTransferCertificateUseCase(ref.watch(studentRepositoryProvider)),
);

final fetchAlumniUseCaseProvider = Provider<FetchAlumniUseCase>(
  (ref) => FetchAlumniUseCase(ref.watch(studentRepositoryProvider)),
);

final studentViewModelProvider = StateNotifierProvider<StudentViewModel, StudentState>(
  (ref) => StudentViewModel(
    ref.watch(fetchStudentsUseCaseProvider),
    ref.watch(fetchStudentProfileUseCaseProvider),
    ref.watch(submitAdmissionUseCaseProvider),
    ref.watch(fetchDocumentsUseCaseProvider),
    ref.watch(requestTransferCertificateUseCaseProvider),
    ref.watch(fetchAlumniUseCaseProvider),
  ),
);

final staffServiceProvider = Provider<StaffService>(
  (ref) => StaffService(ref.watch(apiServiceProvider)),
);

final staffRemoteDatasourceProvider = Provider<StaffRemoteDatasource>(
  (ref) => StaffRemoteDatasource(ref.watch(staffServiceProvider)),
);

final staffRepositoryProvider = Provider<StaffRepositoryImpl>(
  (ref) => StaffRepositoryImpl(ref.watch(staffRemoteDatasourceProvider)),
);

final fetchStaffUseCaseProvider = Provider<FetchStaffUseCase>(
  (ref) => FetchStaffUseCase(ref.watch(staffRepositoryProvider)),
);

final fetchStaffProfileUseCaseProvider = Provider<FetchStaffProfileUseCase>(
  (ref) => FetchStaffProfileUseCase(ref.watch(staffRepositoryProvider)),
);

final registerStaffUseCaseProvider = Provider<RegisterStaffUseCase>(
  (ref) => RegisterStaffUseCase(ref.watch(staffRepositoryProvider)),
);

final fetchLeaveRequestsUseCaseProvider = Provider<FetchLeaveRequestsUseCase>(
  (ref) => FetchLeaveRequestsUseCase(ref.watch(staffRepositoryProvider)),
);

final fetchAttendanceUseCaseProvider = Provider<FetchAttendanceUseCase>(
  (ref) => FetchAttendanceUseCase(ref.watch(staffRepositoryProvider)),
);

final fetchPerformanceUseCaseProvider = Provider<FetchPerformanceUseCase>(
  (ref) => FetchPerformanceUseCase(ref.watch(staffRepositoryProvider)),
);

final fetchSalaryDetailsUseCaseProvider = Provider<FetchSalaryDetailsUseCase>(
  (ref) => FetchSalaryDetailsUseCase(ref.watch(staffRepositoryProvider)),
);

final staffViewModelProvider = StateNotifierProvider<StaffViewModel, StaffState>(
  (ref) => StaffViewModel(
    ref.watch(fetchStaffUseCaseProvider),
    ref.watch(fetchStaffProfileUseCaseProvider),
    ref.watch(registerStaffUseCaseProvider),
    ref.watch(fetchLeaveRequestsUseCaseProvider),
    ref.watch(fetchAttendanceUseCaseProvider),
    ref.watch(fetchPerformanceUseCaseProvider),
    ref.watch(fetchSalaryDetailsUseCaseProvider),
  ),
);

final academicServiceProvider = Provider<AcademicService>(
  (ref) => AcademicService(ref.watch(apiServiceProvider)),
);

final academicRemoteDatasourceProvider = Provider<AcademicRemoteDatasource>(
  (ref) => AcademicRemoteDatasource(ref.watch(academicServiceProvider)),
);

final academicRepositoryProvider = Provider<AcademicRepositoryImpl>(
  (ref) => AcademicRepositoryImpl(ref.watch(academicRemoteDatasourceProvider)),
);

final fetchClassesUseCaseProvider = Provider<FetchClassesUseCase>(
  (ref) => FetchClassesUseCase(ref.watch(academicRepositoryProvider)),
);

final createClassUseCaseProvider = Provider<CreateClassUseCase>(
  (ref) => CreateClassUseCase(ref.watch(academicRepositoryProvider)),
);

final fetchSectionsUseCaseProvider = Provider<FetchSectionsUseCase>(
  (ref) => FetchSectionsUseCase(ref.watch(academicRepositoryProvider)),
);

final fetchSubjectsUseCaseProvider = Provider<FetchSubjectsUseCase>(
  (ref) => FetchSubjectsUseCase(ref.watch(academicRepositoryProvider)),
);

final fetchWeeklyTimetableUseCaseProvider = Provider<FetchWeeklyTimetableUseCase>(
  (ref) => FetchWeeklyTimetableUseCase(ref.watch(academicRepositoryProvider)),
);

final fetchExamsUseCaseProvider = Provider<FetchExamsUseCase>(
  (ref) => FetchExamsUseCase(ref.watch(academicRepositoryProvider)),
);

final fetchMarksUseCaseProvider = Provider<FetchMarksUseCase>(
  (ref) => FetchMarksUseCase(ref.watch(academicRepositoryProvider)),
);

final fetchReportCardUseCaseProvider = Provider<FetchReportCardUseCase>(
  (ref) => FetchReportCardUseCase(ref.watch(academicRepositoryProvider)),
);

final academicViewModelProvider = StateNotifierProvider<AcademicViewModel, AcademicState>(
  (ref) => AcademicViewModel(
    ref.watch(fetchClassesUseCaseProvider),
    ref.watch(createClassUseCaseProvider),
    ref.watch(fetchSectionsUseCaseProvider),
    ref.watch(fetchSubjectsUseCaseProvider),
    ref.watch(fetchWeeklyTimetableUseCaseProvider),
    ref.watch(fetchExamsUseCaseProvider),
    ref.watch(fetchMarksUseCaseProvider),
    ref.watch(fetchReportCardUseCaseProvider),
  ),
);

final attendanceServiceProvider = Provider<AttendanceService>(
  (ref) => AttendanceService(ref.watch(apiServiceProvider)),
);

final attendanceRemoteDatasourceProvider = Provider<AttendanceRemoteDatasource>(
  (ref) => AttendanceRemoteDatasource(ref.watch(attendanceServiceProvider)),
);

final attendanceRepositoryProvider = Provider<AttendanceRepositoryImpl>(
  (ref) => AttendanceRepositoryImpl(ref.watch(attendanceRemoteDatasourceProvider)),
);

final fetchStudentDailyAttendanceUseCaseProvider = Provider<FetchStudentDailyAttendanceUseCase>(
  (ref) => FetchStudentDailyAttendanceUseCase(ref.watch(attendanceRepositoryProvider)),
);

final fetchStudentMonthlyAttendanceUseCaseProvider = Provider<FetchStudentMonthlyAttendanceUseCase>(
  (ref) => FetchStudentMonthlyAttendanceUseCase(ref.watch(attendanceRepositoryProvider)),
);

final markStudentAttendanceUseCaseProvider = Provider<MarkStudentAttendanceUseCase>(
  (ref) => MarkStudentAttendanceUseCase(ref.watch(attendanceRepositoryProvider)),
);

final fetchStaffDailyAttendanceUseCaseProvider = Provider<FetchStaffDailyAttendanceUseCase>(
  (ref) => FetchStaffDailyAttendanceUseCase(ref.watch(attendanceRepositoryProvider)),
);

final fetchStaffMonthlyAttendanceUseCaseProvider = Provider<FetchStaffMonthlyAttendanceUseCase>(
  (ref) => FetchStaffMonthlyAttendanceUseCase(ref.watch(attendanceRepositoryProvider)),
);

final markStaffCheckInUseCaseProvider = Provider<MarkStaffCheckInUseCase>(
  (ref) => MarkStaffCheckInUseCase(ref.watch(attendanceRepositoryProvider)),
);

final markStaffCheckOutUseCaseProvider = Provider<MarkStaffCheckOutUseCase>(
  (ref) => MarkStaffCheckOutUseCase(ref.watch(attendanceRepositoryProvider)),
);

final generateAttendanceReportUseCaseProvider = Provider<GenerateAttendanceReportUseCase>(
  (ref) => GenerateAttendanceReportUseCase(ref.watch(attendanceRepositoryProvider)),
);

final fetchBiometricDevicesUseCaseProvider = Provider<FetchBiometricDevicesUseCase>(
  (ref) => FetchBiometricDevicesUseCase(ref.watch(attendanceRepositoryProvider)),
);

final syncBiometricDeviceUseCaseProvider = Provider<SyncBiometricDeviceUseCase>(
  (ref) => SyncBiometricDeviceUseCase(ref.watch(attendanceRepositoryProvider)),
);

final recordFaceRecognitionUseCaseProvider = Provider<RecordFaceRecognitionUseCase>(
  (ref) => RecordFaceRecognitionUseCase(ref.watch(attendanceRepositoryProvider)),
);

final fetchFaceRecognitionRecordsUseCaseProvider = Provider<FetchFaceRecognitionRecordsUseCase>(
  (ref) => FetchFaceRecognitionRecordsUseCase(ref.watch(attendanceRepositoryProvider)),
);

final initializeFaceRecognitionUseCaseProvider = Provider<InitializeFaceRecognitionUseCase>(
  (ref) => InitializeFaceRecognitionUseCase(ref.watch(attendanceRepositoryProvider)),
);

final detectFaceUseCaseProvider = Provider<DetectFaceUseCase>(
  (ref) => DetectFaceUseCase(ref.watch(attendanceRepositoryProvider)),
);

final attendanceViewModelProvider = StateNotifierProvider<AttendanceViewModel, AttendanceState>(
  (ref) => AttendanceViewModel(
    ref.watch(fetchStudentDailyAttendanceUseCaseProvider),
    ref.watch(fetchStudentMonthlyAttendanceUseCaseProvider),
    ref.watch(markStudentAttendanceUseCaseProvider),
    ref.watch(fetchStaffDailyAttendanceUseCaseProvider),
    ref.watch(fetchStaffMonthlyAttendanceUseCaseProvider),
    ref.watch(markStaffCheckInUseCaseProvider),
    ref.watch(markStaffCheckOutUseCaseProvider),
    ref.watch(generateAttendanceReportUseCaseProvider),
    ref.watch(fetchBiometricDevicesUseCaseProvider),
    ref.watch(syncBiometricDeviceUseCaseProvider),
    ref.watch(recordFaceRecognitionUseCaseProvider),
    ref.watch(fetchFaceRecognitionRecordsUseCaseProvider),
    ref.watch(initializeFaceRecognitionUseCaseProvider),
    ref.watch(detectFaceUseCaseProvider),
  ),
);
