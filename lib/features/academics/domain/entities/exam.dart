class Exam {
  final int id;
  final String examName;
  final String examType;
  final String startDate;
  final String endDate;
  final int totalMarks;
  final int passingMarks;

  const Exam({
    required this.id,
    required this.examName,
    required this.examType,
    required this.startDate,
    required this.endDate,
    required this.totalMarks,
    required this.passingMarks,
  });
}
