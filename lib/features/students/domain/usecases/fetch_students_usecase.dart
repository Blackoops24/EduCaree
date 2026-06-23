import 'package:educare/features/students/domain/entities/student.dart';
import 'package:educare/features/students/domain/repositories/student_repository.dart';

class FetchStudentsUseCase {
  final StudentRepository _repository;

  FetchStudentsUseCase(this._repository);

  Future<List<Student>> execute() {
    return _repository.fetchStudents();
  }
}
