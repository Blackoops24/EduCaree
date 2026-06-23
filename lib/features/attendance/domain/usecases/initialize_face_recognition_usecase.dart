import 'package:educare/features/attendance/domain/repositories/attendance_repository.dart';

class InitializeFaceRecognitionUseCase {
  final AttendanceRepository _repository;

  InitializeFaceRecognitionUseCase(this._repository);

  Future<bool> execute() {
    return _repository.initializeFaceRecognitionCamera();
  }
}
