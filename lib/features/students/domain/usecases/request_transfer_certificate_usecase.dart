import 'package:educare/features/students/domain/entities/transfer_certificate.dart';
import 'package:educare/features/students/domain/repositories/student_repository.dart';

class RequestTransferCertificateUseCase {
  final StudentRepository _repository;

  RequestTransferCertificateUseCase(this._repository);

  Future<TransferCertificate> execute(int studentId, String toSchool, String reason) {
    return _repository.requestTransferCertificate(studentId, toSchool, reason);
  }
}
