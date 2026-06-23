import 'package:educare/features/attendance/data/models/attendance_report_model.dart';
import 'package:educare/features/attendance/data/models/biometric_device_model.dart';
import 'package:educare/features/attendance/data/models/face_recognition_record_model.dart';
import 'package:educare/features/attendance/data/models/staff_attendance_model.dart';
import 'package:educare/features/attendance/data/models/student_attendance_model.dart';
import 'package:educare/features/attendance/data/services/attendance_service.dart';

class AttendanceRemoteDatasource {
  final AttendanceService _service;

  AttendanceRemoteDatasource(this._service);

  // Student Attendance Operations
  Future<List<StudentAttendanceModel>> fetchStudentDailyAttendance(int classId, DateTime date) async {
    final response = await _service.get(
      '/attendance/students/daily',
      queryParameters: {'class_id': classId, 'date': date.toIso8601String()},
    );
    return (response as List).map((e) => StudentAttendanceModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<StudentAttendanceModel>> fetchStudentMonthlyAttendance(int studentId, int month, int year) async {
    final response = await _service.get(
      '/attendance/students/$studentId/monthly',
      queryParameters: {'month': month, 'year': year},
    );
    return (response as List).map((e) => StudentAttendanceModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<bool> markStudentAttendance(StudentAttendanceModel attendance) async {
    await _service.post('/attendance/students/mark', data: attendance.toJson());
    return true;
  }

  // Staff Attendance Operations
  Future<List<StaffAttendanceModel>> fetchStaffDailyAttendance(DateTime date) async {
    final response = await _service.get(
      '/attendance/staff/daily',
      queryParameters: {'date': date.toIso8601String()},
    );
    return (response as List).map((e) => StaffAttendanceModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<StaffAttendanceModel>> fetchStaffMonthlyAttendance(int staffId, int month, int year) async {
    final response = await _service.get(
      '/attendance/staff/$staffId/monthly',
      queryParameters: {'month': month, 'year': year},
    );
    return (response as List).map((e) => StaffAttendanceModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<bool> markStaffCheckIn(int staffId) async {
    await _service.post('/attendance/staff/check-in', data: {'staff_id': staffId});
    return true;
  }

  Future<bool> markStaffCheckOut(int staffId) async {
    await _service.post('/attendance/staff/check-out', data: {'staff_id': staffId});
    return true;
  }

  // Attendance Reports
  Future<AttendanceReportModel> generateStudentAttendanceReport(int studentId, DateTime fromDate, DateTime toDate) async {
    final response = await _service.post(
      '/attendance/reports/student',
      data: {'student_id': studentId, 'from_date': fromDate.toIso8601String(), 'to_date': toDate.toIso8601String()},
    );
    return AttendanceReportModel.fromJson(response as Map<String, dynamic>);
  }

  Future<AttendanceReportModel> generateStaffAttendanceReport(int staffId, DateTime fromDate, DateTime toDate) async {
    final response = await _service.post(
      '/attendance/reports/staff',
      data: {'staff_id': staffId, 'from_date': fromDate.toIso8601String(), 'to_date': toDate.toIso8601String()},
    );
    return AttendanceReportModel.fromJson(response as Map<String, dynamic>);
  }

  // Biometric Device Operations
  Future<List<BiometricDeviceModel>> fetchBiometricDevices() async {
    final response = await _service.get('/attendance/biometric/devices');
    return (response as List).map((e) => BiometricDeviceModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<bool> syncBiometricDevice(int deviceId) async {
    await _service.post('/attendance/biometric/sync', data: {'device_id': deviceId});
    return true;
  }

  Future<List<StudentAttendanceModel>> fetchBiometricAttendance(int deviceId, DateTime date) async {
    final response = await _service.get(
      '/attendance/biometric/records',
      queryParameters: {'device_id': deviceId, 'date': date.toIso8601String()},
    );
    return (response as List).map((e) => StudentAttendanceModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  // Face Recognition Operations
  Future<FaceRecognitionRecordModel> recordFaceRecognition(int userId, String userType, double confidenceScore) async {
    final response = await _service.post(
      '/attendance/face-recognition/record',
      data: {'user_id': userId, 'user_type': userType, 'confidence_score': confidenceScore},
    );
    return FaceRecognitionRecordModel.fromJson(response as Map<String, dynamic>);
  }

  Future<List<FaceRecognitionRecordModel>> fetchFaceRecognitionRecords(DateTime date) async {
    final response = await _service.get(
      '/attendance/face-recognition/records',
      queryParameters: {'date': date.toIso8601String()},
    );
    return (response as List).map((e) => FaceRecognitionRecordModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<bool> initializeFaceRecognitionCamera() async {
    await _service.post('/attendance/face-recognition/initialize');
    return true;
  }

  Future<bool> detectFace(String imagePath) async {
    await _service.post('/attendance/face-recognition/detect', data: {'image_path': imagePath});
    return true;
  }
}
