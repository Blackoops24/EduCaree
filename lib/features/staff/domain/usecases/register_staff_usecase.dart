import 'package:educare/features/staff/domain/entities/staff_member.dart';
import 'package:educare/features/staff/domain/repositories/staff_repository.dart';

class RegisterStaffUseCase {
  final StaffRepository _repository;

  RegisterStaffUseCase(this._repository);

  Future<bool> execute(StaffMember staff) {
    return _repository.registerStaff(staff);
  }
}
