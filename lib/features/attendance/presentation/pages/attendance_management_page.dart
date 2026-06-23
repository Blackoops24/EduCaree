import 'package:flutter/material.dart';

class AttendanceManagementPage extends StatefulWidget {
  const AttendanceManagementPage({super.key});

  @override
  State<AttendanceManagementPage> createState() => _AttendanceManagementPageState();
}

class _AttendanceManagementPageState extends State<AttendanceManagementPage> {
  final List<StudentAttendanceRecord> _studentAttendance = [];
  final List<StaffAttendanceRecord> _staffAttendance = [];
  final List<BiometricDevice> _biometricDevices = [
    BiometricDevice(id: 1, deviceName: 'Device 1', type: 'ZKTeco', status: 'Connected', location: 'Main Gate'),
    BiometricDevice(id: 2, deviceName: 'Device 2', type: 'eSSL', status: 'Offline', location: 'Admin Block'),
  ];
  final List<FaceRecognitionRecord> _faceRecords = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Attendance Management'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Student Attendance'),
              Tab(text: 'Staff Attendance'),
              Tab(text: 'Biometric'),
              Tab(text: 'Face Recognition'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildStudentAttendanceTab(context),
            _buildStaffAttendanceTab(context),
            _buildBiometricTab(context),
            _buildFaceRecognitionTab(context),
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

  Widget _buildStudentAttendanceTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Student Attendance', 'Mark daily and monthly attendance.', action: () => _showStudentAttendanceDialog(context), actionLabel: 'Mark Attendance'),
        Expanded(
          child: _studentAttendance.isEmpty
              ? const Center(child: Text('No attendance records.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _studentAttendance.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final record = _studentAttendance[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(record.studentName),
                        subtitle: Text('${record.date} • ${record.status} • ${record.className}'),
                        trailing: Icon(
                          record.status == 'Present' ? Icons.check_circle : Icons.cancel,
                          color: record.status == 'Present' ? Colors.green : Colors.red,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStaffAttendanceTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Staff Attendance', 'Track staff attendance records.', action: () => _showStaffAttendanceDialog(context), actionLabel: 'Mark Attendance'),
        Expanded(
          child: _staffAttendance.isEmpty
              ? const Center(child: Text('No staff attendance records.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _staffAttendance.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final record = _staffAttendance[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(record.employeeName),
                        subtitle: Text('${record.date} • ${record.status} • Check-in: ${record.checkIn}'),
                        trailing: Icon(
                          record.status == 'Present' ? Icons.check_circle : Icons.cancel,
                          color: record.status == 'Present' ? Colors.green : Colors.red,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildBiometricTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Biometric Devices', 'Manage biometric attendance integration.', action: () => _showBiometricDialog(context), actionLabel: 'Add Device'),
        Expanded(
          child: _biometricDevices.isEmpty
              ? const Center(child: Text('No biometric devices configured.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _biometricDevices.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final device = _biometricDevices[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(device.deviceName),
                        subtitle: Text('Type: ${device.type} • Location: ${device.location}'),
                        trailing: Chip(
                          label: Text(device.status),
                          backgroundColor: device.status == 'Connected' ? Colors.green[100] : Colors.red[100],
                          labelStyle: TextStyle(
                            color: device.status == 'Connected' ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Supported Devices', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('• ZKTeco - UV Face Recognition terminals'),
                  Text('• eSSL - Smart card based attendance systems'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFaceRecognitionTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Face Recognition', 'AI-powered attendance tracking.', action: () => _showFaceRecognitionDialog(context), actionLabel: 'New Record'),
        Expanded(
          child: _faceRecords.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.face, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No face recognition records.'),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _faceRecords.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final record = _faceRecords[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(record.personName),
                        subtitle: Text('${record.timestamp} • Confidence: ${record.confidence}%'),
                        trailing: Icon(Icons.face_retouching_natural, color: Colors.blue),
                      ),
                    );
                  },
                ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('System Status', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('• Camera: Integrated'),
                  Text('• Face Detection: Active'),
                  Text('• Processing: Real-time'),
                  SizedBox(height: 8),
                  Text('Note: Mock implementation for demonstration.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showStudentAttendanceDialog(BuildContext context) {
    final studentNameController = TextEditingController();
    final classController = TextEditingController();
    String status = 'Present';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark Student Attendance'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: studentNameController, decoration: const InputDecoration(labelText: 'Student Name')),
              TextField(controller: classController, decoration: const InputDecoration(labelText: 'Class')),
              DropdownButtonFormField<String>(
                value: status,
                items: ['Present', 'Absent', 'Leave', 'Late'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
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
              final name = studentNameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter student name.')));
                return;
              }
              setState(() {
                _studentAttendance.add(StudentAttendanceRecord(
                  id: _studentAttendance.isEmpty ? 1 : _studentAttendance.last.id + 1,
                  studentName: name,
                  className: classController.text.trim(),
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

  void _showStaffAttendanceDialog(BuildContext context) {
    final employeeNameController = TextEditingController();
    final checkInController = TextEditingController();
    String status = 'Present';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark Staff Attendance'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: employeeNameController, decoration: const InputDecoration(labelText: 'Employee Name')),
              TextField(controller: checkInController, decoration: const InputDecoration(labelText: 'Check-in Time')),
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
              final name = employeeNameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter employee name.')));
                return;
              }
              setState(() {
                _staffAttendance.add(StaffAttendanceRecord(
                  id: _staffAttendance.isEmpty ? 1 : _staffAttendance.last.id + 1,
                  employeeName: name,
                  date: DateTime.now().toString().split(' ').first,
                  status: status,
                  checkIn: checkInController.text.trim(),
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

  void _showBiometricDialog(BuildContext context) {
    final deviceNameController = TextEditingController();
    final locationController = TextEditingController();
    String deviceType = 'ZKTeco';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Biometric Device'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: deviceNameController, decoration: const InputDecoration(labelText: 'Device Name')),
              DropdownButtonFormField<String>(
                value: deviceType,
                items: ['ZKTeco', 'eSSL'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (value) => deviceType = value ?? deviceType,
                decoration: const InputDecoration(labelText: 'Device Type'),
              ),
              TextField(controller: locationController, decoration: const InputDecoration(labelText: 'Location')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = deviceNameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter device name.')));
                return;
              }
              setState(() {
                _biometricDevices.add(BiometricDevice(
                  id: _biometricDevices.isEmpty ? 1 : _biometricDevices.last.id + 1,
                  deviceName: name,
                  type: deviceType,
                  status: 'Offline',
                  location: locationController.text.trim(),
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showFaceRecognitionDialog(BuildContext context) {
    final personNameController = TextEditingController();
    final confidenceController = TextEditingController(text: '95');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Face Recognition Record'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: personNameController, decoration: const InputDecoration(labelText: 'Person Name')),
              TextField(controller: confidenceController, decoration: const InputDecoration(labelText: 'Confidence %'), keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Camera Input', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Icon(Icons.videocam, size: 48),
                  SizedBox(height: 8),
                  Text('Camera stream placeholder', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = personNameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter person name.')));
                return;
              }
              setState(() {
                _faceRecords.add(FaceRecognitionRecord(
                  id: _faceRecords.isEmpty ? 1 : _faceRecords.last.id + 1,
                  personName: name,
                  timestamp: DateTime.now().toString(),
                  confidence: confidenceController.text.trim(),
                ));
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Face record for $name added.')));
              Navigator.pop(context);
            },
            child: const Text('Record'),
          ),
        ],
      ),
    );
  }
}

class StudentAttendanceRecord {
  StudentAttendanceRecord({required this.id, required this.studentName, required this.className, required this.date, required this.status});
  final int id;
  final String studentName;
  final String className;
  final String date;
  final String status;
}

class StaffAttendanceRecord {
  StaffAttendanceRecord({required this.id, required this.employeeName, required this.date, required this.status, required this.checkIn});
  final int id;
  final String employeeName;
  final String date;
  final String status;
  final String checkIn;
}

class BiometricDevice {
  BiometricDevice({required this.id, required this.deviceName, required this.type, required this.status, required this.location});
  final int id;
  final String deviceName;
  final String type;
  final String status;
  final String location;
}

class FaceRecognitionRecord {
  FaceRecognitionRecord({required this.id, required this.personName, required this.timestamp, required this.confidence});
  final int id;
  final String personName;
  final String timestamp;
  final String confidence;
}
