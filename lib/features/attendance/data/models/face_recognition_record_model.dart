import 'package:educare/features/attendance/domain/entities/face_recognition_record.dart';

class FaceRecognitionRecordModel extends FaceRecognitionRecord {
  const FaceRecognitionRecordModel({
    required super.id,
    required super.userId,
    required super.userType,
    required super.userName,
    required super.recordedTime,
    required super.status,
    super.confidenceScore,
    super.imagePath,
    super.remarks,
    super.createdAt,
  });

  factory FaceRecognitionRecordModel.fromJson(Map<String, dynamic> json) {
    return FaceRecognitionRecordModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      userType: json['user_type'] as String,
      userName: json['user_name'] as String,
      recordedTime: DateTime.parse(json['recorded_time'] as String),
      status: json['status'] as String,
      confidenceScore: json['confidence_score'] as double?,
      imagePath: json['image_path'] as String?,
      remarks: json['remarks'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_type': userType,
      'user_name': userName,
      'recorded_time': recordedTime.toIso8601String(),
      'status': status,
      'confidence_score': confidenceScore,
      'image_path': imagePath,
      'remarks': remarks,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
