class StaffAttendance {
  final int id;
  final int staffId;
  final String staffName;
  final String designation;
  final DateTime attendanceDate;
  final String status; // Present, Absent, Late, Leave, HalfDay
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? remarks;
  final double? workHours;
  final String? markedBy;

  const StaffAttendance({
    required this.id,
    required this.staffId,
    required this.staffName,
    required this.designation,
    required this.attendanceDate,
    required this.status,
    this.checkInTime,
    this.checkOutTime,
    this.remarks,
    this.workHours,
    this.markedBy,
  });
}
