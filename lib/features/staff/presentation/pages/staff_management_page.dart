import 'package:flutter/material.dart';

class StaffManagementPage extends StatefulWidget {
  const StaffManagementPage({super.key});

  @override
  State<StaffManagementPage> createState() => _StaffManagementPageState();
}

class _StaffManagementPageState extends State<StaffManagementPage> {
  final List<StaffRecord> _staff = [
    StaffRecord(id: 1, employeeId: 'EMP-001', name: 'Rajesh Kumar', designation: 'Principal', department: 'Administration', qualification: 'M.A., B.Ed', joiningDate: '2015-08-01', salary: '150000'),
    StaffRecord(id: 2, employeeId: 'EMP-002', name: 'Priya Singh', designation: 'Mathematics Teacher', department: 'Academics', qualification: 'M.Sc, B.Ed', joiningDate: '2018-06-15', salary: '45000'),
  ];

  final List<LeaveRecord> _leaves = [];
  final List<AttendanceRecord> _staffAttendance = [];
  final List<PerformanceRecord> _performance = [];
  final List<SalaryRecord> _salaryRecords = [];

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
                            IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _staff.removeAt(index))),
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
                        trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _leaves.removeAt(index))),
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
                        trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _staffAttendance.removeAt(index))),
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
                        trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _performance.removeAt(index))),
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
        _buildSectionHeader('Salary Details', 'View and manage salary information.'),
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
                        trailing: IconButton(icon: const Icon(Icons.download), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Salary slip for ${salary.employeeName} downloaded.')))),
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

  void _showLeaveDialog(BuildContext context) {
    String selectedEmployee = _staff.isNotEmpty ? _staff.first.name : '';
    final fromDateController = TextEditingController();
    final toDateController = TextEditingController();
    final reasonController = TextEditingController();
    String leaveType = 'Casual Leave';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Leave Request'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedEmployee.isNotEmpty ? selectedEmployee : null,
                items: _staff.map((s) => DropdownMenuItem(value: s.name, child: Text(s.name))).toList(),
                decoration: const InputDecoration(labelText: 'Employee'),
                onChanged: (value) => selectedEmployee = value ?? selectedEmployee,
              ),
              DropdownButtonFormField<String>(
                value: leaveType,
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
                _leaves.add(LeaveRecord(
                  id: _leaves.isEmpty ? 1 : _leaves.last.id + 1,
                  employeeName: selectedEmployee,
                  leaveType: leaveType,
                  fromDate: fromDateController.text.trim(),
                  toDate: toDateController.text.trim(),
                  reason: reasonController.text.trim(),
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showAttendanceDialog(BuildContext context) {
    String selectedEmployee = _staff.isNotEmpty ? _staff.first.name : '';
    String status = 'Present';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark Attendance'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedEmployee.isNotEmpty ? selectedEmployee : null,
                items: _staff.map((s) => DropdownMenuItem(value: s.name, child: Text(s.name))).toList(),
                decoration: const InputDecoration(labelText: 'Employee'),
                onChanged: (value) => selectedEmployee = value ?? selectedEmployee,
              ),
              DropdownButtonFormField<String>(
                value: status,
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
                _staffAttendance.add(AttendanceRecord(
                  id: _staffAttendance.isEmpty ? 1 : _staffAttendance.last.id + 1,
                  employeeName: selectedEmployee,
                  date: DateTime.now().toString().split(' ').first,
                  status: status,
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('Mark'),
          ),
        ],
      ),
    );
  }

  void _showPerformanceDialog(BuildContext context) {
    String selectedEmployee = _staff.isNotEmpty ? _staff.first.name : '';
    final commentsController = TextEditingController();
    final ratingController = TextEditingController(text: '8');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Performance Review'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedEmployee.isNotEmpty ? selectedEmployee : null,
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
              setState(() {
                _performance.add(PerformanceRecord(
                  id: _performance.isEmpty ? 1 : _performance.last.id + 1,
                  employeeName: selectedEmployee,
                  rating: ratingController.text.trim(),
                  comments: commentsController.text.trim(),
                  reviewDate: DateTime.now().toString().split(' ').first,
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('Submit Review'),
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
}

class LeaveRecord {
  LeaveRecord({required this.id, required this.employeeName, required this.leaveType, required this.fromDate, required this.toDate, required this.reason});
  final int id;
  final String employeeName;
  final String leaveType;
  final String fromDate;
  final String toDate;
  final String reason;
}

class AttendanceRecord {
  AttendanceRecord({required this.id, required this.employeeName, required this.date, required this.status});
  final int id;
  final String employeeName;
  final String date;
  final String status;
}

class PerformanceRecord {
  PerformanceRecord({required this.id, required this.employeeName, required this.rating, required this.comments, required this.reviewDate});
  final int id;
  final String employeeName;
  final String rating;
  final String comments;
  final String reviewDate;
}

class SalaryRecord {
  SalaryRecord({required this.id, required this.employeeName, required this.baseSalary, required this.month});
  final int id;
  final String employeeName;
  final String baseSalary;
  final String month;
}
