class AttendanceRecord {
  final int id;
  final int staffId;
  final String date;
  final String status;

  const AttendanceRecord({
    required this.id,
    required this.staffId,
    required this.date,
    required this.status,
  });
}
