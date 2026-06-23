class StudentAttendance {
  final int id;
  final int studentId;
  final String studentName;
  final String rollNumber;
  final DateTime attendanceDate;
  final String status; // Present, Absent, Late, Leave
  final String? remarks;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? markedBy; // Teacher or biometric device

  const StudentAttendance({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.rollNumber,
    required this.attendanceDate,
    required this.status,
    this.remarks,
    this.checkInTime,
    this.checkOutTime,
    this.markedBy,
  });
}
