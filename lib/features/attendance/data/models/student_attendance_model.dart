import 'package:educare/features/attendance/domain/entities/student_attendance.dart';

class StudentAttendanceModel extends StudentAttendance {
  const StudentAttendanceModel({
    required super.id,
    required super.studentId,
    required super.studentName,
    required super.rollNumber,
    required super.attendanceDate,
    required super.status,
    super.remarks,
    super.checkInTime,
    super.checkOutTime,
    super.markedBy,
  });

  factory StudentAttendanceModel.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceModel(
      id: json['id'] as int,
      studentId: json['student_id'] as int,
      studentName: json['student_name'] as String,
      rollNumber: json['roll_number'] as String,
      attendanceDate: DateTime.parse(json['attendance_date'] as String),
      status: json['status'] as String,
      remarks: json['remarks'] as String?,
      checkInTime: json['check_in_time'] != null ? DateTime.parse(json['check_in_time'] as String) : null,
      checkOutTime: json['check_out_time'] != null ? DateTime.parse(json['check_out_time'] as String) : null,
      markedBy: json['marked_by'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'student_name': studentName,
      'roll_number': rollNumber,
      'attendance_date': attendanceDate.toIso8601String(),
      'status': status,
      'remarks': remarks,
      'check_in_time': checkInTime?.toIso8601String(),
      'check_out_time': checkOutTime?.toIso8601String(),
      'marked_by': markedBy,
    };
  }
}
