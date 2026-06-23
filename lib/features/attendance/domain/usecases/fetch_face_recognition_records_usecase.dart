import 'package:educare/features/attendance/domain/entities/face_recognition_record.dart';
import 'package:educare/features/attendance/domain/repositories/attendance_repository.dart';

class FetchFaceRecognitionRecordsUseCase {
  final AttendanceRepository _repository;

  FetchFaceRecognitionRecordsUseCase(this._repository);

  Future<List<FaceRecognitionRecord>> execute(DateTime date) {
    return _repository.fetchFaceRecognitionRecords(date);
  }
}
