class TransferCertificate {
  final int studentId;
  final String studentName;
  final String fromSchool;
  final String toSchool;
  final String issuedDate;
  final String reason;

  const TransferCertificate({
    required this.studentId,
    required this.studentName,
    required this.fromSchool,
    required this.toSchool,
    required this.issuedDate,
    required this.reason,
  });
}
