import 'package:educare/core/widgets/delete_confirmation_dialog.dart';
import 'package:educare/core/widgets/persistent_module_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class StaffManagementPage extends StatefulWidget {
  const StaffManagementPage({super.key});

  @override
  State<StaffManagementPage> createState() => _StaffManagementPageState();
}

class _StaffManagementPageState
    extends PersistentModuleState<StaffManagementPage> {
  static const _genders = ['Male', 'Female', 'Other'];
  static const _departments = [
    'Administration',
    'Academics',
    'Finance',
    'Human Resources',
    'IT',
    'Operations',
  ];
  static const _designations = [
    'Principal',
    'Vice Principal',
    'Teacher',
    'Accountant',
    'Administrator',
    'Librarian',
    'Counsellor',
    'Support Staff',
  ];
  static const _employmentTypes = ['Permanent', 'Contract', 'Part Time'];
  static const _statuses = ['Active', 'On Leave', 'Inactive'];

  final List<StaffRecord> _staff = [
    StaffRecord(
      id: 1,
      employeeId: 'EMP-001',
      name: 'Rajesh Kumar',
      gender: 'Male',
      email: 'rajesh@educaree.com',
      phone: '9876543210',
      designation: 'Principal',
      department: 'Administration',
      employmentType: 'Permanent',
      qualification: 'M.A., B.Ed',
      joiningDate: '2015-08-01',
      salary: '150000',
      status: 'Active',
    ),
    StaffRecord(
      id: 2,
      employeeId: 'EMP-002',
      name: 'Priya Singh',
      gender: 'Female',
      email: 'priya@educaree.com',
      phone: '9876543211',
      designation: 'Teacher',
      department: 'Academics',
      employmentType: 'Permanent',
      qualification: 'M.Sc, B.Ed',
      joiningDate: '2018-06-15',
      salary: '45000',
      status: 'Active',
    ),
  ];

  final List<LeaveRecord> _leaves = [];
  final List<AttendanceRecord> _staffAttendance = [];
  final List<PerformanceRecord> _performance = [];
  final List<SalaryRecord> _salaryRecords = [];
  final GlobalKey _registrationContentKey = GlobalKey();
  final GlobalKey _profileContentKey = GlobalKey();
  final GlobalKey _leaveContentKey = GlobalKey();
  final GlobalKey _attendanceContentKey = GlobalKey();
  final GlobalKey _performanceContentKey = GlobalKey();
  final GlobalKey _salaryContentKey = GlobalKey();
  final TextEditingController _registrationSearchController =
      TextEditingController();
  final TextEditingController _profileSearchController =
      TextEditingController();
  String _registrationSearchQuery = '';
  String _profileSearchQuery = '';

  @override
  String get moduleKey => 'staff';

  @override
  void initState() {
    super.initState();
    _ensureCurrentSalaryRecords();
  }

  @override
  Map<String, dynamic> exportState() => {
    'staff': _staff.map((item) => item.toJson()).toList(),
    'leaves': _leaves.map((item) => item.toJson()).toList(),
    'attendance': _staffAttendance.map((item) => item.toJson()).toList(),
    'performance': _performance.map((item) => item.toJson()).toList(),
    'salaries': _salaryRecords.map((item) => item.toJson()).toList(),
  };

  @override
  void importState(Map<String, dynamic> data) {
    _staff
      ..clear()
      ..addAll(
        (data['staff'] as List? ?? []).map(
          (item) =>
              StaffRecord.fromJson(Map<String, dynamic>.from(item as Map)),
        ),
      );
    _leaves
      ..clear()
      ..addAll(
        (data['leaves'] as List? ?? []).map(
          (item) =>
              LeaveRecord.fromJson(Map<String, dynamic>.from(item as Map)),
        ),
      );
    _staffAttendance
      ..clear()
      ..addAll(
        (data['attendance'] as List? ?? []).map(
          (item) =>
              AttendanceRecord.fromJson(Map<String, dynamic>.from(item as Map)),
        ),
      );
    _performance
      ..clear()
      ..addAll(
        (data['performance'] as List? ?? []).map(
          (item) => PerformanceRecord.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        ),
      );
    _salaryRecords
      ..clear()
      ..addAll(
        (data['salaries'] as List? ?? []).map(
          (item) =>
              SalaryRecord.fromJson(Map<String, dynamic>.from(item as Map)),
        ),
      );
    _ensureCurrentSalaryRecords();
  }

  @override
  void dispose() {
    _registrationSearchController.dispose();
    _profileSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Staff Management'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Registration'),
              Tab(text: 'Profile'),
              Tab(text: 'Leave'),
              Tab(text: 'Attendance'),
              Tab(text: 'Performance'),
              Tab(text: 'Salary'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRegistrationTab(context),
            _buildProfileTab(context),
            _buildLeaveTab(context),
            _buildAttendanceTab(context),
            _buildPerformanceTab(context),
            _buildSalaryTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    String subtitle, {
    VoidCallback? action,
    String? actionLabel,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final heading = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.black54)),
            ],
          );
          final button = action != null && actionLabel != null
              ? ElevatedButton.icon(
                  onPressed: action,
                  icon: const Icon(Icons.add),
                  label: Text(actionLabel),
                )
              : null;
          if (constraints.maxWidth < 650) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                heading,
                if (button != null) ...[const SizedBox(height: 12), button],
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: heading),
              if (button != null) button,
            ],
          );
        },
      ),
    );
  }

  Widget _buildStaffHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
    required TextEditingController controller,
    required ValueChanged<String> onSearch,
    VoidCallback? action,
    String? actionLabel,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final search = SizedBox(
            width: constraints.maxWidth > 700 ? 280 : double.infinity,
            child: TextField(
              controller: controller,
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: 'Search name, employee ID, department',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: controller.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear search',
                        onPressed: () {
                          controller.clear();
                          onSearch('');
                        },
                        icon: const Icon(Icons.clear),
                      ),
              ),
            ),
          );
          final heading = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.black54)),
            ],
          );
          final button = action != null && actionLabel != null
              ? ElevatedButton.icon(
                  onPressed: action,
                  icon: const Icon(Icons.add),
                  label: Text(actionLabel),
                )
              : null;
          if (constraints.maxWidth < 850) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                heading,
                const SizedBox(height: 12),
                search,
                if (button != null) ...[const SizedBox(height: 12), button],
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: heading),
              search,
              if (button != null) ...[const SizedBox(width: 12), button],
            ],
          );
        },
      ),
    );
  }

  List<StaffRecord> _filterStaff(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return List<StaffRecord>.from(_staff);
    return _staff.where((employee) {
      return employee.name.toLowerCase().contains(normalized) ||
          employee.employeeId.toLowerCase().contains(normalized) ||
          employee.department.toLowerCase().contains(normalized) ||
          employee.designation.toLowerCase().contains(normalized);
    }).toList();
  }

  Widget _buildRegistrationTab(BuildContext context) {
    final filteredStaff = _filterStaff(_registrationSearchQuery);
    return Column(
      key: _registrationContentKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStaffHeader(
          context,
          title: 'Employee Registration',
          subtitle: 'Register and manage employee records.',
          controller: _registrationSearchController,
          onSearch: (value) => setState(() => _registrationSearchQuery = value),
          action: () =>
              _showStaffDrawer(context, anchorKey: _registrationContentKey),
          actionLabel: 'New Employee',
        ),
        Expanded(
          child: filteredStaff.isEmpty
              ? const Center(child: Text('No employees registered.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredStaff.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final employee = filteredStaff[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          '${employee.name} (${employee.employeeId})',
                        ),
                        subtitle: Text(
                          '${employee.designation} • ${employee.department} • ${employee.status}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Edit employee',
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => _showStaffDrawer(
                                context,
                                staff: employee,
                                anchorKey: _registrationContentKey,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final confirmed =
                                    await showDeleteConfirmationDialog(
                                      context,
                                      title: 'Delete employee?',
                                      message:
                                          'This will remove ${employee.name} from staff records.',
                                    );
                                if (!confirmed) return;
                                setState(() {
                                  _staff.remove(employee);
                                  _leaves.removeWhere(
                                    (record) =>
                                        record.employeeName == employee.name,
                                  );
                                  _staffAttendance.removeWhere(
                                    (record) =>
                                        record.employeeName == employee.name,
                                  );
                                  _performance.removeWhere(
                                    (record) =>
                                        record.employeeName == employee.name,
                                  );
                                  _salaryRecords.removeWhere(
                                    (record) =>
                                        record.employeeName == employee.name,
                                  );
                                });
                                await persistNow();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildProfileTab(BuildContext context) {
    final filteredStaff = _filterStaff(_profileSearchQuery);
    return Column(
      key: _profileContentKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStaffHeader(
          context,
          title: 'Staff Profiles',
          subtitle: 'View and manage detailed staff information.',
          controller: _profileSearchController,
          onSearch: (value) => setState(() => _profileSearchQuery = value),
        ),
        Expanded(
          child: filteredStaff.isEmpty
              ? const Center(child: Text('No staff profiles available.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredStaff.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final employee = filteredStaff[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ExpansionTile(
                        title: Text(employee.name),
                        subtitle: Text(employee.employeeId),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildProfileField(
                                  'Designation',
                                  employee.designation,
                                ),
                                _buildProfileField(
                                  'Department',
                                  employee.department,
                                ),
                                _buildProfileField(
                                  'Employment',
                                  employee.employmentType,
                                ),
                                _buildProfileField('Gender', employee.gender),
                                _buildProfileField('Email', employee.email),
                                _buildProfileField('Phone', employee.phone),
                                _buildProfileField(
                                  'Qualification',
                                  employee.qualification,
                                ),
                                _buildProfileField(
                                  'Joining Date',
                                  employee.joiningDate,
                                ),
                                _buildProfileField(
                                  'Salary',
                                  '₹${employee.salary}',
                                ),
                                _buildProfileField('Status', employee.status),
                                const Divider(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: OutlinedButton.icon(
                                    onPressed: () => _showStaffDrawer(
                                      context,
                                      staff: employee,
                                      anchorKey: _profileContentKey,
                                    ),
                                    icon: const Icon(Icons.edit_outlined),
                                    label: const Text('Edit Profile'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildLeaveTab(BuildContext context) {
    return Column(
      key: _leaveContentKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Leave Management',
          'Manage employee leave records.',
          action: () => _withRegisteredStaff(
            context,
            () => _showLeaveDialog(context, anchorKey: _leaveContentKey),
          ),
          actionLabel: 'New Leave',
        ),
        Expanded(
          child: _leaves.isEmpty
              ? const Center(child: Text('No leave records.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _leaves.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final leave = _leaves[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(leave.employeeName),
                        subtitle: Text(
                          '${leave.leaveType} • ${leave.fromDate} to ${leave.toDate} • ${leave.status}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (leave.status == 'Pending')
                              IconButton(
                                tooltip: 'Approve leave',
                                icon: const Icon(Icons.check_circle_outline),
                                onPressed: () async {
                                  setState(() => leave.status = 'Approved');
                                  await persistNow();
                                },
                              ),
                            if (leave.status == 'Pending')
                              IconButton(
                                tooltip: 'Reject leave',
                                icon: const Icon(Icons.cancel_outlined),
                                onPressed: () async {
                                  setState(() => leave.status = 'Rejected');
                                  await persistNow();
                                },
                              ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showLeaveDialog(
                                context,
                                leave: leave,
                                anchorKey: _leaveContentKey,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final confirmed =
                                    await showDeleteConfirmationDialog(
                                      context,
                                      title: 'Delete leave record?',
                                      message:
                                          'This will remove the leave record for ${leave.employeeName}.',
                                    );
                                if (!confirmed) return;
                                setState(() => _leaves.removeAt(index));
                                await persistNow();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAttendanceTab(BuildContext context) {
    return Column(
      key: _attendanceContentKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Staff Attendance',
          'Mark and track staff attendance.',
          action: () => _withRegisteredStaff(
            context,
            () => _showAttendanceDialog(
              context,
              anchorKey: _attendanceContentKey,
            ),
          ),
          actionLabel: 'Mark Attendance',
        ),
        Expanded(
          child: _staffAttendance.isEmpty
              ? const Center(child: Text('No attendance records.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _staffAttendance.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final attendance = _staffAttendance[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(attendance.employeeName),
                        subtitle: Text(
                          '${attendance.date} • ${attendance.status}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showAttendanceDialog(
                                context,
                                attendance: attendance,
                                anchorKey: _attendanceContentKey,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final confirmed =
                                    await showDeleteConfirmationDialog(
                                      context,
                                      title: 'Delete attendance record?',
                                      message:
                                          'This will remove the attendance record for ${attendance.employeeName}.',
                                    );
                                if (!confirmed) return;
                                setState(
                                  () => _staffAttendance.removeAt(index),
                                );
                                await persistNow();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildPerformanceTab(BuildContext context) {
    return Column(
      key: _performanceContentKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Performance Tracking',
          'Manage employee performance records.',
          action: () => _withRegisteredStaff(
            context,
            () => _showPerformanceDialog(
              context,
              anchorKey: _performanceContentKey,
            ),
          ),
          actionLabel: 'New Review',
        ),
        Expanded(
          child: _performance.isEmpty
              ? const Center(child: Text('No performance records.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _performance.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final perf = _performance[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(perf.employeeName),
                        subtitle: Text(
                          'Rating: ${perf.rating}/10 • ${perf.reviewDate}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showPerformanceDialog(
                                context,
                                performance: perf,
                                anchorKey: _performanceContentKey,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final confirmed =
                                    await showDeleteConfirmationDialog(
                                      context,
                                      title: 'Delete performance record?',
                                      message:
                                          'This will remove the performance review for ${perf.employeeName}.',
                                    );
                                if (!confirmed) return;
                                setState(() => _performance.removeAt(index));
                                await persistNow();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSalaryTab(BuildContext context) {
    return Column(
      key: _salaryContentKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Salary Details',
          'View and manage salary information.',
          action: () => _withRegisteredStaff(
            context,
            () => _showSalaryDialog(context, anchorKey: _salaryContentKey),
          ),
          actionLabel: 'Add Salary',
        ),
        Expanded(
          child: _salaryRecords.isEmpty
              ? const Center(child: Text('No salary records.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _salaryRecords.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final salary = _salaryRecords[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(salary.employeeName),
                        subtitle: Text(
                          '₹${salary.baseSalary} • ${salary.month}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.download),
                              onPressed: () =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Salary slip for ${salary.employeeName} downloaded.',
                                      ),
                                    ),
                                  ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showSalaryDialog(
                                context,
                                salary: salary,
                                anchorKey: _salaryContentKey,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final confirmed =
                                    await showDeleteConfirmationDialog(
                                      context,
                                      title: 'Delete salary record?',
                                      message:
                                          'This will remove the ${salary.month} salary record for ${salary.employeeName}.',
                                    );
                                if (!confirmed) return;
                                setState(() => _salaryRecords.removeAt(index));
                                await persistNow();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _withRegisteredStaff(BuildContext context, VoidCallback action) {
    if (_staff.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Register an employee before adding this record.'),
        ),
      );
      return;
    }
    action();
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showStaffDrawer(
    BuildContext context, {
    StaffRecord? staff,
    GlobalKey? anchorKey,
  }) {
    final renderObject =
        anchorKey?.currentContext?.findRenderObject() ??
        context.findRenderObject();
    final contentRect = renderObject is RenderBox
        ? renderObject.localToGlobal(Offset.zero) & renderObject.size
        : Offset.zero & MediaQuery.sizeOf(context);
    final formKey = GlobalKey<FormState>();
    final employeeId = staff?.employeeId ?? _generateEmployeeId();
    final employeeIdController = TextEditingController(text: employeeId);
    final nameController = TextEditingController(text: staff?.name ?? '');
    final emailController = TextEditingController(text: staff?.email ?? '');
    final phoneController = TextEditingController(text: staff?.phone ?? '');
    final qualificationController = TextEditingController(
      text: staff?.qualification ?? '',
    );
    final joiningDateController = TextEditingController(
      text: staff?.joiningDate ?? '',
    );
    final salaryController = TextEditingController(text: staff?.salary ?? '');
    String? gender = _genders.contains(staff?.gender) ? staff!.gender : null;
    String? designation = _designations.contains(staff?.designation)
        ? staff!.designation
        : null;
    String? department = _departments.contains(staff?.department)
        ? staff!.department
        : null;
    String employmentType = _employmentTypes.contains(staff?.employmentType)
        ? staff!.employmentType
        : _employmentTypes.first;
    String status = _statuses.contains(staff?.status)
        ? staff!.status
        : _statuses.first;

    Future<void> submit(BuildContext drawerContext) async {
      final missingField = _firstMissingEmployeeField(
        name: nameController.text,
        gender: gender,
        email: emailController.text,
        phone: phoneController.text,
        designation: designation,
        department: department,
        qualification: qualificationController.text,
        joiningDate: joiningDateController.text,
        salary: salaryController.text,
      );
      if (missingField != null) {
        _showFlashMessage(
          drawerContext,
          'Missing required field: $missingField',
        );
        formKey.currentState?.validate();
        return;
      }
      if (!(formKey.currentState?.validate() ?? false)) return;
      final isNew = staff == null;
      final employeeName = nameController.text.trim();
      final monthlySalary = salaryController.text.trim();
      final salaryMonth = DateFormat('yyyy-MM').format(DateTime.now());
      setState(() {
        if (staff == null) {
          _staff.add(
            StaffRecord(
              id: _staff.isEmpty
                  ? 1
                  : _staff
                            .map((item) => item.id)
                            .reduce((a, b) => a > b ? a : b) +
                        1,
              employeeId: employeeId,
              name: employeeName,
              gender: gender!,
              email: emailController.text.trim(),
              phone: phoneController.text.trim(),
              designation: designation!,
              department: department!,
              employmentType: employmentType,
              qualification: qualificationController.text.trim(),
              joiningDate: joiningDateController.text,
              salary: monthlySalary,
              status: status,
            ),
          );
          _salaryRecords.add(
            SalaryRecord(
              id: _nextSalaryId(),
              employeeName: employeeName,
              baseSalary: monthlySalary,
              month: salaryMonth,
            ),
          );
        } else {
          final previousName = staff.name;
          staff
            ..name = employeeName
            ..gender = gender!
            ..email = emailController.text.trim()
            ..phone = phoneController.text.trim()
            ..designation = designation!
            ..department = department!
            ..employmentType = employmentType
            ..qualification = qualificationController.text.trim()
            ..joiningDate = joiningDateController.text
            ..salary = monthlySalary
            ..status = status;
          for (final record in _leaves.where(
            (item) => item.employeeName == previousName,
          )) {
            record.employeeName = staff.name;
          }
          for (final record in _staffAttendance.where(
            (item) => item.employeeName == previousName,
          )) {
            record.employeeName = staff.name;
          }
          for (final record in _performance.where(
            (item) => item.employeeName == previousName,
          )) {
            record.employeeName = staff.name;
          }
          for (final record in _salaryRecords.where(
            (item) => item.employeeName == previousName,
          )) {
            record.employeeName = staff.name;
          }
          final currentSalaries = _salaryRecords
              .where(
                (item) =>
                    item.employeeName == employeeName &&
                    item.month == salaryMonth,
              )
              .toList();
          if (currentSalaries.isEmpty) {
            _salaryRecords.add(
              SalaryRecord(
                id: _nextSalaryId(),
                employeeName: employeeName,
                baseSalary: monthlySalary,
                month: salaryMonth,
              ),
            );
          } else {
            currentSalaries.first.baseSalary = monthlySalary;
          }
        }
      });
      await persistNow();
      if (!drawerContext.mounted) return;
      Navigator.pop(drawerContext);
      _showFlashMessage(
        context,
        isNew
            ? 'Employee created successfully.'
            : 'Employee updated successfully.',
      );
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close employee form',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 280),
      transitionBuilder: (context, animation, secondaryAnimation, child) =>
          child,
      pageBuilder: (dialogContext, animation, secondaryAnimation) =>
          StatefulBuilder(
            builder: (context, setDrawerState) {
              final drawerWidth = contentRect.width < 900
                  ? contentRect.width
                  : contentRect.width * 0.52;
              final panelAnimation = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              );
              return Stack(
                children: [
                  Positioned(
                    left: contentRect.left,
                    top: contentRect.top,
                    width: drawerWidth,
                    height: contentRect.height,
                    child: ClipRect(
                      child: AnimatedBuilder(
                        animation: panelAnimation,
                        builder: (context, child) => Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: panelAnimation.value,
                          child: child,
                        ),
                        child: Material(
                          key: const Key('staff_side_drawer'),
                          elevation: 24,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: Scaffold(
                            appBar: AppBar(
                              automaticallyImplyLeading: false,
                              title: Text(
                                staff == null
                                    ? 'New Employee'
                                    : 'Edit Employee',
                              ),
                              actions: [
                                IconButton(
                                  tooltip: 'Close',
                                  onPressed: () => Navigator.pop(dialogContext),
                                  icon: const Icon(Icons.close),
                                ),
                              ],
                            ),
                            body: Form(
                              key: formKey,
                              child: ListView(
                                padding: const EdgeInsets.all(24),
                                children: [
                                  Wrap(
                                    spacing: 20,
                                    runSpacing: 16,
                                    children: [
                                      _staffTextField(
                                        controller: employeeIdController,
                                        label: 'Employee ID',
                                        readOnly: true,
                                      ),
                                      _staffTextField(
                                        controller: nameController,
                                        label: 'Full Name',
                                        validator: _required('full name'),
                                      ),
                                      _staffDropdown(
                                        label: 'Gender',
                                        value: gender,
                                        items: _genders,
                                        onChanged: (value) => setDrawerState(
                                          () => gender = value,
                                        ),
                                      ),
                                      _staffTextField(
                                        controller: emailController,
                                        label: 'Email',
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) =>
                                            RegExp(
                                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                            ).hasMatch(value ?? '')
                                            ? null
                                            : 'Enter a valid email',
                                      ),
                                      _staffTextField(
                                        controller: phoneController,
                                        label: 'Mobile Number',
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        validator: (value) =>
                                            RegExp(
                                              r'^[6-9]\d{9}$',
                                            ).hasMatch(value ?? '')
                                            ? null
                                            : 'Enter a valid 10-digit mobile number',
                                      ),
                                      _staffDropdown(
                                        label: 'Designation',
                                        value: designation,
                                        items: _designations,
                                        onChanged: (value) => setDrawerState(
                                          () => designation = value,
                                        ),
                                      ),
                                      _staffDropdown(
                                        label: 'Department',
                                        value: department,
                                        items: _departments,
                                        onChanged: (value) => setDrawerState(
                                          () => department = value,
                                        ),
                                      ),
                                      _staffDropdown(
                                        label: 'Employment Type',
                                        value: employmentType,
                                        items: _employmentTypes,
                                        onChanged: (value) => setDrawerState(
                                          () => employmentType =
                                              value ?? employmentType,
                                        ),
                                      ),
                                      _staffTextField(
                                        controller: qualificationController,
                                        label: 'Qualification',
                                        validator: _required('qualification'),
                                      ),
                                      _staffTextField(
                                        controller: joiningDateController,
                                        label: 'Joining Date',
                                        readOnly: true,
                                        suffixIcon: const Icon(
                                          Icons.calendar_today_outlined,
                                        ),
                                        validator: _required('joining date'),
                                        onTap: () async {
                                          final selected = await showDatePicker(
                                            context: context,
                                            initialDate:
                                                DateTime.tryParse(
                                                  joiningDateController.text,
                                                ) ??
                                                DateTime.now(),
                                            firstDate: DateTime(1980),
                                            lastDate: DateTime.now(),
                                          );
                                          if (selected != null) {
                                            joiningDateController.text =
                                                DateFormat(
                                                  'yyyy-MM-dd',
                                                ).format(selected);
                                          }
                                        },
                                      ),
                                      _staffTextField(
                                        controller: salaryController,
                                        label: 'Monthly Salary',
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        validator: (value) {
                                          final amount = double.tryParse(
                                            value ?? '',
                                          );
                                          return amount == null || amount <= 0
                                              ? 'Enter a valid salary'
                                              : null;
                                        },
                                      ),
                                      _staffDropdown(
                                        label: 'Status',
                                        value: status,
                                        items: _statuses,
                                        onChanged: (value) => setDrawerState(
                                          () => status = value ?? status,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            bottomNavigationBar: Material(
                              elevation: 12,
                              child: SafeArea(
                                top: false,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton(
                                        key: const Key('staff_cancel_button'),
                                        onPressed: () =>
                                            Navigator.pop(dialogContext),
                                        child: const Text('Cancel'),
                                      ),
                                      const SizedBox(width: 12),
                                      ElevatedButton.icon(
                                        key: const Key('staff_submit_button'),
                                        onPressed: () => submit(dialogContext),
                                        icon: Icon(
                                          staff == null
                                              ? Icons.add
                                              : Icons.save_outlined,
                                        ),
                                        label: Text(
                                          staff == null ? 'Create' : 'Save',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }

  String _generateEmployeeId() {
    var sequence = _staff.length + 1;
    var candidate = 'EMP-${sequence.toString().padLeft(3, '0')}';
    while (_staff.any((employee) => employee.employeeId == candidate)) {
      sequence++;
      candidate = 'EMP-${sequence.toString().padLeft(3, '0')}';
    }
    return candidate;
  }

  int _nextSalaryId() {
    if (_salaryRecords.isEmpty) return 1;
    return _salaryRecords
            .map((record) => record.id)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }

  void _ensureCurrentSalaryRecords() {
    final currentMonth = DateFormat('yyyy-MM').format(DateTime.now());
    for (final employee in _staff) {
      if (employee.salary.trim().isEmpty) continue;
      final exists = _salaryRecords.any(
        (record) =>
            record.employeeName == employee.name &&
            record.month == currentMonth,
      );
      if (!exists) {
        _salaryRecords.add(
          SalaryRecord(
            id: _nextSalaryId(),
            employeeName: employee.name,
            baseSalary: employee.salary,
            month: currentMonth,
          ),
        );
      }
    }
  }

  String? _firstMissingEmployeeField({
    required String name,
    required String? gender,
    required String email,
    required String phone,
    required String? designation,
    required String? department,
    required String qualification,
    required String joiningDate,
    required String salary,
  }) {
    final requiredFields = <String, bool>{
      'Full Name': name.trim().isNotEmpty,
      'Gender': gender != null,
      'Email': email.trim().isNotEmpty,
      'Mobile Number': phone.trim().isNotEmpty,
      'Designation': designation != null,
      'Department': department != null,
      'Qualification': qualification.trim().isNotEmpty,
      'Joining Date': joiningDate.trim().isNotEmpty,
      'Monthly Salary': salary.trim().isNotEmpty,
    };
    for (final entry in requiredFields.entries) {
      if (!entry.value) return entry.key;
    }
    return null;
  }

  void _showFlashMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String? Function(String?) _required(String field) {
    return (value) =>
        value == null || value.trim().isEmpty ? 'Enter $field' : null;
  }

  Widget _staffTextField({
    required TextEditingController controller,
    required String label,
    bool readOnly = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return SizedBox(
      width: 440,
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        onTap: onTap,
        decoration: InputDecoration(labelText: label, suffixIcon: suffixIcon),
      ),
    );
  }

  Widget _staffDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return SizedBox(
      width: 440,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(labelText: label),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
        validator: (selection) =>
            selection == null ? 'Select ${label.toLowerCase()}' : null,
      ),
    );
  }

  void _showAlignedStaffDrawer({
    required BuildContext context,
    required GlobalKey anchorKey,
    required String drawerKey,
    required String title,
    required String submitLabel,
    required Widget Function(BuildContext, StateSetter) contentBuilder,
    required Future<bool> Function(BuildContext) onSubmit,
    required String successMessage,
  }) {
    final renderObject =
        anchorKey.currentContext?.findRenderObject() ??
        context.findRenderObject();
    final contentRect = renderObject is RenderBox
        ? renderObject.localToGlobal(Offset.zero) & renderObject.size
        : Offset.zero & MediaQuery.sizeOf(context);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close $title',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 280),
      transitionBuilder: (context, animation, secondaryAnimation, child) =>
          child,
      pageBuilder: (dialogContext, animation, secondaryAnimation) =>
          StatefulBuilder(
            builder: (context, setDrawerState) {
              final drawerWidth = contentRect.width < 900
                  ? contentRect.width
                  : contentRect.width * 0.52;
              final panelAnimation = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              );
              return Stack(
                children: [
                  Positioned(
                    left: contentRect.left,
                    top: contentRect.top,
                    width: drawerWidth,
                    height: contentRect.height,
                    child: ClipRect(
                      child: AnimatedBuilder(
                        animation: panelAnimation,
                        builder: (context, child) => Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: panelAnimation.value,
                          child: child,
                        ),
                        child: Material(
                          key: Key(drawerKey),
                          elevation: 24,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: Scaffold(
                            appBar: AppBar(
                              automaticallyImplyLeading: false,
                              title: Text(title),
                              actions: [
                                IconButton(
                                  tooltip: 'Close',
                                  onPressed: () => Navigator.pop(dialogContext),
                                  icon: const Icon(Icons.close),
                                ),
                              ],
                            ),
                            body: ListView(
                              padding: const EdgeInsets.all(24),
                              children: [
                                contentBuilder(context, setDrawerState),
                              ],
                            ),
                            bottomNavigationBar: Material(
                              elevation: 12,
                              child: SafeArea(
                                top: false,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext),
                                        child: const Text('Cancel'),
                                      ),
                                      const SizedBox(width: 12),
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          if (!await onSubmit(dialogContext)) {
                                            return;
                                          }
                                          if (!dialogContext.mounted) return;
                                          Navigator.pop(dialogContext);
                                          _showFlashMessage(
                                            context,
                                            successMessage,
                                          );
                                        },
                                        icon: const Icon(Icons.save_outlined),
                                        label: Text(submitLabel),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }

  void _showLeaveDialog(
    BuildContext context, {
    LeaveRecord? leave,
    required GlobalKey anchorKey,
  }) {
    String selectedEmployee =
        leave?.employeeName ?? (_staff.isNotEmpty ? _staff.first.name : '');
    final fromDateController = TextEditingController(
      text: leave?.fromDate ?? '',
    );
    final toDateController = TextEditingController(text: leave?.toDate ?? '');
    final reasonController = TextEditingController(text: leave?.reason ?? '');
    String leaveType = leave?.leaveType ?? 'Casual Leave';

    _showAlignedStaffDrawer(
      context: context,
      anchorKey: anchorKey,
      drawerKey: 'staff_leave_drawer',
      title: leave == null ? 'New Leave Request' : 'Edit Leave Request',
      submitLabel: leave == null ? 'Create' : 'Save',
      successMessage: leave == null
          ? 'Leave request created successfully.'
          : 'Leave request updated successfully.',
      contentBuilder: (drawerContext, setDrawerState) => Column(
        children: [
          DropdownButtonFormField<String>(
            initialValue: selectedEmployee.isNotEmpty ? selectedEmployee : null,
            items: _staff
                .map(
                  (staff) => DropdownMenuItem(
                    value: staff.name,
                    child: Text(staff.name),
                  ),
                )
                .toList(),
            decoration: const InputDecoration(labelText: 'Employee'),
            onChanged: (value) =>
                setDrawerState(() => selectedEmployee = value ?? ''),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: leaveType,
            items: ['Casual Leave', 'Sick Leave', 'Earned Leave']
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (value) =>
                setDrawerState(() => leaveType = value ?? leaveType),
            decoration: const InputDecoration(labelText: 'Leave Type'),
          ),
          const SizedBox(height: 16),
          _dialogDateField(
            drawerContext,
            controller: fromDateController,
            label: 'From Date',
          ),
          const SizedBox(height: 16),
          _dialogDateField(
            drawerContext,
            controller: toDateController,
            label: 'To Date',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: reasonController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Reason',
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
      onSubmit: (drawerContext) async {
        final missingField = <String, bool>{
          'Employee': selectedEmployee.isNotEmpty,
          'From Date': fromDateController.text.isNotEmpty,
          'To Date': toDateController.text.isNotEmpty,
          'Reason': reasonController.text.trim().isNotEmpty,
        }.entries.where((entry) => !entry.value).map((entry) => entry.key);
        if (missingField.isNotEmpty) {
          _showFlashMessage(
            drawerContext,
            'Missing required field: ${missingField.first}',
          );
          return false;
        }
        final fromDate = DateTime.parse(fromDateController.text);
        final toDate = DateTime.parse(toDateController.text);
        if (toDate.isBefore(fromDate)) {
          _showFlashMessage(
            drawerContext,
            'To Date cannot be before From Date.',
          );
          return false;
        }
        setState(() {
          if (leave == null) {
            _leaves.add(
              LeaveRecord(
                id: _leaves.isEmpty ? 1 : _leaves.last.id + 1,
                employeeName: selectedEmployee,
                leaveType: leaveType,
                fromDate: fromDateController.text,
                toDate: toDateController.text,
                reason: reasonController.text.trim(),
              ),
            );
          } else {
            leave
              ..employeeName = selectedEmployee
              ..leaveType = leaveType
              ..fromDate = fromDateController.text
              ..toDate = toDateController.text
              ..reason = reasonController.text.trim();
          }
        });
        await persistNow();
        return true;
      },
    );
  }

  void _showAttendanceDialog(
    BuildContext context, {
    AttendanceRecord? attendance,
    required GlobalKey anchorKey,
  }) {
    String selectedEmployee =
        attendance?.employeeName ??
        (_staff.isNotEmpty ? _staff.first.name : '');
    String status = attendance?.status ?? 'Present';
    final dateController = TextEditingController(
      text: attendance?.date ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );

    _showAlignedStaffDrawer(
      context: context,
      anchorKey: anchorKey,
      drawerKey: 'staff_attendance_drawer',
      title: attendance == null ? 'Mark Attendance' : 'Edit Attendance',
      submitLabel: attendance == null ? 'Create' : 'Save',
      successMessage: attendance == null
          ? 'Attendance created successfully.'
          : 'Attendance updated successfully.',
      contentBuilder: (drawerContext, setDrawerState) => Column(
        children: [
          DropdownButtonFormField<String>(
            initialValue: selectedEmployee.isNotEmpty ? selectedEmployee : null,
            items: _staff
                .map(
                  (staff) => DropdownMenuItem(
                    value: staff.name,
                    child: Text(staff.name),
                  ),
                )
                .toList(),
            decoration: const InputDecoration(labelText: 'Employee'),
            onChanged: (value) =>
                setDrawerState(() => selectedEmployee = value ?? ''),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: status,
            items: ['Present', 'Absent', 'Leave', 'Half Day']
                .map(
                  (attendanceStatus) => DropdownMenuItem(
                    value: attendanceStatus,
                    child: Text(attendanceStatus),
                  ),
                )
                .toList(),
            onChanged: (value) =>
                setDrawerState(() => status = value ?? status),
            decoration: const InputDecoration(labelText: 'Status'),
          ),
          const SizedBox(height: 16),
          _dialogDateField(
            drawerContext,
            controller: dateController,
            label: 'Attendance Date',
          ),
        ],
      ),
      onSubmit: (drawerContext) async {
        if (selectedEmployee.isEmpty) {
          _showFlashMessage(drawerContext, 'Missing required field: Employee');
          return false;
        }
        if (dateController.text.isEmpty) {
          _showFlashMessage(
            drawerContext,
            'Missing required field: Attendance Date',
          );
          return false;
        }
        final duplicate =
            attendance == null &&
            _staffAttendance.any(
              (record) =>
                  record.employeeName == selectedEmployee &&
                  record.date == dateController.text,
            );
        if (duplicate) {
          _showFlashMessage(
            drawerContext,
            'Attendance is already marked for this employee and date.',
          );
          return false;
        }
        setState(() {
          if (attendance == null) {
            _staffAttendance.add(
              AttendanceRecord(
                id: _staffAttendance.isEmpty ? 1 : _staffAttendance.last.id + 1,
                employeeName: selectedEmployee,
                date: dateController.text,
                status: status,
              ),
            );
          } else {
            attendance
              ..employeeName = selectedEmployee
              ..status = status
              ..date = dateController.text;
          }
        });
        await persistNow();
        return true;
      },
    );
  }

  void _showPerformanceDialog(
    BuildContext context, {
    PerformanceRecord? performance,
    required GlobalKey anchorKey,
  }) {
    String selectedEmployee =
        performance?.employeeName ??
        (_staff.isNotEmpty ? _staff.first.name : '');
    final commentsController = TextEditingController(
      text: performance?.comments ?? '',
    );
    final ratingController = TextEditingController(
      text: performance?.rating ?? '8',
    );

    _showAlignedStaffDrawer(
      context: context,
      anchorKey: anchorKey,
      drawerKey: 'staff_performance_drawer',
      title: performance == null
          ? 'Performance Review'
          : 'Edit Performance Review',
      submitLabel: performance == null ? 'Create' : 'Save',
      successMessage: performance == null
          ? 'Performance review created successfully.'
          : 'Performance review updated successfully.',
      contentBuilder: (drawerContext, setDrawerState) => Column(
        children: [
          DropdownButtonFormField<String>(
            initialValue: selectedEmployee.isNotEmpty ? selectedEmployee : null,
            items: _staff
                .map(
                  (staff) => DropdownMenuItem(
                    value: staff.name,
                    child: Text(staff.name),
                  ),
                )
                .toList(),
            decoration: const InputDecoration(labelText: 'Employee'),
            onChanged: (value) =>
                setDrawerState(() => selectedEmployee = value ?? ''),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: ratingController,
            decoration: const InputDecoration(labelText: 'Rating (1-10)'),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: commentsController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Comments',
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
      onSubmit: (drawerContext) async {
        if (selectedEmployee.isEmpty) {
          _showFlashMessage(drawerContext, 'Missing required field: Employee');
          return false;
        }
        if (ratingController.text.trim().isEmpty) {
          _showFlashMessage(drawerContext, 'Missing required field: Rating');
          return false;
        }
        if (commentsController.text.trim().isEmpty) {
          _showFlashMessage(drawerContext, 'Missing required field: Comments');
          return false;
        }
        final rating = int.tryParse(ratingController.text);
        if (rating == null || rating < 1 || rating > 10) {
          _showFlashMessage(drawerContext, 'Rating must be between 1 and 10.');
          return false;
        }
        setState(() {
          if (performance == null) {
            _performance.add(
              PerformanceRecord(
                id: _performance.isEmpty ? 1 : _performance.last.id + 1,
                employeeName: selectedEmployee,
                rating: rating.toString(),
                comments: commentsController.text.trim(),
                reviewDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
              ),
            );
          } else {
            performance
              ..employeeName = selectedEmployee
              ..rating = rating.toString()
              ..comments = commentsController.text.trim();
          }
        });
        await persistNow();
        return true;
      },
    );
  }

  void _showSalaryDialog(
    BuildContext context, {
    SalaryRecord? salary,
    required GlobalKey anchorKey,
  }) {
    String selectedEmployee =
        salary?.employeeName ?? (_staff.isNotEmpty ? _staff.first.name : '');
    final amountController = TextEditingController(
      text: salary?.baseSalary ?? '',
    );
    final monthOptions = List.generate(
      12,
      (index) => DateFormat(
        'yyyy-MM',
      ).format(DateTime(DateTime.now().year, DateTime.now().month - index)),
    );
    String selectedMonth = monthOptions.contains(salary?.month)
        ? salary!.month
        : monthOptions.first;
    _showAlignedStaffDrawer(
      context: context,
      anchorKey: anchorKey,
      drawerKey: 'staff_salary_drawer',
      title: salary == null ? 'Add Salary Record' : 'Edit Salary Record',
      submitLabel: salary == null ? 'Create' : 'Save',
      successMessage: salary == null
          ? 'Salary record created successfully.'
          : 'Salary record updated successfully.',
      contentBuilder: (drawerContext, setDrawerState) => Column(
        children: [
          DropdownButtonFormField<String>(
            initialValue: selectedEmployee.isNotEmpty ? selectedEmployee : null,
            items: _staff
                .map(
                  (staff) => DropdownMenuItem(
                    value: staff.name,
                    child: Text(staff.name),
                  ),
                )
                .toList(),
            decoration: const InputDecoration(labelText: 'Employee'),
            onChanged: (value) =>
                setDrawerState(() => selectedEmployee = value ?? ''),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(labelText: 'Base Salary'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: selectedMonth,
            items: monthOptions
                .map(
                  (month) => DropdownMenuItem(value: month, child: Text(month)),
                )
                .toList(),
            onChanged: (value) =>
                setDrawerState(() => selectedMonth = value ?? selectedMonth),
            decoration: const InputDecoration(labelText: 'Salary Month'),
          ),
        ],
      ),
      onSubmit: (drawerContext) async {
        if (selectedEmployee.isEmpty) {
          _showFlashMessage(drawerContext, 'Missing required field: Employee');
          return false;
        }
        if (amountController.text.trim().isEmpty) {
          _showFlashMessage(
            drawerContext,
            'Missing required field: Base Salary',
          );
          return false;
        }
        final amount = double.tryParse(amountController.text);
        if (amount == null || amount <= 0) {
          _showFlashMessage(drawerContext, 'Enter a valid base salary.');
          return false;
        }
        final duplicate =
            salary == null &&
            _salaryRecords.any(
              (record) =>
                  record.employeeName == selectedEmployee &&
                  record.month == selectedMonth,
            );
        if (duplicate) {
          _showFlashMessage(
            drawerContext,
            'A salary record already exists for this employee and month.',
          );
          return false;
        }
        setState(() {
          if (salary == null) {
            _salaryRecords.add(
              SalaryRecord(
                id: _nextSalaryId(),
                employeeName: selectedEmployee,
                baseSalary: amountController.text.trim(),
                month: selectedMonth,
              ),
            );
          } else {
            salary
              ..employeeName = selectedEmployee
              ..baseSalary = amountController.text.trim()
              ..month = selectedMonth;
          }
          final employee = _staff
              .where((staff) => staff.name == selectedEmployee)
              .toList();
          if (employee.isNotEmpty) {
            employee.first.salary = amountController.text.trim();
          }
        });
        await persistNow();
        return true;
      },
    );
  }

  Widget _dialogDateField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.calendar_today_outlined),
      ),
      onTap: () async {
        final selected = await showDatePicker(
          context: context,
          initialDate: DateTime.tryParse(controller.text) ?? DateTime.now(),
          firstDate: DateTime(1980),
          lastDate: DateTime(2100),
        );
        if (selected != null) {
          controller.text = DateFormat('yyyy-MM-dd').format(selected);
        }
      },
    );
  }
}

class StaffRecord {
  StaffRecord({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.gender,
    required this.email,
    required this.phone,
    required this.designation,
    required this.department,
    required this.employmentType,
    required this.qualification,
    required this.joiningDate,
    required this.salary,
    required this.status,
  });

  final int id;
  String employeeId;
  String name;
  String gender;
  String email;
  String phone;
  String designation;
  String department;
  String employmentType;
  String qualification;
  String joiningDate;
  String salary;
  String status;

  Map<String, dynamic> toJson() => {
    'id': id,
    'employeeId': employeeId,
    'name': name,
    'gender': gender,
    'email': email,
    'phone': phone,
    'designation': designation,
    'department': department,
    'employmentType': employmentType,
    'qualification': qualification,
    'joiningDate': joiningDate,
    'salary': salary,
    'status': status,
  };

  factory StaffRecord.fromJson(Map<String, dynamic> json) => StaffRecord(
    id: json['id'] as int,
    employeeId: json['employeeId'] as String,
    name: json['name'] as String,
    gender: json['gender'] as String? ?? 'Other',
    email: json['email'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
    designation: json['designation'] as String,
    department: json['department'] as String,
    employmentType: json['employmentType'] as String? ?? 'Permanent',
    qualification: json['qualification'] as String,
    joiningDate: json['joiningDate'] as String,
    salary: json['salary'] as String,
    status: json['status'] as String? ?? 'Active',
  );
}

class LeaveRecord {
  LeaveRecord({
    required this.id,
    required this.employeeName,
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    this.status = 'Pending',
  });
  final int id;
  String employeeName;
  String leaveType;
  String fromDate;
  String toDate;
  String reason;
  String status;

  Map<String, dynamic> toJson() => {
    'id': id,
    'employeeName': employeeName,
    'leaveType': leaveType,
    'fromDate': fromDate,
    'toDate': toDate,
    'reason': reason,
    'status': status,
  };
  factory LeaveRecord.fromJson(Map<String, dynamic> json) => LeaveRecord(
    id: json['id'] as int,
    employeeName: json['employeeName'] as String,
    leaveType: json['leaveType'] as String,
    fromDate: json['fromDate'] as String,
    toDate: json['toDate'] as String,
    reason: json['reason'] as String,
    status: json['status'] as String? ?? 'Pending',
  );
}

class AttendanceRecord {
  AttendanceRecord({
    required this.id,
    required this.employeeName,
    required this.date,
    required this.status,
  });
  final int id;
  String employeeName;
  String date;
  String status;

  Map<String, dynamic> toJson() => {
    'id': id,
    'employeeName': employeeName,
    'date': date,
    'status': status,
  };
  factory AttendanceRecord.fromJson(Map<String, dynamic> json) =>
      AttendanceRecord(
        id: json['id'] as int,
        employeeName: json['employeeName'] as String,
        date: json['date'] as String,
        status: json['status'] as String,
      );
}

class PerformanceRecord {
  PerformanceRecord({
    required this.id,
    required this.employeeName,
    required this.rating,
    required this.comments,
    required this.reviewDate,
  });
  final int id;
  String employeeName;
  String rating;
  String comments;
  final String reviewDate;

  Map<String, dynamic> toJson() => {
    'id': id,
    'employeeName': employeeName,
    'rating': rating,
    'comments': comments,
    'reviewDate': reviewDate,
  };
  factory PerformanceRecord.fromJson(Map<String, dynamic> json) =>
      PerformanceRecord(
        id: json['id'] as int,
        employeeName: json['employeeName'] as String,
        rating: json['rating'] as String,
        comments: json['comments'] as String,
        reviewDate: json['reviewDate'] as String,
      );
}

class SalaryRecord {
  SalaryRecord({
    required this.id,
    required this.employeeName,
    required this.baseSalary,
    required this.month,
  });
  final int id;
  String employeeName;
  String baseSalary;
  String month;

  Map<String, dynamic> toJson() => {
    'id': id,
    'employeeName': employeeName,
    'baseSalary': baseSalary,
    'month': month,
  };
  factory SalaryRecord.fromJson(Map<String, dynamic> json) => SalaryRecord(
    id: json['id'] as int,
    employeeName: json['employeeName'] as String,
    baseSalary: json['baseSalary'] as String,
    month: json['month'] as String,
  );
}
