import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educare/features/attendance/domain/entities/attendance_report.dart';
import 'package:educare/features/attendance/domain/entities/biometric_device.dart';
import 'package:educare/features/attendance/domain/entities/face_recognition_record.dart';
import 'package:educare/features/attendance/domain/entities/staff_attendance.dart';
import 'package:educare/features/attendance/domain/entities/student_attendance.dart';
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

class AttendanceState {
  final bool loading;
  final String? error;
  final List<StudentAttendance> studentAttendance;
  final List<StaffAttendance> staffAttendance;
  final List<BiometricDevice> biometricDevices;
  final List<FaceRecognitionRecord> faceRecords;
  final AttendanceReport? attendanceReport;
  final bool cameraInitialized;
  final double? lastConfidenceScore;

  const AttendanceState({
    this.loading = false,
    this.error,
    this.studentAttendance = const [],
    this.staffAttendance = const [],
    this.biometricDevices = const [],
    this.faceRecords = const [],
    this.attendanceReport,
    this.cameraInitialized = false,
    this.lastConfidenceScore,
  });

  AttendanceState copyWith({
    bool? loading,
    String? error,
    List<StudentAttendance>? studentAttendance,
    List<StaffAttendance>? staffAttendance,
    List<BiometricDevice>? biometricDevices,
    List<FaceRecognitionRecord>? faceRecords,
    AttendanceReport? attendanceReport,
    bool? cameraInitialized,
    double? lastConfidenceScore,
  }) {
    return AttendanceState(
      loading: loading ?? this.loading,
      error: error,
      studentAttendance: studentAttendance ?? this.studentAttendance,
      staffAttendance: staffAttendance ?? this.staffAttendance,
      biometricDevices: biometricDevices ?? this.biometricDevices,
      faceRecords: faceRecords ?? this.faceRecords,
      attendanceReport: attendanceReport ?? this.attendanceReport,
      cameraInitialized: cameraInitialized ?? this.cameraInitialized,
      lastConfidenceScore: lastConfidenceScore ?? this.lastConfidenceScore,
    );
  }
}

class AttendanceViewModel extends StateNotifier<AttendanceState> {
  final FetchStudentDailyAttendanceUseCase _fetchStudentDailyAttendanceUseCase;
  final FetchStudentMonthlyAttendanceUseCase _fetchStudentMonthlyAttendanceUseCase;
  final MarkStudentAttendanceUseCase _markStudentAttendanceUseCase;
  final FetchStaffDailyAttendanceUseCase _fetchStaffDailyAttendanceUseCase;
  final FetchStaffMonthlyAttendanceUseCase _fetchStaffMonthlyAttendanceUseCase;
  final MarkStaffCheckInUseCase _markStaffCheckInUseCase;
  final MarkStaffCheckOutUseCase _markStaffCheckOutUseCase;
  final GenerateAttendanceReportUseCase _generateAttendanceReportUseCase;
  final FetchBiometricDevicesUseCase _fetchBiometricDevicesUseCase;
  final SyncBiometricDeviceUseCase _syncBiometricDeviceUseCase;
  final RecordFaceRecognitionUseCase _recordFaceRecognitionUseCase;
  final FetchFaceRecognitionRecordsUseCase _fetchFaceRecognitionRecordsUseCase;
  final InitializeFaceRecognitionUseCase _initializeFaceRecognitionUseCase;
  final DetectFaceUseCase _detectFaceUseCase;

  AttendanceViewModel(
    this._fetchStudentDailyAttendanceUseCase,
    this._fetchStudentMonthlyAttendanceUseCase,
    this._markStudentAttendanceUseCase,
    this._fetchStaffDailyAttendanceUseCase,
    this._fetchStaffMonthlyAttendanceUseCase,
    this._markStaffCheckInUseCase,
    this._markStaffCheckOutUseCase,
    this._generateAttendanceReportUseCase,
    this._fetchBiometricDevicesUseCase,
    this._syncBiometricDeviceUseCase,
    this._recordFaceRecognitionUseCase,
    this._fetchFaceRecognitionRecordsUseCase,
    this._initializeFaceRecognitionUseCase,
    this._detectFaceUseCase,
  ) : super(const AttendanceState());

