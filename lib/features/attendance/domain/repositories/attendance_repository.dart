import 'package:educare/features/attendance/domain/entities/attendance_report.dart';
import 'package:educare/features/attendance/domain/entities/biometric_device.dart';
import 'package:educare/features/attendance/domain/entities/face_recognition_record.dart';
import 'package:educare/features/attendance/domain/entities/staff_attendance.dart';
import 'package:educare/features/attendance/domain/entities/student_attendance.dart';

abstract class AttendanceRepository {
  // Student Attendance
  Future<List<StudentAttendance>> fetchStudentDailyAttendance(int classId, DateTime date);
  Future<List<StudentAttendance>> fetchStudentMonthlyAttendance(int studentId, int month, int year);
  Future<bool> markStudentAttendance(StudentAttendance attendance);

  // Staff Attendance
  Future<List<StaffAttendance>> fetchStaffDailyAttendance(DateTime date);
  Future<List<StaffAttendance>> fetchStaffMonthlyAttendance(int staffId, int month, int year);
  Future<bool> markStaffCheckIn(int staffId);
  Future<bool> markStaffCheckOut(int staffId);

  // Reports
  Future<AttendanceReport> generateStudentAttendanceReport(int studentId, DateTime fromDate, DateTime toDate);
  Future<AttendanceReport> generateStaffAttendanceReport(int staffId, DateTime fromDate, DateTime toDate);

  // Biometric Devices
  Future<List<BiometricDevice>> fetchBiometricDevices();
  Future<bool> syncBiometricDevice(int deviceId);
  Future<List<StudentAttendance>> fetchBiometricAttendance(int deviceId, DateTime date);

  // Face Recognition
  Future<FaceRecognitionRecord> recordFaceRecognition(int userId, String userType, double confidenceScore);
  Future<List<FaceRecognitionRecord>> fetchFaceRecognitionRecords(DateTime date);
  Future<bool> initializeFaceRecognitionCamera();
  Future<bool> detectFace(String imagePath);
}
