class ExamSchedule {
  final int id;
  final int examId;
  final int subjectId;
  final String subjectName;
  final String examDate;
  final String startTime;
  final String endTime;
  final int totalMarks;
  final String venue;

  const ExamSchedule({
    required this.id,
    required this.examId,
    required this.subjectId,
    required this.subjectName,
    required this.examDate,
    required this.startTime,
    required this.endTime,
    required this.totalMarks,
    required this.venue,
  });
}
