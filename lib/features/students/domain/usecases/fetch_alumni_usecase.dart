import 'package:educare/features/students/domain/entities/alumni_record.dart';
import 'package:educare/features/students/domain/repositories/student_repository.dart';

class FetchAlumniUseCase {
  final StudentRepository _repository;

  FetchAlumniUseCase(this._repository);

  Future<List<AlumniRecord>> execute() {
    return _repository.fetchAlumni();
  }
}
