import 'package:educare/features/staff/domain/entities/attendance_record.dart';
import 'package:educare/features/staff/domain/entities/leave_request.dart';
import 'package:educare/features/staff/domain/entities/performance_review.dart';
import 'package:educare/features/staff/domain/entities/salary_details.dart';
import 'package:educare/features/staff/domain/entities/staff_member.dart';

abstract class StaffRepository {
  Future<List<StaffMember>> fetchStaff();
  Future<StaffMember> fetchStaffProfile(int staffId);
  Future<bool> registerStaff(StaffMember staff);
  Future<List<LeaveRequest>> fetchLeaveRequests(int staffId);
  Future<List<AttendanceRecord>> fetchAttendance(int staffId);
  Future<List<PerformanceReview>> fetchPerformance(int staffId);
  Future<SalaryDetails> fetchSalaryDetails(int staffId);
}
