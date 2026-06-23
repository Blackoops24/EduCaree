import 'package:educare/features/academics/domain/entities/class.dart';
import 'package:educare/features/academics/domain/repositories/academic_repository.dart';

class FetchClassesUseCase {
  final AcademicRepository _repository;

  FetchClassesUseCase(this._repository);

  Future<List<Class>> execute() {
    return _repository.fetchClasses();
  }
}
