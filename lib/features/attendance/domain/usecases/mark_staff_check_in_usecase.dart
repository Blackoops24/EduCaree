import 'package:educare/features/attendance/domain/repositories/attendance_repository.dart';

class MarkStaffCheckInUseCase {
  final AttendanceRepository _repository;

  MarkStaffCheckInUseCase(this._repository);

  Future<bool> execute(int staffId) {
    return _repository.markStaffCheckIn(staffId);
  }
}
