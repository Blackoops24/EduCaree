class HallTicket {
  final int id;
  final int studentId;
  final String studentName;
  final String rollNumber;
  final int examId;
  final String examName;
  final String seatNumber;
  final String venue;
  final String examDate;
  final String reportingTime;
  final String startTime;
  final String endTime;

  const HallTicket({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.rollNumber,
    required this.examId,
    required this.examName,
    required this.seatNumber,
    required this.venue,
    required this.examDate,
    required this.reportingTime,
    required this.startTime,
    required this.endTime,
  });
}
