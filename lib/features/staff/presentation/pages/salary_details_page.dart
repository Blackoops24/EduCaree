import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educare/core/providers.dart';
import 'package:educare/features/staff/presentation/keys/staff_keys.dart';

class SalaryDetailsPage extends ConsumerStatefulWidget {
  final int staffId;

  const SalaryDetailsPage({super.key, required this.staffId});

  @override
  ConsumerState<SalaryDetailsPage> createState() => _SalaryDetailsPageState();
}

class _SalaryDetailsPageState extends ConsumerState<SalaryDetailsPage> {
  @override
  void initState() {
    super.initState();
    ref.read(staffViewModelProvider.notifier).loadSalaryDetails(widget.staffId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffViewModelProvider);

    return Scaffold(
      key: StaffKeys.salaryPage,
      appBar: AppBar(title: const Text('Salary Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: state.loading
            ? const Center(child: CircularProgressIndicator())
            : state.error != null
                ? Center(child: Text(state.error!))
                : state.salaryDetails == null
                    ? const Center(child: Text('No salary details available.'))
                    : Card(
                        key: StaffKeys.salaryInfoCard,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Basic Salary: ${state.salaryDetails!.basicSalary.toStringAsFixed(2)}'),
                              const SizedBox(height: 8),
                              Text('Allowances: ${state.salaryDetails!.allowances.toStringAsFixed(2)}'),
                              const SizedBox(height: 8),
                              Text('Deductions: ${state.salaryDetails!.deductions.toStringAsFixed(2)}'),
                              const SizedBox(height: 8),
                              Text('Net Salary: ${state.salaryDetails!.netSalary.toStringAsFixed(2)}'),
                              const SizedBox(height: 8),
                              Text('Pay Period: ${state.salaryDetails!.payPeriod}'),
                            ],
                          ),
                        ),
                      ),
      ),
    );
  }
}
