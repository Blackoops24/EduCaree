import 'package:educare/features/attendance/domain/entities/face_recognition_record.dart';
import 'package:educare/features/attendance/domain/repositories/attendance_repository.dart';

class RecordFaceRecognitionUseCase {
  final AttendanceRepository _repository;

  RecordFaceRecognitionUseCase(this._repository);

  Future<FaceRecognitionRecord> execute(int userId, String userType, double confidenceScore) {
    return _repository.recordFaceRecognition(userId, userType, confidenceScore);
  }
}
