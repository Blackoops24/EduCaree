import 'package:educare/features/staff/domain/entities/performance_review.dart';
import 'package:educare/features/staff/domain/repositories/staff_repository.dart';

class FetchPerformanceUseCase {
  final StaffRepository _repository;

  FetchPerformanceUseCase(this._repository);

  Future<List<PerformanceReview>> execute(int staffId) {
    return _repository.fetchPerformance(staffId);
  }
}
