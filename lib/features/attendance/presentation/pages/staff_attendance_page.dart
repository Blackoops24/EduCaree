import 'package:flutter/material.dart';
import 'package:educare/core/widgets/persistent_module_state.dart';

class StaffAttendancePage extends StatefulWidget {
  const StaffAttendancePage({super.key});

  @override
  State<StaffAttendancePage> createState() => _StaffAttendancePageState();
}

class _StaffAttendancePageState extends PersistentModuleState<StaffAttendancePage> {
  DateTime? _checkIn;
  DateTime? _checkOut;

  @override
  String get moduleKey => 'staff-daily-attendance';
  @override
  Map<String, dynamic> exportState() => {'checkIn': _checkIn?.toIso8601String(), 'checkOut': _checkOut?.toIso8601String()};
  @override
  void importState(Map<String, dynamic> data) {
    _checkIn = DateTime.tryParse(data['checkIn'] as String? ?? '');
    _checkOut = DateTime.tryParse(data['checkOut'] as String? ?? '');
  }

  String _time(DateTime? value) => value == null ? '--:--' : TimeOfDay.fromDateTime(value).format(context);

  @override
  Widget build(BuildContext context) {
    final hours = _checkIn != null && _checkOut != null ? _checkOut!.difference(_checkIn!).inMinutes / 60 : null;
    return Scaffold(
      appBar: AppBar(title: const Text('Staff Attendance')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Daily Staff Attendance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: ElevatedButton.icon(onPressed: _checkIn == null ? () => setState(() => _checkIn = DateTime.now()) : null, icon: const Icon(Icons.login), label: const Text('Check In'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton.icon(onPressed: _checkIn != null && _checkOut == null ? () => setState(() => _checkOut = DateTime.now()) : null, icon: const Icon(Icons.logout), label: const Text('Check Out'))),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                ListTile(title: const Text('Check In Time'), trailing: Text(_time(_checkIn))),
                ListTile(title: const Text('Check Out Time'), trailing: Text(_time(_checkOut))),
                ListTile(title: const Text('Work Hours'), trailing: Text(hours == null ? '-- hrs' : '${hours.toStringAsFixed(2)} hrs')),
                if (_checkIn != null)
                  TextButton(onPressed: () => setState(() { _checkIn = null; _checkOut = null; }), child: const Text('Clear Record')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
