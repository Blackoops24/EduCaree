import 'package:educare/features/attendance/domain/entities/attendance_report.dart';

class AttendanceReportModel extends AttendanceReport {
  const AttendanceReportModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.userType,
    required super.fromDate,
    required super.toDate,
    required super.totalDays,
    required super.presentDays,
    required super.absentDays,
    required super.lateDays,
    required super.leaveDays,
    required super.attendancePercentage,
    required super.remarks,
    required super.generatedDate,
  });

  factory AttendanceReportModel.fromJson(Map<String, dynamic> json) {
    return AttendanceReportModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      userName: json['user_name'] as String,
      userType: json['user_type'] as String,
      fromDate: DateTime.parse(json['from_date'] as String),
      toDate: DateTime.parse(json['to_date'] as String),
      totalDays: json['total_days'] as int,
      presentDays: json['present_days'] as int,
      absentDays: json['absent_days'] as int,
      lateDays: json['late_days'] as int,
      leaveDays: json['leave_days'] as int,
      attendancePercentage: json['attendance_percentage'] as double,
      remarks: json['remarks'] as String,
      generatedDate: DateTime.parse(json['generated_date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'user_type': userType,
      'from_date': fromDate.toIso8601String(),
      'to_date': toDate.toIso8601String(),
      'total_days': totalDays,
      'present_days': presentDays,
      'absent_days': absentDays,
      'late_days': lateDays,
      'leave_days': leaveDays,
      'attendance_percentage': attendancePercentage,
      'remarks': remarks,
      'generated_date': generatedDate.toIso8601String(),
    };
  }
}
