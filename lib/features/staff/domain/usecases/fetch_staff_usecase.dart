import 'package:educare/features/staff/domain/entities/staff_member.dart';
import 'package:educare/features/staff/domain/repositories/staff_repository.dart';

class FetchStaffUseCase {
  final StaffRepository _repository;

  FetchStaffUseCase(this._repository);

  Future<List<StaffMember>> execute() {
    return _repository.fetchStaff();
  }
}
