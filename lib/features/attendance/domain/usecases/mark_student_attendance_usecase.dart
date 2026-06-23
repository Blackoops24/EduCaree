import 'package:educare/features/attendance/domain/entities/student_attendance.dart';
import 'package:educare/features/attendance/domain/repositories/attendance_repository.dart';

class MarkStudentAttendanceUseCase {
  final AttendanceRepository _repository;

  MarkStudentAttendanceUseCase(this._repository);

  Future<bool> execute(StudentAttendance attendance) {
    return _repository.markStudentAttendance(attendance);
  }
}
