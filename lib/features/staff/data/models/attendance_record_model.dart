import 'package:educare/features/staff/domain/entities/attendance_record.dart';

class AttendanceRecordModel extends AttendanceRecord {
  const AttendanceRecordModel({
    required super.id,
    required super.staffId,
    required super.date,
    required super.status,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      id: json['id'] as int,
      staffId: json['staff_id'] as int,
      date: json['date'] as String,
      status: json['status'] as String,
    );
  }
}
