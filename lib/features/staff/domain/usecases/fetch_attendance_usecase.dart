import 'package:educare/features/staff/domain/entities/attendance_record.dart';
import 'package:educare/features/staff/domain/repositories/staff_repository.dart';

class FetchAttendanceUseCase {
  final StaffRepository _repository;

  FetchAttendanceUseCase(this._repository);

  Future<List<AttendanceRecord>> execute(int staffId) {
    return _repository.fetchAttendance(staffId);
  }
}
