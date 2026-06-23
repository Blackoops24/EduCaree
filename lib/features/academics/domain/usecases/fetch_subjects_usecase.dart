import 'package:educare/features/academics/domain/entities/subject.dart';
import 'package:educare/features/academics/domain/repositories/academic_repository.dart';

class FetchSubjectsUseCase {
  final AcademicRepository _repository;

  FetchSubjectsUseCase(this._repository);

  Future<List<Subject>> execute(int classId) {
    return _repository.fetchSubjects(classId);
  }
}
