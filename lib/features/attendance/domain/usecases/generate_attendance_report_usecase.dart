import 'package:educare/features/attendance/domain/entities/attendance_report.dart';
import 'package:educare/features/attendance/domain/repositories/attendance_repository.dart';

class GenerateAttendanceReportUseCase {
  final AttendanceRepository _repository;

  GenerateAttendanceReportUseCase(this._repository);

  Future<AttendanceReport> executeForStudent(int studentId, DateTime fromDate, DateTime toDate) {
    return _repository.generateStudentAttendanceReport(studentId, fromDate, toDate);
  }

  Future<AttendanceReport> executeForStaff(int staffId, DateTime fromDate, DateTime toDate) {
    return _repository.generateStaffAttendanceReport(staffId, fromDate, toDate);
  }
}
