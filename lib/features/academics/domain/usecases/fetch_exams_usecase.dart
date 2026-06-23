import 'package:educare/features/academics/domain/entities/exam.dart';
import 'package:educare/features/academics/domain/repositories/academic_repository.dart';

class FetchExamsUseCase {
  final AcademicRepository _repository;

  FetchExamsUseCase(this._repository);

  Future<List<Exam>> execute() {
    return _repository.fetchExams();
  }
}
