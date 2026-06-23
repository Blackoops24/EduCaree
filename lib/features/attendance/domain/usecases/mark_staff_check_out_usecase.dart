import 'package:educare/features/attendance/domain/repositories/attendance_repository.dart';

class MarkStaffCheckOutUseCase {
  final AttendanceRepository _repository;

  MarkStaffCheckOutUseCase(this._repository);

  Future<bool> execute(int staffId) {
    return _repository.markStaffCheckOut(staffId);
  }
}
