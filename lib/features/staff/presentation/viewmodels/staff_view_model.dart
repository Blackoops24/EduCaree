import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educare/features/staff/domain/entities/attendance_record.dart';
import 'package:educare/features/staff/domain/entities/leave_request.dart';
import 'package:educare/features/staff/domain/entities/performance_review.dart';
import 'package:educare/features/staff/domain/entities/salary_details.dart';
import 'package:educare/features/staff/domain/entities/staff_member.dart';
import 'package:educare/features/staff/domain/usecases/fetch_attendance_usecase.dart';
import 'package:educare/features/staff/domain/usecases/fetch_leave_requests_usecase.dart';
import 'package:educare/features/staff/domain/usecases/fetch_performance_usecase.dart';
import 'package:educare/features/staff/domain/usecases/fetch_salary_details_usecase.dart';
import 'package:educare/features/staff/domain/usecases/fetch_staff_profile_usecase.dart';
import 'package:educare/features/staff/domain/usecases/fetch_staff_usecase.dart';
import 'package:educare/features/staff/domain/usecases/register_staff_usecase.dart';

class StaffState {
  final bool loading;
  final String? error;
  final List<StaffMember> staff;
  final StaffMember? selectedStaff;
  final bool registrationSuccess;
  final List<LeaveRequest> leaveRequests;
  final List<AttendanceRecord> attendance;
  final List<PerformanceReview> performance;
  final SalaryDetails? salaryDetails;

  const StaffState({
    this.loading = false,
    this.error,
    this.staff = const [],
    this.selectedStaff,
    this.registrationSuccess = false,
    this.leaveRequests = const [],
    this.attendance = const [],
    this.performance = const [],
    this.salaryDetails,
  });

  StaffState copyWith({
    bool? loading,
    String? error,
    List<StaffMember>? staff,
    StaffMember? selectedStaff,
    bool? registrationSuccess,
    List<LeaveRequest>? leaveRequests,
    List<AttendanceRecord>? attendance,
    List<PerformanceReview>? performance,
    SalaryDetails? salaryDetails,
  }) {
    return StaffState(
      loading: loading ?? this.loading,
      error: error,
      staff: staff ?? this.staff,
      selectedStaff: selectedStaff ?? this.selectedStaff,
      registrationSuccess: registrationSuccess ?? this.registrationSuccess,
      leaveRequests: leaveRequests ?? this.leaveRequests,
      attendance: attendance ?? this.attendance,
      performance: performance ?? this.performance,
      salaryDetails: salaryDetails ?? this.salaryDetails,
    );
  }
}

class StaffViewModel extends StateNotifier<StaffState> {
  final FetchStaffUseCase _fetchStaff;
  final FetchStaffProfileUseCase _fetchStaffProfile;
  final RegisterStaffUseCase _registerStaff;
  final FetchLeaveRequestsUseCase _fetchLeaveRequests;
  final FetchAttendanceUseCase _fetchAttendance;
  final FetchPerformanceUseCase _fetchPerformance;
  final FetchSalaryDetailsUseCase _fetchSalaryDetails;

  StaffViewModel(
    this._fetchStaff,
    this._fetchStaffProfile,
    this._registerStaff,
    this._fetchLeaveRequests,
    this._fetchAttendance,
    this._fetchPerformance,
    this._fetchSalaryDetails,
  ) : super(const StaffState());

  Future<void> loadStaff() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final staff = await _fetchStaff.execute();
      state = state.copyWith(staff: staff, loading: false);
    } catch (_) {
      state = state.copyWith(loading: false, error: 'Unable to load staff members.');
    }
  }

  Future<void> loadStaffProfile(int staffId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final staff = await _fetchStaffProfile.execute(staffId);
      state = state.copyWith(selectedStaff: staff, loading: false);
    } catch (_) {
      state = state.copyWith(loading: false, error: 'Unable to load staff profile.');
    }
  }

  Future<void> registerStaff(StaffMember staff) async {
    state = state.copyWith(loading: true, error: null, registrationSuccess: false);
    try {
      final success = await _registerStaff.execute(staff);
      state = state.copyWith(registrationSuccess: success, loading: false);
    } catch (_) {
      state = state.copyWith(loading: false, error: 'Staff registration failed.');
    }
  }

  Future<void> loadLeaveRequests(int staffId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final leaves = await _fetchLeaveRequests.execute(staffId);
      state = state.copyWith(leaveRequests: leaves, loading: false);
    } catch (_) {
      state = state.copyWith(loading: false, error: 'Unable to load leave requests.');
    }
  }

  Future<void> loadAttendance(int staffId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final attendance = await _fetchAttendance.execute(staffId);
      state = state.copyWith(attendance: attendance, loading: false);
    } catch (_) {
      state = state.copyWith(loading: false, error: 'Unable to load attendance.');
    }
  }

  Future<void> loadPerformance(int staffId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final performance = await _fetchPerformance.execute(staffId);
      state = state.copyWith(performance: performance, loading: false);
    } catch (_) {
      state = state.copyWith(loading: false, error: 'Unable to load performance details.');
    }
  }

  Future<void> loadSalaryDetails(int staffId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final salaryDetails = await _fetchSalaryDetails.execute(staffId);
      state = state.copyWith(salaryDetails: salaryDetails, loading: false);
    } catch (_) {
      state = state.copyWith(loading: false, error: 'Unable to load salary details.');
    }
  }
}
