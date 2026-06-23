import 'package:educare/features/staff/domain/entities/staff_member.dart';
import 'package:educare/features/staff/domain/repositories/staff_repository.dart';

class FetchStaffProfileUseCase {
  final StaffRepository _repository;

  FetchStaffProfileUseCase(this._repository);

  Future<StaffMember> execute(int staffId) {
    return _repository.fetchStaffProfile(staffId);
  }
}
