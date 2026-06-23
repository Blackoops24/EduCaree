import 'package:educare/features/attendance/domain/repositories/attendance_repository.dart';

class DetectFaceUseCase {
  final AttendanceRepository _repository;

  DetectFaceUseCase(this._repository);

  Future<bool> execute(String imagePath) {
    return _repository.detectFace(imagePath);
  }
}
