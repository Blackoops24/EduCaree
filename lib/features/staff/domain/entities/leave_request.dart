class LeaveRequest {
  final int id;
  final int staffId;
  final String startDate;
  final String endDate;
  final String reason;
  final String status;

  const LeaveRequest({
    required this.id,
    required this.staffId,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
  });
}
