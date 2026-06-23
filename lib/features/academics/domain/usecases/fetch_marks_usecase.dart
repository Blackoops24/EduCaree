import 'package:educare/features/academics/domain/entities/marks.dart';
import 'package:educare/features/academics/domain/repositories/academic_repository.dart';

class FetchMarksUseCase {
  final AcademicRepository _repository;

  FetchMarksUseCase(this._repository);

  Future<List<Marks>> execute(int examId, int sectionId) {
    return _repository.fetchMarks(examId, sectionId);
  }
}
