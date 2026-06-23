import 'package:educare/features/staff/data/datasources/staff_remote_datasource.dart';
import 'package:educare/features/staff/data/models/staff_member_model.dart';
import 'package:educare/features/staff/domain/entities/attendance_record.dart';
import 'package:educare/features/staff/domain/entities/leave_request.dart';
import 'package:educare/features/staff/domain/entities/performance_review.dart';
import 'package:educare/features/staff/domain/entities/salary_details.dart';
import 'package:educare/features/staff/domain/entities/staff_member.dart';
import 'package:educare/features/staff/domain/repositories/staff_repository.dart';

class StaffRepositoryImpl implements StaffRepository {
  final StaffRemoteDatasource _datasource;

  StaffRepositoryImpl(this._datasource);

  @override
  Future<List<StaffMember>> fetchStaff() {
    return _datasource.fetchStaff();
  }

  @override
  Future<StaffMember> fetchStaffProfile(int staffId) {
    return _datasource.fetchStaffProfile(staffId);
  }

  @override
  Future<bool> registerStaff(StaffMember staff) {
    final staffModel = StaffMemberModel(
      id: staff.id,
      employeeId: staff.employeeId,
      name: staff.name,
      designation: staff.designation,
      department: staff.department,
      qualification: staff.qualification,
      joiningDate: staff.joiningDate,
      salary: staff.salary,
    );
    return _datasource.registerStaff(staffModel);
  }

  @override
  Future<List<LeaveRequest>> fetchLeaveRequests(int staffId) {
    return _datasource.fetchLeaveRequests(staffId);
  }

  @override
  Future<List<AttendanceRecord>> fetchAttendance(int staffId) {
    return _datasource.fetchAttendance(staffId);
  }

  @override
  Future<List<PerformanceReview>> fetchPerformance(int staffId) {
    return _datasource.fetchPerformance(staffId);
  }

  @override
  Future<SalaryDetails> fetchSalaryDetails(int staffId) {
    return _datasource.fetchSalaryDetails(staffId);
  }
}
