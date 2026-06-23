import 'package:educare/features/attendance/domain/entities/student_attendance.dart';
import 'package:educare/features/attendance/domain/repositories/attendance_repository.dart';

class FetchStudentDailyAttendanceUseCase {
  final AttendanceRepository _repository;

  FetchStudentDailyAttendanceUseCase(this._repository);

  Future<List<StudentAttendance>> execute(int classId, DateTime date) {
    return _repository.fetchStudentDailyAttendance(classId, date);
  }
}
