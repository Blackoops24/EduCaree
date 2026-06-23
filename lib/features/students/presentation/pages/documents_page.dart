import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educare/core/providers.dart';
import 'package:educare/features/students/presentation/keys/student_keys.dart';

class DocumentsPage extends ConsumerStatefulWidget {
  final int studentId;

  const DocumentsPage({super.key, required this.studentId});

  @override
  ConsumerState<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends ConsumerState<DocumentsPage> {
  @override
  void initState() {
    super.initState();
    ref.read(studentViewModelProvider.notifier).loadDocuments(widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(studentViewModelProvider);

    return Scaffold(
      key: StudentKeys.documentsPage,
      appBar: AppBar(title: const Text('Student Documents')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: state.loading
            ? const Center(child: CircularProgressIndicator())
            : state.error != null
                ? Center(child: Text(state.error!))
                : ListView.separated(
                    key: StudentKeys.documentListView,
                    itemCount: state.documents.length,
                    itemBuilder: (context, index) {
                      final document = state.documents[index];
                      return ListTile(
                        key: Key('documentTile_${document.id}'),
                        title: Text(document.title),
                        subtitle: Text(document.documentType),
                        trailing: const Icon(Icons.download),
                        onTap: () {},
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(),
                  ),
      ),
    );
  }
}