  Future<void> fetchStudentDailyAttendance(int classId, DateTime date) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final attendance = await _fetchStudentDailyAttendanceUseCase.execute(classId, date);
      state = state.copyWith(studentAttendance: attendance, loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Failed to fetch student attendance');
    }
  }

  Future<void> fetchStudentMonthlyAttendance(int studentId, int month, int year) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final attendance = await _fetchStudentMonthlyAttendanceUseCase.execute(studentId, month, year);
      state = state.copyWith(studentAttendance: attendance, loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Failed to fetch monthly attendance');
    }
  }

  Future<void> markStudentAttendance(StudentAttendance attendance) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _markStudentAttendanceUseCase.execute(attendance);
      state = state.copyWith(loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Failed to mark attendance');
    }
  }

  Future<void> fetchStaffDailyAttendance(DateTime date) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final attendance = await _fetchStaffDailyAttendanceUseCase.execute(date);
      state = state.copyWith(staffAttendance: attendance, loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Failed to fetch staff attendance');
    }
  }

  Future<void> fetchStaffMonthlyAttendance(int staffId, int month, int year) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final attendance = await _fetchStaffMonthlyAttendanceUseCase.execute(staffId, month, year);
      state = state.copyWith(staffAttendance: attendance, loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Failed to fetch monthly attendance');
    }
  }

  Future<void> markStaffCheckIn(int staffId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _markStaffCheckInUseCase.execute(staffId);
      state = state.copyWith(loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Failed to mark check-in');
    }
  }

  Future<void> markStaffCheckOut(int staffId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _markStaffCheckOutUseCase.execute(staffId);
      state = state.copyWith(loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Failed to mark check-out');
    }
  }

  Future<void> generateStudentAttendanceReport(int studentId, DateTime fromDate, DateTime toDate) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final report = await _generateAttendanceReportUseCase.executeForStudent(studentId, fromDate, toDate);
      state = state.copyWith(attendanceReport: report, loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Failed to generate report');
    }
  }

  Future<void> generateStaffAttendanceReport(int staffId, DateTime fromDate, DateTime toDate) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final report = await _generateAttendanceReportUseCase.executeForStaff(staffId, fromDate, toDate);
      state = state.copyWith(attendanceReport: report, loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Failed to generate report');
    }
  }

  Future<void> fetchBiometricDevices() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final devices = await _fetchBiometricDevicesUseCase.execute();
      state = state.copyWith(biometricDevices: devices, loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Failed to fetch devices');
    }
  }

  Future<void> syncBiometricDevice(int deviceId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _syncBiometricDeviceUseCase.execute(deviceId);
      state = state.copyWith(loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Failed to sync device');
    }
  }

  Future<void> recordFaceRecognition(int userId, String userType, double confidenceScore) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _recordFaceRecognitionUseCase.execute(userId, userType, confidenceScore);
      state = state.copyWith(lastConfidenceScore: confidenceScore, loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Failed to record face recognition');
    }
  }

  Future<void> fetchFaceRecognitionRecords(DateTime date) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final records = await _fetchFaceRecognitionRecordsUseCase.execute(date);
      state = state.copyWith(faceRecords: records, loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Failed to fetch records');
    }
  }

  Future<void> initializeFaceRecognition() async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _initializeFaceRecognitionUseCase.execute();
      state = state.copyWith(cameraInitialized: true, loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Failed to initialize camera');
    }
  }

  Future<void> detectFace(String imagePath) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _detectFaceUseCase.execute(imagePath);
      state = state.copyWith(loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Failed to detect face');
    }
  }
}
