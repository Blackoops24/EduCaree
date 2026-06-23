import 'package:educare/features/attendance/domain/entities/student_attendance.dart';
import 'package:educare/features/attendance/domain/repositories/attendance_repository.dart';

class FetchStudentMonthlyAttendanceUseCase {
  final AttendanceRepository _repository;

  FetchStudentMonthlyAttendanceUseCase(this._repository);

  Future<List<StudentAttendance>> execute(int studentId, int month, int year) {
    return _repository.fetchStudentMonthlyAttendance(studentId, month, year);
  }
}
