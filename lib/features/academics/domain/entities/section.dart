class Section {
  final int id;
  final int classId;
  final String sectionName;
  final int strength;
  final int? classTeacherId;
  final String? classTeacherName;

  const Section({
    required this.id,
    required this.classId,
    required this.sectionName,
    required this.strength,
    this.classTeacherId,
    this.classTeacherName,
  });
}
