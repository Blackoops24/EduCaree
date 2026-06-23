class Subject {
  final int id;
  final String code;
  final String name;
  final String description;
  final int credits;
  final int? classId;

  const Subject({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.credits,
    this.classId,
  });
}
