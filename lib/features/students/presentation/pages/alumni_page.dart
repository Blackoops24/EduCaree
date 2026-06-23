import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educare/core/providers.dart';
import 'package:educare/features/students/presentation/keys/student_keys.dart';

class AlumniPage extends ConsumerStatefulWidget {
  const AlumniPage({super.key});

  @override
  ConsumerState<AlumniPage> createState() => _AlumniPageState();
}

class _AlumniPageState extends ConsumerState<AlumniPage> {
  @override
  void initState() {
    super.initState();
    ref.read(studentViewModelProvider.notifier).loadAlumni();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(studentViewModelProvider);

    return Scaffold(
      key: StudentKeys.alumniPage,
      appBar: AppBar(title: const Text('Alumni')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: state.loading
            ? const Center(child: CircularProgressIndicator())
            : state.error != null
                ? Center(child: Text(state.error!))
                : ListView.separated(
                    key: StudentKeys.alumniListView,
                    itemCount: state.alumni.length,
                    itemBuilder: (context, index) {
                      final alumni = state.alumni[index];
                      return ListTile(
                        key: Key('alumniTile_${alumni.id}'),
                        title: Text(alumni.name),
                        subtitle: Text('${alumni.course} • ${alumni.passedOutYear}'),
                        trailing: Text(alumni.email),
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(),
                  ),
      ),
    );
  }
}
