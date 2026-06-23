class SalaryDetails {
  final int id;
  final int staffId;
  final double basicSalary;
  final double allowances;
  final double deductions;
  final double netSalary;
  final String payPeriod;

  const SalaryDetails({
    required this.id,
    required this.staffId,
    required this.basicSalary,
    required this.allowances,
    required this.deductions,
    required this.netSalary,
    required this.payPeriod,
  });
}
