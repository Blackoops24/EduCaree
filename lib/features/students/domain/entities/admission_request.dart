class AdmissionRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String dateOfBirth;
  final String grade;
  final String section;
  final String guardianName;
  final String guardianPhone;

  const AdmissionRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dateOfBirth,
    required this.grade,
    required this.section,
    required this.guardianName,
    required this.guardianPhone,
  });
}
