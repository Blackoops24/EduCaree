class Timetable {
  final int id;
  final int classId;
  final int sectionId;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final int subjectId;
  final String subjectName;
  final int? teacherId;
  final String? teacherName;
  final String? roomNumber;

  const Timetable({
    required this.id,
    required this.classId,
    required this.sectionId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.subjectId,
    required this.subjectName,
    this.teacherId,
    this.teacherName,
    this.roomNumber,
  });
}
