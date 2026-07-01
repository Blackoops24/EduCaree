import 'package:flutter/material.dart';
import 'package:educare/core/widgets/form_validation.dart';
import 'package:educare/core/widgets/persistent_module_state.dart';

class StudentDailyAttendancePage extends StatefulWidget {
  const StudentDailyAttendancePage({super.key});

  @override
  State<StudentDailyAttendancePage> createState() =>
      _StudentDailyAttendancePageState();
}

class _StudentDailyAttendancePageState
    extends PersistentModuleState<StudentDailyAttendancePage> {
  final _classController = TextEditingController();
  DateTime _date = DateTime.now();
  final List<StudentAttendanceEntry> _records = [];

  @override
  String get moduleKey => 'student-daily-attendance';
  @override
  Map<String, dynamic> exportState() => {
    'className': _classController.text,
    'date': _date.toIso8601String(),
    'records': _records.map((item) => item.toJson()).toList(),
  };
  @override
  void importState(Map<String, dynamic> data) {
    _classController.text = data['className'] as String? ?? '';
    _date = DateTime.tryParse(data['date'] as String? ?? '') ?? DateTime.now();
    _records
      ..clear()
      ..addAll(
        (data['records'] as List? ?? []).map(
          (item) => StudentAttendanceEntry.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        ),
      );
  }

  @override
  void dispose() {
    _classController.dispose();
    super.dispose();
  }

  void _addRecord({StudentAttendanceEntry? record}) {
    final nameController = TextEditingController(text: record?.student ?? '');
    String status = record?.status ?? 'Present';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(record == null ? 'Add Attendance' : 'Edit Attendance'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Student Name'),
            ),
            DropdownButtonFormField<String>(
              initialValue: status,
              items: ['Present', 'Absent', 'Leave']
                  .map(
                    (value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
              onChanged: (value) => status = value ?? status,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                focusAndRevealController(context, nameController);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Student name is required.')),
                );
                return;
              }
              setState(() {
                if (record == null) {
                  _records.add(
                    StudentAttendanceEntry(
                      student: nameController.text.trim(),
                      status: status,
                    ),
                  );
                } else {
                  record
                    ..student = nameController.text.trim()
                    ..status = status;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Attendance')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _classController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Class',
              prefixIcon: Icon(Icons.school),
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            title: const Text('Attendance Date'),
            subtitle: Text(_date.toString().split(' ').first),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final selected = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (selected != null) setState(() => _date = selected);
            },
          ),
          ElevatedButton.icon(
            onPressed: _classController.text.trim().isEmpty
                ? null
                : () => _addRecord(),
            icon: const Icon(Icons.add),
            label: const Text('Add Attendance'),
          ),
          const SizedBox(height: 16),
          ...List.generate(_records.length, (index) {
            final record = _records[index];
            return Card(
              child: ListTile(
                title: Text(record.student),
                subtitle: Text(record.status),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _addRecord(record: record),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => setState(() => _records.removeAt(index)),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class StudentAttendanceEntry {
  StudentAttendanceEntry({required this.student, required this.status});

  String student;
  String status;
  Map<String, dynamic> toJson() => {'student': student, 'status': status};
  factory StudentAttendanceEntry.fromJson(Map<String, dynamic> json) =>
      StudentAttendanceEntry(
        student: json['student'] as String,
        status: json['status'] as String,
      );
}
