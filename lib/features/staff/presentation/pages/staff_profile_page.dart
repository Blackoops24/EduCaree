import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educare/core/providers.dart';
import 'package:educare/features/staff/presentation/keys/staff_keys.dart';

class StaffProfilePage extends ConsumerStatefulWidget {
  final int staffId;

  const StaffProfilePage({super.key, required this.staffId});

  @override
  ConsumerState<StaffProfilePage> createState() => _StaffProfilePageState();
}

class _StaffProfilePageState extends ConsumerState<StaffProfilePage> {
  @override
  void initState() {
    super.initState();
    ref.read(staffViewModelProvider.notifier).loadStaffProfile(widget.staffId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffViewModelProvider);

    return Scaffold(
      key: StaffKeys.profilePage,
      appBar: AppBar(title: const Text('Staff Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: state.loading
            ? const Center(child: CircularProgressIndicator())
            : state.selectedStaff == null
                ? state.error != null
                    ? Center(child: Text(state.error!))
                    : const Center(child: Text('Select a staff member to view details.'))
                : Card(
                    key: StaffKeys.staffInfoCard,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(state.selectedStaff!.name, style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 8),
                          Text('Employee ID: ${state.selectedStaff!.employeeId}'),
                          Text('Designation: ${state.selectedStaff!.designation}'),
                          Text('Department: ${state.selectedStaff!.department}'),
                          Text('Qualification: ${state.selectedStaff!.qualification}'),
                          Text('Joining Date: ${state.selectedStaff!.joiningDate}'),
                          Text('Salary: ${state.selectedStaff!.salary.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
