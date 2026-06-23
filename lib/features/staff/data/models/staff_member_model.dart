import 'package:educare/features/staff/domain/entities/staff_member.dart';

class StaffMemberModel extends StaffMember {
  const StaffMemberModel({
    required super.id,
    required super.employeeId,
    required super.name,
    required super.designation,
    required super.department,
    required super.qualification,
    required super.joiningDate,
    required super.salary,
  });

  factory StaffMemberModel.fromJson(Map<String, dynamic> json) {
    return StaffMemberModel(
      id: json['id'] as int,
      employeeId: json['employee_id'] as String,
      name: json['name'] as String,
      designation: json['designation'] as String,
      department: json['department'] as String,
      qualification: json['qualification'] as String,
      joiningDate: json['joining_date'] as String,
      salary: (json['salary'] as num).toDouble(),
    );
  }
}
