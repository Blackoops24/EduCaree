import 'package:educare/features/students/domain/entities/student.dart';
import 'package:educare/features/students/domain/repositories/student_repository.dart';

class FetchStudentProfileUseCase {
  final StudentRepository _repository;

  FetchStudentProfileUseCase(this._repository);

  Future<Student> execute(int studentId) {
    return _repository.fetchStudentProfile(studentId);
  }
}
