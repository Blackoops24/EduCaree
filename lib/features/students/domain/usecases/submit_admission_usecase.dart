import 'package:educare/features/students/domain/entities/admission_request.dart';
import 'package:educare/features/students/domain/repositories/student_repository.dart';

class SubmitAdmissionUseCase {
  final StudentRepository _repository;

  SubmitAdmissionUseCase(this._repository);

  Future<bool> execute(AdmissionRequest request) {
    return _repository.submitAdmission(request);
  }
}
