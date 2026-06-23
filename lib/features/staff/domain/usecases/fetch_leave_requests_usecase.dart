import 'package:educare/features/staff/domain/entities/leave_request.dart';
import 'package:educare/features/staff/domain/repositories/staff_repository.dart';

class FetchLeaveRequestsUseCase {
  final StaffRepository _repository;

  FetchLeaveRequestsUseCase(this._repository);

  Future<List<LeaveRequest>> execute(int staffId) {
    return _repository.fetchLeaveRequests(staffId);
  }
}
