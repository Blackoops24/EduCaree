import 'package:educare/features/staff/domain/entities/salary_details.dart';
import 'package:educare/features/staff/domain/repositories/staff_repository.dart';

class FetchSalaryDetailsUseCase {
  final StaffRepository _repository;

  FetchSalaryDetailsUseCase(this._repository);

  Future<SalaryDetails> execute(int staffId) {
    return _repository.fetchSalaryDetails(staffId);
  }
}
