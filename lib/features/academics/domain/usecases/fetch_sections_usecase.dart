import 'package:educare/features/academics/domain/entities/section.dart';
import 'package:educare/features/academics/domain/repositories/academic_repository.dart';

class FetchSectionsUseCase {
  final AcademicRepository _repository;

  FetchSectionsUseCase(this._repository);

  Future<List<Section>> execute(int classId) {
    return _repository.fetchSections(classId);
  }
}
