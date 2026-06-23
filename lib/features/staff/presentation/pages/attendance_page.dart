import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educare/core/providers.dart';
import 'package:educare/features/staff/presentation/keys/staff_keys.dart';

class AttendancePage extends ConsumerStatefulWidget {
  final int staffId;

  const AttendancePage({super.key, required this.staffId});

  @override
  ConsumerState<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends ConsumerState<AttendancePage> {
  @override
  void initState() {
    super.initState();
    ref.read(staffViewModelProvider.notifier).loadAttendance(widget.staffId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffViewModelProvider);

    return Scaffold(
      key: StaffKeys.attendancePage,
      appBar: AppBar(title: const Text('Attendance')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: state.loading
            ? const Center(child: CircularProgressIndicator())
            : state.error != null
                ? Center(child: Text(state.error!))
                : ListView.separated(
                    key: StaffKeys.attendanceListView,
                    itemCount: state.attendance.length,
                    itemBuilder: (context, index) {
                      final record = state.attendance[index];
                      return ListTile(
                        title: Text(record.date),
                        subtitle: Text('Status: ${record.status}'),
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(),
                  ),
      ),
    );
  }
}
