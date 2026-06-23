class ReportCard {
  final int id;
  final int studentId;
  final String studentName;
  final String rollNumber;
  final int classId;
  final String className;
  final String academicYear;
  final double gpa;
  final double cgpa;
  final String overallGrade;
  final String remarks;
  final String generatedDate;
  final List<String> subjectMarks;

  const ReportCard({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.rollNumber,
    required this.classId,
    required this.className,
    required this.academicYear,
    required this.gpa,
    required this.cgpa,
    required this.overallGrade,
    required this.remarks,
    required this.generatedDate,
    required this.subjectMarks,
  });
}
