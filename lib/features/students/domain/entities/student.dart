class Student {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String admissionNumber;
  final String grade;
  final String section;
  final bool active;

  const Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.admissionNumber,
    required this.grade,
    required this.section,
    required this.active,
  });

  String get fullName => '$firstName $lastName';
}
