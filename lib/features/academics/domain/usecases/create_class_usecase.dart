import 'package:educare/features/academics/domain/entities/class.dart';
import 'package:educare/features/academics/domain/repositories/academic_repository.dart';

class CreateClassUseCase {
  final AcademicRepository _repository;

  CreateClassUseCase(this._repository);

  Future<bool> execute(Class classData) {
    return _repository.createClass(classData);
  }
}
