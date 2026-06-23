import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:educare/core/providers.dart';
import 'package:educare/features/students/presentation/keys/student_keys.dart';

class StudentProfilePage extends ConsumerStatefulWidget {
  final int studentId;

  const StudentProfilePage({super.key, required this.studentId});

  @override
  ConsumerState<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends ConsumerState<StudentProfilePage> {
  @override
  void initState() {
    super.initState();
    ref.read(studentViewModelProvider.notifier).loadStudentProfile(widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(studentViewModelProvider);

    return Scaffold(
      key: StudentKeys.studentProfilePage,
      appBar: AppBar(title: const Text('Student Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: state.loading
            ? const Center(child: CircularProgressIndicator())
            : state.selectedStudent == null
                ? state.error != null
                    ? Center(child: Text(state.error!))
                    : const Center(child: Text('Select a student to view profile.'))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        key: StudentKeys.studentInfoCard,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(state.selectedStudent!.fullName, style: Theme.of(context).textTheme.headlineSmall),
                              const SizedBox(height: 8),
                              Text('Email: ${state.selectedStudent!.email}'),
                              Text('Grade: ${state.selectedStudent!.grade}'),
                              Text('Section: ${state.selectedStudent!.section}'),
                              Text('Admission number: ${state.selectedStudent!.admissionNumber}'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          ElevatedButton(
                            key: const Key('studentProfileDocumentsButton'),
                            onPressed: () => context.go('/students/${widget.studentId}/documents'),
                            child: const Text('View Documents'),
                          ),
                          ElevatedButton(
                            key: const Key('studentProfileTransferButton'),
                            onPressed: () => context.go('/students/${widget.studentId}/transfer-certificate'),
                            child: const Text('Request Transfer Certificate'),
                          ),
                        ],
                      ),
                    ],
                  ),
      ),
    );
  }
}
