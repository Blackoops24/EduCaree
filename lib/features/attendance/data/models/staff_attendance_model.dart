import 'package:educare/features/attendance/domain/entities/staff_attendance.dart';

class StaffAttendanceModel extends StaffAttendance {
  const StaffAttendanceModel({
    required super.id,
    required super.staffId,
    required super.staffName,
    required super.designation,
    required super.attendanceDate,
    required super.status,
    super.checkInTime,
    super.checkOutTime,
    super.remarks,
    super.workHours,
    super.markedBy,
  });

  factory StaffAttendanceModel.fromJson(Map<String, dynamic> json) {
    return StaffAttendanceModel(
      id: json['id'] as int,
      staffId: json['staff_id'] as int,
      staffName: json['staff_name'] as String,
      designation: json['designation'] as String,
      attendanceDate: DateTime.parse(json['attendance_date'] as String),
      status: json['status'] as String,
      checkInTime: json['check_in_time'] != null ? DateTime.parse(json['check_in_time'] as String) : null,
      checkOutTime: json['check_out_time'] != null ? DateTime.parse(json['check_out_time'] as String) : null,
      remarks: json['remarks'] as String?,
      workHours: json['work_hours'] as double?,
      markedBy: json['marked_by'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'staff_id': staffId,
      'staff_name': staffName,
      'designation': designation,
      'attendance_date': attendanceDate.toIso8601String(),
      'status': status,
      'check_in_time': checkInTime?.toIso8601String(),
      'check_out_time': checkOutTime?.toIso8601String(),
      'remarks': remarks,
      'work_hours': workHours,
      'marked_by': markedBy,
    };
  }
}
