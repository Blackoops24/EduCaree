import 'package:educare/features/staff/data/models/attendance_record_model.dart';
import 'package:educare/features/staff/data/models/performance_review_model.dart';
import 'package:educare/features/staff/data/models/salary_details_model.dart';
import 'package:educare/features/staff/data/models/staff_member_model.dart';
import 'package:educare/features/staff/data/models/leave_request_model.dart';
import 'package:educare/features/staff/data/services/staff_service.dart';

class StaffRemoteDatasource {
  final StaffService _staffService;

  StaffRemoteDatasource(this._staffService);

  Future<List<StaffMemberModel>> fetchStaff() async {
    final response = await _staffService.get('/staff');
    final rawList = List<Map<String, dynamic>>.from(response.data as List<dynamic>);
    return rawList.map(StaffMemberModel.fromJson).toList();
  }

  Future<StaffMemberModel> fetchStaffProfile(int staffId) async {
    final response = await _staffService.get('/staff/$staffId');
    return StaffMemberModel.fromJson(Map<String, dynamic>.from(response.data as Map<String, dynamic>));
  }

  Future<bool> registerStaff(StaffMemberModel staff) async {
    final response = await _staffService.post('/staff', data: {
      'employee_id': staff.employeeId,
      'name': staff.name,
      'designation': staff.designation,
      'department': staff.department,
      'qualification': staff.qualification,
      'joining_date': staff.joiningDate,
      'salary': staff.salary,
    });
    return response.statusCode == 201 || response.statusCode == 200;
  }

  Future<List<LeaveRequestModel>> fetchLeaveRequests(int staffId) async {
    final response = await _staffService.get('/staff/$staffId/leaves');
    final rawList = List<Map<String, dynamic>>.from(response.data as List<dynamic>);
    return rawList.map(LeaveRequestModel.fromJson).toList();
  }

  Future<List<AttendanceRecordModel>> fetchAttendance(int staffId) async {
    final response = await _staffService.get('/staff/$staffId/attendance');
    final rawList = List<Map<String, dynamic>>.from(response.data as List<dynamic>);
    return rawList.map(AttendanceRecordModel.fromJson).toList();
  }

  Future<List<PerformanceReviewModel>> fetchPerformance(int staffId) async {
    final response = await _staffService.get('/staff/$staffId/performance');
    final rawList = List<Map<String, dynamic>>.from(response.data as List<dynamic>);
    return rawList.map(PerformanceReviewModel.fromJson).toList();
  }

  Future<SalaryDetailsModel> fetchSalaryDetails(int staffId) async {
    final response = await _staffService.get('/staff/$staffId/salary');
    return SalaryDetailsModel.fromJson(Map<String, dynamic>.from(response.data as Map<String, dynamic>));
  }
}
