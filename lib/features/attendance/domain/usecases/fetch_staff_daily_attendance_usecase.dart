import 'package:educare/features/attendance/domain/entities/staff_attendance.dart';
import 'package:educare/features/attendance/domain/repositories/attendance_repository.dart';

class FetchStaffDailyAttendanceUseCase {
  final AttendanceRepository _repository;

  FetchStaffDailyAttendanceUseCase(this._repository);

  Future<List<StaffAttendance>> execute(DateTime date) {
    return _repository.fetchStaffDailyAttendance(date);
  }
}
