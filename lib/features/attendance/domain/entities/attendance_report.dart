class AttendanceReport {
  final int id;
  final int userId;
  final String userName;
  final String userType; // Student or Staff
  final DateTime fromDate;
  final DateTime toDate;
  final int totalDays;
  final int presentDays;
  final int absentDays;
  final int lateDays;
  final int leaveDays;
  final double attendancePercentage;
  final String remarks;
  final DateTime generatedDate;

  const AttendanceReport({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userType,
    required this.fromDate,
    required this.toDate,
    required this.totalDays,
    required this.presentDays,
    required this.absentDays,
    required this.lateDays,
    required this.leaveDays,
    required this.attendancePercentage,
    required this.remarks,
    required this.generatedDate,
  });
}
