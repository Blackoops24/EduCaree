import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educare/core/providers.dart';
import 'package:educare/features/staff/presentation/keys/staff_keys.dart';

class LeaveManagementPage extends ConsumerStatefulWidget {
  final int staffId;

  const LeaveManagementPage({super.key, required this.staffId});

  @override
  ConsumerState<LeaveManagementPage> createState() => _LeaveManagementPageState();
}

class _LeaveManagementPageState extends ConsumerState<LeaveManagementPage> {
  @override
  void initState() {
    super.initState();
    ref.read(staffViewModelProvider.notifier).loadLeaveRequests(widget.staffId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffViewModelProvider);

    return Scaffold(
      key: StaffKeys.leavePage,
      appBar: AppBar(title: const Text('Leave Management')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: state.loading
            ? const Center(child: CircularProgressIndicator())
            : state.error != null
                ? Center(child: Text(state.error!))
                : ListView.separated(
                    key: StaffKeys.leaveListView,
                    itemCount: state.leaveRequests.length,
                    itemBuilder: (context, index) {
                      final leave = state.leaveRequests[index];
                      return ListTile(
                        title: Text('${leave.startDate} → ${leave.endDate}'),
                        subtitle: Text(leave.reason),
                        trailing: Text(leave.status),
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(),
                  ),
      ),
    );
  }
}
