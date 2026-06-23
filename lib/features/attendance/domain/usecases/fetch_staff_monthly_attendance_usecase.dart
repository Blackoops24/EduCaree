import 'package:educare/features/attendance/domain/entities/staff_attendance.dart';
import 'package:educare/features/attendance/domain/repositories/attendance_repository.dart';

class FetchStaffMonthlyAttendanceUseCase {
  final AttendanceRepository _repository;

  FetchStaffMonthlyAttendanceUseCase(this._repository);

  Future<List<StaffAttendance>> execute(int staffId, int month, int year) {
    return _repository.fetchStaffMonthlyAttendance(staffId, month, year);
  }
}
