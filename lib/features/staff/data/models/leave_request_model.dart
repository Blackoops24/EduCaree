import 'package:educare/features/staff/domain/entities/leave_request.dart';

class LeaveRequestModel extends LeaveRequest {
  const LeaveRequestModel({
    required super.id,
    required super.staffId,
    required super.startDate,
    required super.endDate,
    required super.reason,
    required super.status,
  });

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) {
    return LeaveRequestModel(
      id: json['id'] as int,
      staffId: json['staff_id'] as int,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      reason: json['reason'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'staff_id': staffId,
      'start_date': startDate,
      'end_date': endDate,
      'reason': reason,
      'status': status,
    };
  }
}
