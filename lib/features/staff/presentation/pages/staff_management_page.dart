import 'package:educare/core/widgets/delete_confirmation_dialog.dart';
import 'package:educare/core/widgets/persistent_module_state.dart';
import 'package:flutter/material.dart';

class StaffManagementPage extends StatefulWidget {
  const StaffManagementPage({super.key});

  @override
  State<StaffManagementPage> createState() => _StaffManagementPageState();
}

class _StaffManagementPageState extends PersistentModuleState<StaffManagementPage> {
  final List<StaffRecord> _staff = [
    StaffRecord(id: 1, employeeId: 'EMP-001', name: 'Rajesh Kumar', designation: 'Principal', department: 'Administration', qualification: 'M.A., B.Ed', joiningDate: '2015-08-01', salary: '150000'),
    StaffRecord(id: 2, employeeId: 'EMP-002', name: 'Priya Singh', designation: 'Mathematics Teacher', department: 'Academics', qualification: 'M.Sc, B.Ed', joiningDate: '2018-06-15', salary: '45000'),
  ];

  final List<LeaveRecord> _leaves = [];
  final List<AttendanceRecord> _staffAttendance = [];
  final List<PerformanceRecord> _performance = [];
  final List<SalaryRecord> _salaryRecords = [];

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
    _staff..clear()..addAll((data['staff'] as List? ?? []).map((item) => StaffRecord.fromJson(Map<String, dynamic>.from(item as Map))));
    _leaves..clear()..addAll((data['leaves'] as List? ?? []).map((item) => LeaveRecord.fromJson(Map<String, dynamic>.from(item as Map))));
    _staffAttendance..clear()..addAll((data['attendance'] as List? ?? []).map((item) => AttendanceRecord.fromJson(Map<String, dynamic>.from(item as Map))));
    _performance..clear()..addAll((data['performance'] as List? ?? []).map((item) => PerformanceRecord.fromJson(Map<String, dynamic>.from(item as Map))));
    _salaryRecords..clear()..addAll((data['salaries'] as List? ?? []).map((item) => SalaryRecord.fromJson(Map<String, dynamic>.from(item as Map))));
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

