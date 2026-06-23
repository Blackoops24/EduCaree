import 'package:educare/features/students/domain/entities/student_document.dart';
import 'package:educare/features/students/domain/repositories/student_repository.dart';

class FetchDocumentsUseCase {
  final StudentRepository _repository;

  FetchDocumentsUseCase(this._repository);

  Future<List<StudentDocument>> execute(int studentId) {
    return _repository.fetchDocuments(studentId);
  }
}
