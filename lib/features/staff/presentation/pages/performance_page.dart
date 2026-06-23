import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educare/core/providers.dart';
import 'package:educare/features/staff/presentation/keys/staff_keys.dart';

class PerformancePage extends ConsumerStatefulWidget {
  final int staffId;

  const PerformancePage({super.key, required this.staffId});

  @override
  ConsumerState<PerformancePage> createState() => _PerformancePageState();
}

class _PerformancePageState extends ConsumerState<PerformancePage> {
  @override
  void initState() {
    super.initState();
    ref.read(staffViewModelProvider.notifier).loadPerformance(widget.staffId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffViewModelProvider);

    return Scaffold(
      key: StaffKeys.performancePage,
      appBar: AppBar(title: const Text('Performance Tracking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: state.loading
            ? const Center(child: CircularProgressIndicator())
            : state.error != null
                ? Center(child: Text(state.error!))
                : ListView.separated(
                    key: StaffKeys.performanceListView,
                    itemCount: state.performance.length,
                    itemBuilder: (context, index) {
                      final review = state.performance[index];
                      return ListTile(
                        title: Text(review.reviewDate),
                        subtitle: Text(review.comments),
                        trailing: Text(review.score),
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(),
                  ),
      ),
    );
  }
}
