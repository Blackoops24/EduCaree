class FaceRecognitionRecord {
  final int id;
  final int userId; // Student or Staff ID
  final String userType; // Student or Staff
  final String userName;
  final DateTime recordedTime;
  final String status; // Recognized, NotRecognized, MultipleMatches
  final double? confidenceScore; // 0-1 scale
  final String? imagePath; // Local path to captured image
  final String? remarks;
  final DateTime? createdAt;

  const FaceRecognitionRecord({
    required this.id,
    required this.userId,
    required this.userType,
    required this.userName,
    required this.recordedTime,
    required this.status,
    this.confidenceScore,
    this.imagePath,
    this.remarks,
    this.createdAt,
  });
}
