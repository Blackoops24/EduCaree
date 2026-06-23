class Marks {
  final int id;
  final int studentId;
  final String studentName;
  final int examId;
  final int subjectId;
  final String subjectName;
  final double obtainedMarks;
  final int totalMarks;
  final double percentage;
  final String grade;

  const Marks({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.examId,
    required this.subjectId,
    required this.subjectName,
    required this.obtainedMarks,
    required this.totalMarks,
    required this.percentage,
    required this.grade,
  });
}