  Widget _buildSectionHeader(String title, String subtitle, {VoidCallback? action, String? actionLabel}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          if (action != null && actionLabel != null)
            ElevatedButton(onPressed: action, child: Text(actionLabel)),
        ],
      ),
    );
  }

  Widget _buildRegistrationTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Employee Registration', 'Register and manage employee records.', action: () => _showStaffDialog(context), actionLabel: 'New Employee'),
        Expanded(
          child: _staff.isEmpty
              ? const Center(child: Text('No employees registered.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _staff.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final employee = _staff[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text('${employee.name} (${employee.employeeId})'),
                        subtitle: Text('${employee.designation} • ${employee.department}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showStaffDialog(context, staff: employee)),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final confirmed = await showDeleteConfirmationDialog(
                                  context,
                                  title: 'Delete employee?',
                                  message: 'This will remove ${employee.name} from staff records.',
                                );
                                if (!confirmed) return;
                                setState(() => _staff.removeAt(index));
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Staff Profiles', 'View detailed staff information.'),
        Expanded(
          child: _staff.isEmpty
              ? const Center(child: Text('No staff profiles available.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _staff.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final employee = _staff[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ExpansionTile(
                        title: Text(employee.name),
                        subtitle: Text(employee.employeeId),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildProfileField('Designation', employee.designation),
                                _buildProfileField('Department', employee.department),
                                _buildProfileField('Qualification', employee.qualification),
                                _buildProfileField('Joining Date', employee.joiningDate),
                                _buildProfileField('Salary', '₹${employee.salary}'),
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
        _buildSectionHeader('Leave Management', 'Manage employee leave records.', action: () => _showLeaveDialog(context), actionLabel: 'New Leave'),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(leave.employeeName),
                        subtitle: Text('${leave.leaveType} • ${leave.fromDate} to ${leave.toDate}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showLeaveDialog(context, leave: leave)),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                            final confirmed = await showDeleteConfirmationDialog(
                              context,
                              title: 'Delete leave record?',
                              message: 'This will remove the leave record for ${leave.employeeName}.',
                            );
                            if (!confirmed) return;
                            setState(() => _leaves.removeAt(index));
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
        _buildSectionHeader('Staff Attendance', 'Mark and track staff attendance.', action: () => _showAttendanceDialog(context), actionLabel: 'Mark Attendance'),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(attendance.employeeName),
                        subtitle: Text('${attendance.date} • ${attendance.status}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showAttendanceDialog(context, attendance: attendance)),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                            final confirmed = await showDeleteConfirmationDialog(
                              context,
                              title: 'Delete attendance record?',
                              message: 'This will remove the attendance record for ${attendance.employeeName}.',
                            );
                            if (!confirmed) return;
                            setState(() => _staffAttendance.removeAt(index));
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
        _buildSectionHeader('Performance Tracking', 'Manage employee performance records.', action: () => _showPerformanceDialog(context), actionLabel: 'New Review'),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(perf.employeeName),
                        subtitle: Text('Rating: ${perf.rating}/10 • ${perf.reviewDate}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showPerformanceDialog(context, performance: perf)),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                            final confirmed = await showDeleteConfirmationDialog(
                              context,
                              title: 'Delete performance record?',
                              message: 'This will remove the performance review for ${perf.employeeName}.',
                            );
                            if (!confirmed) return;
                            setState(() => _performance.removeAt(index));
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
        _buildSectionHeader('Salary Details', 'View and manage salary information.', action: () => _showSalaryDialog(context), actionLabel: 'Add Salary'),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(salary.employeeName),
                        subtitle: Text('₹${salary.baseSalary} • ${salary.month}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.download), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Salary slip for ${salary.employeeName} downloaded.')))),
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showSalaryDialog(context, salary: salary)),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final confirmed = await showDeleteConfirmationDialog(
                                  context,
                                  title: 'Delete salary record?',
                                  message: 'This will remove the ${salary.month} salary record for ${salary.employeeName}.',
                                );
                                if (confirmed) setState(() => _salaryRecords.removeAt(index));
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

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showStaffDialog(BuildContext context, {StaffRecord? staff}) {
    final nameController = TextEditingController(text: staff?.name ?? '');
    final employeeIdController = TextEditingController(text: staff?.employeeId ?? '');
    final designationController = TextEditingController(text: staff?.designation ?? '');
    final departmentController = TextEditingController(text: staff?.department ?? '');
    final qualificationController = TextEditingController(text: staff?.qualification ?? '');
    final joiningDateController = TextEditingController(text: staff?.joiningDate ?? '');
    final salaryController = TextEditingController(text: staff?.salary ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(staff == null ? 'New Employee' : 'Edit Employee'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: employeeIdController, decoration: const InputDecoration(labelText: 'Employee ID')),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: designationController, decoration: const InputDecoration(labelText: 'Designation')),
              TextField(controller: departmentController, decoration: const InputDecoration(labelText: 'Department')),
              TextField(controller: qualificationController, decoration: const InputDecoration(labelText: 'Qualification')),
              TextField(controller: joiningDateController, decoration: const InputDecoration(labelText: 'Joining Date')),
              TextField(controller: salaryController, decoration: const InputDecoration(labelText: 'Salary')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter employee name.')));
                return;
              }
              setState(() {
                if (staff != null) {
                  staff.name = name;
                  staff.employeeId = employeeIdController.text.trim();
                  staff.designation = designationController.text.trim();
                  staff.department = departmentController.text.trim();
                  staff.qualification = qualificationController.text.trim();
                  staff.joiningDate = joiningDateController.text.trim();
                  staff.salary = salaryController.text.trim();
                } else {
                  _staff.add(StaffRecord(
                    id: _staff.isEmpty ? 1 : _staff.last.id + 1,
                    employeeId: employeeIdController.text.trim(),
                    name: name,
                    designation: designationController.text.trim(),
                    department: departmentController.text.trim(),
                    qualification: qualificationController.text.trim(),
                    joiningDate: joiningDateController.text.trim(),
                    salary: salaryController.text.trim(),
                  ));
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLeaveDialog(BuildContext context, {LeaveRecord? leave}) {
    String selectedEmployee = leave?.employeeName ?? (_staff.isNotEmpty ? _staff.first.name : '');
    final fromDateController = TextEditingController(text: leave?.fromDate ?? '');
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
                initialValue: selectedEmployee.isNotEmpty ? selectedEmployee : null,
                items: _staff.map((s) => DropdownMenuItem(value: s.name, child: Text(s.name))).toList(),
                decoration: const InputDecoration(labelText: 'Employee'),
                onChanged: (value) => selectedEmployee = value ?? selectedEmployee,
              ),
              DropdownButtonFormField<String>(
                initialValue: leaveType,
                items: ['Casual Leave', 'Sick Leave', 'Earned Leave'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (value) => leaveType = value ?? leaveType,
                decoration: const InputDecoration(labelText: 'Leave Type'),
              ),
              TextField(controller: fromDateController, decoration: const InputDecoration(labelText: 'From Date')),
              TextField(controller: toDateController, decoration: const InputDecoration(labelText: 'To Date')),
              TextField(controller: reasonController, decoration: const InputDecoration(labelText: 'Reason')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (fromDateController.text.isEmpty || toDateController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter dates.')));
                return;
              }
              setState(() {
                if (leave == null) {
                  _leaves.add(LeaveRecord(
                    id: _leaves.isEmpty ? 1 : _leaves.last.id + 1,
                    employeeName: selectedEmployee,
                    leaveType: leaveType,
                    fromDate: fromDateController.text.trim(),
                    toDate: toDateController.text.trim(),
                    reason: reasonController.text.trim(),
                  ));
                } else {
                  leave
                    ..employeeName = selectedEmployee
                    ..leaveType = leaveType
                    ..fromDate = fromDateController.text.trim()
                    ..toDate = toDateController.text.trim()
                    ..reason = reasonController.text.trim();
                }
              });
              Navigator.pop(context);
            },
            child: Text(leave == null ? 'Submit' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _showAttendanceDialog(BuildContext context, {AttendanceRecord? attendance}) {
    String selectedEmployee = attendance?.employeeName ?? (_staff.isNotEmpty ? _staff.first.name : '');
    String status = attendance?.status ?? 'Present';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(attendance == null ? 'Mark Attendance' : 'Edit Attendance'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedEmployee.isNotEmpty ? selectedEmployee : null,
                items: _staff.map((s) => DropdownMenuItem(value: s.name, child: Text(s.name))).toList(),
                decoration: const InputDecoration(labelText: 'Employee'),
                onChanged: (value) => selectedEmployee = value ?? selectedEmployee,
              ),
              DropdownButtonFormField<String>(
                initialValue: status,
                items: ['Present', 'Absent', 'Leave', 'Half Day'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (value) => status = value ?? status,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (attendance == null) {
                  _staffAttendance.add(AttendanceRecord(
                    id: _staffAttendance.isEmpty ? 1 : _staffAttendance.last.id + 1,
                    employeeName: selectedEmployee,
                    date: DateTime.now().toString().split(' ').first,
                    status: status,
                  ));
                } else {
                  attendance
                    ..employeeName = selectedEmployee
                    ..status = status;
                }
              });
              Navigator.pop(context);
            },
            child: Text(attendance == null ? 'Mark' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _showPerformanceDialog(BuildContext context, {PerformanceRecord? performance}) {
    String selectedEmployee = performance?.employeeName ?? (_staff.isNotEmpty ? _staff.first.name : '');
    final commentsController = TextEditingController(text: performance?.comments ?? '');
    final ratingController = TextEditingController(text: performance?.rating ?? '8');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(performance == null ? 'Performance Review' : 'Edit Performance Review'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedEmployee.isNotEmpty ? selectedEmployee : null,
                items: _staff.map((s) => DropdownMenuItem(value: s.name, child: Text(s.name))).toList(),
                decoration: const InputDecoration(labelText: 'Employee'),
                onChanged: (value) => selectedEmployee = value ?? selectedEmployee,
              ),
              TextField(
                controller: ratingController,
                decoration: const InputDecoration(labelText: 'Rating (1-10)'),
                keyboardType: TextInputType.number,
              ),
              TextField(controller: commentsController, decoration: const InputDecoration(labelText: 'Comments')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final rating = int.tryParse(ratingController.text);
              if (rating == null || rating < 1 || rating > 10) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rating must be between 1 and 10.')));
                return;
              }
              setState(() {
                if (performance == null) {
                  _performance.add(PerformanceRecord(
                    id: _performance.isEmpty ? 1 : _performance.last.id + 1,
                    employeeName: selectedEmployee,
                    rating: rating.toString(),
                    comments: commentsController.text.trim(),
                    reviewDate: DateTime.now().toString().split(' ').first,
                  ));
                } else {
                  performance
                    ..employeeName = selectedEmployee
                    ..rating = rating.toString()
                    ..comments = commentsController.text.trim();
                }
              });
              Navigator.pop(context);
            },
            child: Text(performance == null ? 'Submit Review' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _showSalaryDialog(BuildContext context, {SalaryRecord? salary}) {
    String selectedEmployee = salary?.employeeName ?? (_staff.isNotEmpty ? _staff.first.name : '');
    final amountController = TextEditingController(text: salary?.baseSalary ?? '');
    final monthController = TextEditingController(text: salary?.month ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(salary == null ? 'Add Salary Record' : 'Edit Salary Record'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: selectedEmployee.isNotEmpty ? selectedEmployee : null,
              items: _staff.map((item) => DropdownMenuItem(value: item.name, child: Text(item.name))).toList(),
              decoration: const InputDecoration(labelText: 'Employee'),
              onChanged: (value) => selectedEmployee = value ?? selectedEmployee,
            ),
            TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Base Salary')),
            TextField(controller: monthController, decoration: const InputDecoration(labelText: 'Month')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (selectedEmployee.isEmpty || double.tryParse(amountController.text) == null || monthController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Complete all salary fields.')));
                return;
              }
              setState(() {
                if (salary == null) {
                  _salaryRecords.add(SalaryRecord(
                    id: _salaryRecords.isEmpty ? 1 : _salaryRecords.last.id + 1,
                    employeeName: selectedEmployee,
                    baseSalary: amountController.text.trim(),
                    month: monthController.text.trim(),
                  ));
                } else {
                  salary
                    ..employeeName = selectedEmployee
                    ..baseSalary = amountController.text.trim()
                    ..month = monthController.text.trim();
                }
              });
              Navigator.pop(context);
            },
            child: Text(salary == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }
}

class StaffRecord {
  StaffRecord({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.designation,
    required this.department,
    required this.qualification,
    required this.joiningDate,
    required this.salary,
  });

  final int id;
  String employeeId;
  String name;
  String designation;
  String department;
  String qualification;
  String joiningDate;
  String salary;

  Map<String, dynamic> toJson() => {'id': id, 'employeeId': employeeId, 'name': name, 'designation': designation, 'department': department, 'qualification': qualification, 'joiningDate': joiningDate, 'salary': salary};
  factory StaffRecord.fromJson(Map<String, dynamic> json) => StaffRecord(
    id: json['id'] as int, employeeId: json['employeeId'] as String, name: json['name'] as String,
    designation: json['designation'] as String, department: json['department'] as String,
    qualification: json['qualification'] as String, joiningDate: json['joiningDate'] as String, salary: json['salary'] as String,
  );
}

class LeaveRecord {
  LeaveRecord({required this.id, required this.employeeName, required this.leaveType, required this.fromDate, required this.toDate, required this.reason});
  final int id;
  String employeeName;
  String leaveType;
  String fromDate;
  String toDate;
  String reason;

  Map<String, dynamic> toJson() => {'id': id, 'employeeName': employeeName, 'leaveType': leaveType, 'fromDate': fromDate, 'toDate': toDate, 'reason': reason};
  factory LeaveRecord.fromJson(Map<String, dynamic> json) => LeaveRecord(
    id: json['id'] as int, employeeName: json['employeeName'] as String, leaveType: json['leaveType'] as String,
    fromDate: json['fromDate'] as String, toDate: json['toDate'] as String, reason: json['reason'] as String,
  );
}

class AttendanceRecord {
  AttendanceRecord({required this.id, required this.employeeName, required this.date, required this.status});
  final int id;
  String employeeName;
  final String date;
  String status;

  Map<String, dynamic> toJson() => {'id': id, 'employeeName': employeeName, 'date': date, 'status': status};
  factory AttendanceRecord.fromJson(Map<String, dynamic> json) => AttendanceRecord(
    id: json['id'] as int, employeeName: json['employeeName'] as String, date: json['date'] as String, status: json['status'] as String,
  );
}

class PerformanceRecord {
  PerformanceRecord({required this.id, required this.employeeName, required this.rating, required this.comments, required this.reviewDate});
  final int id;
  String employeeName;
  String rating;
  String comments;
  final String reviewDate;

  Map<String, dynamic> toJson() => {'id': id, 'employeeName': employeeName, 'rating': rating, 'comments': comments, 'reviewDate': reviewDate};
  factory PerformanceRecord.fromJson(Map<String, dynamic> json) => PerformanceRecord(
    id: json['id'] as int, employeeName: json['employeeName'] as String, rating: json['rating'] as String,
    comments: json['comments'] as String, reviewDate: json['reviewDate'] as String,
  );
}

class SalaryRecord {
  SalaryRecord({required this.id, required this.employeeName, required this.baseSalary, required this.month});
  final int id;
  String employeeName;
  String baseSalary;
  String month;

  Map<String, dynamic> toJson() => {'id': id, 'employeeName': employeeName, 'baseSalary': baseSalary, 'month': month};
  factory SalaryRecord.fromJson(Map<String, dynamic> json) => SalaryRecord(
    id: json['id'] as int, employeeName: json['employeeName'] as String, baseSalary: json['baseSalary'] as String, month: json['month'] as String,
  );
}
