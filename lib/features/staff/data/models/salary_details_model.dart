import 'package:educare/features/staff/domain/entities/salary_details.dart';

class SalaryDetailsModel extends SalaryDetails {
  const SalaryDetailsModel({
    required super.id,
    required super.staffId,
    required super.basicSalary,
    required super.allowances,
    required super.deductions,
    required super.netSalary,
    required super.payPeriod,
  });

  factory SalaryDetailsModel.fromJson(Map<String, dynamic> json) {
    return SalaryDetailsModel(
      id: json['id'] as int,
      staffId: json['staff_id'] as int,
      basicSalary: (json['basic_salary'] as num).toDouble(),
      allowances: (json['allowances'] as num).toDouble(),
      deductions: (json['deductions'] as num).toDouble(),
      netSalary: (json['net_salary'] as num).toDouble(),
      payPeriod: json['pay_period'] as String,
    );
  }
}
