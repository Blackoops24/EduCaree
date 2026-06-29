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
  final TextEditingController _registrationSearchController =
      TextEditingController();
  final TextEditingController _profileSearchController =
      TextEditingController();
  String _registrationSearchQuery = '';
  String _profileSearchQuery = '';

  @override
  String get moduleKey => 'staff';

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
          action: () => _showStaffDrawer(context),
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
                              onPressed: () =>
                                  _showStaffDrawer(context, staff: employee),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Leave Management',
          'Manage employee leave records.',
          action: () =>
              _withRegisteredStaff(context, () => _showLeaveDialog(context)),
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
                              onPressed: () =>
                                  _showLeaveDialog(context, leave: leave),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Staff Attendance',
          'Mark and track staff attendance.',
          action: () => _withRegisteredStaff(
            context,
            () => _showAttendanceDialog(context),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Performance Tracking',
          'Manage employee performance records.',
          action: () => _withRegisteredStaff(
            context,
            () => _showPerformanceDialog(context),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Salary Details',
          'View and manage salary information.',
          action: () =>
              _withRegisteredStaff(context, () => _showSalaryDialog(context)),
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
                              onPressed: () =>
                                  _showSalaryDialog(context, salary: salary),
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

  void _showStaffDrawer(BuildContext context, {StaffRecord? staff}) {
    final renderObject =
        _registrationContentKey.currentContext?.findRenderObject() ??
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
      if (!(formKey.currentState?.validate() ?? false)) return;
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
              name: nameController.text.trim(),
              gender: gender!,
              email: emailController.text.trim(),
              phone: phoneController.text.trim(),
              designation: designation!,
              department: department!,
              employmentType: employmentType,
              qualification: qualificationController.text.trim(),
              joiningDate: joiningDateController.text,
              salary: salaryController.text.trim(),
              status: status,
            ),
          );
        } else {
          final previousName = staff.name;
          staff
            ..name = nameController.text.trim()
            ..gender = gender!
            ..email = emailController.text.trim()
            ..phone = phoneController.text.trim()
            ..designation = designation!
            ..department = department!
            ..employmentType = employmentType
            ..qualification = qualificationController.text.trim()
            ..joiningDate = joiningDateController.text
            ..salary = salaryController.text.trim()
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
        }
      });
      await persistNow();
      if (drawerContext.mounted) Navigator.pop(drawerContext);
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

  void _showLeaveDialog(BuildContext context, {LeaveRecord? leave}) {
    String selectedEmployee =
        leave?.employeeName ?? (_staff.isNotEmpty ? _staff.first.name : '');
    final fromDateController = TextEditingController(
      text: leave?.fromDate ?? '',
    );
    final toDateController = TextEditingController(text: leave?.toDate ?? '');
    final reasonController = TextEditingController(text: leave?.reason ?? '');
    String leaveType = leave?.leaveType ?? 'Casual Leave';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(leave == null ? 'New Leave Request' : 'Edit Leave Request'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedEmployee.isNotEmpty
                    ? selectedEmployee
                    : null,
                items: _staff
                    .map(
                      (s) =>
                          DropdownMenuItem(value: s.name, child: Text(s.name)),
                    )
                    .toList(),
                decoration: const InputDecoration(labelText: 'Employee'),
                onChanged: (value) =>
                    selectedEmployee = value ?? selectedEmployee,
              ),
              DropdownButtonFormField<String>(
                initialValue: leaveType,
                items: ['Casual Leave', 'Sick Leave', 'Earned Leave']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (value) => leaveType = value ?? leaveType,
                decoration: const InputDecoration(labelText: 'Leave Type'),
              ),
              _dialogDateField(
                context,
                controller: fromDateController,
                label: 'From Date',
              ),
              _dialogDateField(
                context,
                controller: toDateController,
                label: 'To Date',
              ),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(labelText: 'Reason'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final fromDate = DateTime.tryParse(fromDateController.text);
              final toDate = DateTime.tryParse(toDateController.text);
              if (fromDate == null || toDate == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Select valid leave dates.')),
                );
                return;
              }
              if (toDate.isBefore(fromDate)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('To Date cannot be before From Date.'),
                  ),
                );
                return;
              }
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enter a leave reason.')),
                );
                return;
              }
              setState(() {
                if (leave == null) {
                  _leaves.add(
                    LeaveRecord(
                      id: _leaves.isEmpty ? 1 : _leaves.last.id + 1,
                      employeeName: selectedEmployee,
                      leaveType: leaveType,
                      fromDate: fromDateController.text.trim(),
                      toDate: toDateController.text.trim(),
                      reason: reasonController.text.trim(),
                    ),
                  );
                } else {
                  leave
                    ..employeeName = selectedEmployee
                    ..leaveType = leaveType
                    ..fromDate = fromDateController.text.trim()
                    ..toDate = toDateController.text.trim()
                    ..reason = reasonController.text.trim();
                }
              });
              await persistNow();
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: Text(leave == null ? 'Submit' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _showAttendanceDialog(
    BuildContext context, {
    AttendanceRecord? attendance,
  }) {
    String selectedEmployee =
        attendance?.employeeName ??
        (_staff.isNotEmpty ? _staff.first.name : '');
    String status = attendance?.status ?? 'Present';
    final dateController = TextEditingController(
      text: attendance?.date ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(attendance == null ? 'Mark Attendance' : 'Edit Attendance'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedEmployee.isNotEmpty
                    ? selectedEmployee
                    : null,
                items: _staff
                    .map(
                      (s) =>
                          DropdownMenuItem(value: s.name, child: Text(s.name)),
                    )
                    .toList(),
                decoration: const InputDecoration(labelText: 'Employee'),
                onChanged: (value) =>
                    selectedEmployee = value ?? selectedEmployee,
              ),
              DropdownButtonFormField<String>(
                initialValue: status,
                items: ['Present', 'Absent', 'Leave', 'Half Day']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) => status = value ?? status,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              _dialogDateField(
                context,
                controller: dateController,
                label: 'Attendance Date',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final duplicate =
                  attendance == null &&
                  _staffAttendance.any(
                    (record) =>
                        record.employeeName == selectedEmployee &&
                        record.date == dateController.text,
                  );
              if (duplicate) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Attendance is already marked for this employee and date.',
                    ),
                  ),
                );
                return;
              }
              setState(() {
                if (attendance == null) {
                  _staffAttendance.add(
                    AttendanceRecord(
                      id: _staffAttendance.isEmpty
                          ? 1
                          : _staffAttendance.last.id + 1,
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
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: Text(attendance == null ? 'Mark' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _showPerformanceDialog(
    BuildContext context, {
    PerformanceRecord? performance,
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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          performance == null
              ? 'Performance Review'
              : 'Edit Performance Review',
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedEmployee.isNotEmpty
                    ? selectedEmployee
                    : null,
                items: _staff
                    .map(
                      (s) =>
                          DropdownMenuItem(value: s.name, child: Text(s.name)),
                    )
                    .toList(),
                decoration: const InputDecoration(labelText: 'Employee'),
                onChanged: (value) =>
                    selectedEmployee = value ?? selectedEmployee,
              ),
              TextField(
                controller: ratingController,
                decoration: const InputDecoration(labelText: 'Rating (1-10)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: commentsController,
                decoration: const InputDecoration(labelText: 'Comments'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final rating = int.tryParse(ratingController.text);
              if (rating == null || rating < 1 || rating > 10) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Rating must be between 1 and 10.'),
                  ),
                );
                return;
              }
              if (commentsController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enter review comments.')),
                );
                return;
              }
              setState(() {
                if (performance == null) {
                  _performance.add(
                    PerformanceRecord(
                      id: _performance.isEmpty ? 1 : _performance.last.id + 1,
                      employeeName: selectedEmployee,
                      rating: rating.toString(),
                      comments: commentsController.text.trim(),
                      reviewDate: DateTime.now().toString().split(' ').first,
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
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: Text(performance == null ? 'Submit Review' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _showSalaryDialog(BuildContext context, {SalaryRecord? salary}) {
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          salary == null ? 'Add Salary Record' : 'Edit Salary Record',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: selectedEmployee.isNotEmpty
                  ? selectedEmployee
                  : null,
              items: _staff
                  .map(
                    (item) => DropdownMenuItem(
                      value: item.name,
                      child: Text(item.name),
                    ),
                  )
                  .toList(),
              decoration: const InputDecoration(labelText: 'Employee'),
              onChanged: (value) =>
                  selectedEmployee = value ?? selectedEmployee,
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Base Salary'),
            ),
            DropdownButtonFormField<String>(
              initialValue: selectedMonth,
              items: monthOptions
                  .map(
                    (month) =>
                        DropdownMenuItem(value: month, child: Text(month)),
                  )
                  .toList(),
              onChanged: (value) => selectedMonth = value ?? selectedMonth,
              decoration: const InputDecoration(labelText: 'Salary Month'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedEmployee.isEmpty ||
                  double.tryParse(amountController.text) == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Complete all salary fields.')),
                );
                return;
              }
              setState(() {
                if (salary == null) {
                  _salaryRecords.add(
                    SalaryRecord(
                      id: _salaryRecords.isEmpty
                          ? 1
                          : _salaryRecords.last.id + 1,
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
              });
              await persistNow();
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: Text(salary == null ? 'Add' : 'Save'),
          ),
        ],
      ),
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
