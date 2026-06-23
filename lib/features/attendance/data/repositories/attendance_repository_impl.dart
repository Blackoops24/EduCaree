import 'package:educare/features/attendance/data/datasources/attendance_remote_datasource.dart';
import 'package:educare/features/attendance/data/models/student_attendance_model.dart';
import 'package:educare/features/attendance/domain/entities/attendance_report.dart';
import 'package:educare/features/attendance/domain/entities/biometric_device.dart';
import 'package:educare/features/attendance/domain/entities/face_recognition_record.dart';
import 'package:educare/features/attendance/domain/entities/staff_attendance.dart';
import 'package:educare/features/attendance/domain/entities/student_attendance.dart';
import 'package:educare/features/attendance/domain/repositories/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDatasource _datasource;

  AttendanceRepositoryImpl(this._datasource);

  @override
  Future<List<StudentAttendance>> fetchStudentDailyAttendance(int classId, DateTime date) async {
    final models = await _datasource.fetchStudentDailyAttendance(classId, date);
    return models.cast<StudentAttendance>();
  }

  @override
  Future<List<StudentAttendance>> fetchStudentMonthlyAttendance(int studentId, int month, int year) async {
    final models = await _datasource.fetchStudentMonthlyAttendance(studentId, month, year);
    return models.cast<StudentAttendance>();
  }

  @override
  Future<bool> markStudentAttendance(StudentAttendance attendance) async {
    final model = StudentAttendanceModel(
      id: attendance.id,
      studentId: attendance.studentId,
      studentName: attendance.studentName,
      rollNumber: attendance.rollNumber,
      attendanceDate: attendance.attendanceDate,
      status: attendance.status,
      remarks: attendance.remarks,
      checkInTime: attendance.checkInTime,
      checkOutTime: attendance.checkOutTime,
      markedBy: attendance.markedBy,
    );
    return _datasource.markStudentAttendance(model);
  }

  @override
  Future<List<StaffAttendance>> fetchStaffDailyAttendance(DateTime date) async {
    final models = await _datasource.fetchStaffDailyAttendance(date);
    return models.cast<StaffAttendance>();
  }

  @override
  Future<List<StaffAttendance>> fetchStaffMonthlyAttendance(int staffId, int month, int year) async {
    final models = await _datasource.fetchStaffMonthlyAttendance(staffId, month, year);
    return models.cast<StaffAttendance>();
  }

  @override
  Future<bool> markStaffCheckIn(int staffId) => _datasource.markStaffCheckIn(staffId);

  @override
  Future<bool> markStaffCheckOut(int staffId) => _datasource.markStaffCheckOut(staffId);

  @override
  Future<AttendanceReport> generateStudentAttendanceReport(int studentId, DateTime fromDate, DateTime toDate) {
    return _datasource.generateStudentAttendanceReport(studentId, fromDate, toDate);
  }

  @override
  Future<AttendanceReport> generateStaffAttendanceReport(int staffId, DateTime fromDate, DateTime toDate) {
    return _datasource.generateStaffAttendanceReport(staffId, fromDate, toDate);
  }

  @override
  Future<List<BiometricDevice>> fetchBiometricDevices() async {
    final models = await _datasource.fetchBiometricDevices();
    return models.cast<BiometricDevice>();
  }

  @override
  Future<bool> syncBiometricDevice(int deviceId) => _datasource.syncBiometricDevice(deviceId);

  @override
  Future<List<StudentAttendance>> fetchBiometricAttendance(int deviceId, DateTime date) async {
    final models = await _datasource.fetchBiometricAttendance(deviceId, date);
    return models.cast<StudentAttendance>();
  }

  @override
  Future<FaceRecognitionRecord> recordFaceRecognition(int userId, String userType, double confidenceScore) {
    return _datasource.recordFaceRecognition(userId, userType, confidenceScore);
  }

  @override
  Future<List<FaceRecognitionRecord>> fetchFaceRecognitionRecords(DateTime date) async {
    final models = await _datasource.fetchFaceRecognitionRecords(date);
    return models.cast<FaceRecognitionRecord>();
  }

  @override
  Future<bool> initializeFaceRecognitionCamera() => _datasource.initializeFaceRecognitionCamera();

  @override
  Future<bool> detectFace(String imagePath) => _datasource.detectFace(imagePath);
}
