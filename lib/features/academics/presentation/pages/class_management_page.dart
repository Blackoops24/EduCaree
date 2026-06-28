import 'package:flutter/material.dart';
import 'package:educare/core/widgets/persistent_module_state.dart';

class ClassManagementPage extends StatefulWidget {
  const ClassManagementPage({super.key});

  @override
  State<ClassManagementPage> createState() => _ClassManagementPageState();
}

class _ClassManagementPageState extends PersistentModuleState<ClassManagementPage> {
  final List<String> _classes = [];

  @override
  String get moduleKey => 'standalone-classes';
  @override
  Map<String, dynamic> exportState() => {'classes': _classes};
  @override
  void importState(Map<String, dynamic> data) => _classes
    ..clear()
    ..addAll(List<String>.from(data['classes'] as List? ?? []));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Class Management')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(child: Text('Classes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                ElevatedButton.icon(onPressed: () => _showClassDialog(context), label: const Text('Create'), icon: const Icon(Icons.add)),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _classes.isEmpty
                  ? const Center(child: Text('No classes available. Create a new class to get started.'))
                  : ListView.builder(
                      itemCount: _classes.length,
                      itemBuilder: (context, index) => Card(
                        child: ListTile(
                          title: Text(_classes[index]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(icon: const Icon(Icons.edit), onPressed: () => _showClassDialog(context, index: index)),
                              IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _classes.removeAt(index))),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClassDialog(BuildContext context, {int? index}) {
    final controller = TextEditingController(text: index == null ? '' : _classes[index]);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? 'Create Class' : 'Edit Class'),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Class Name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.isEmpty) return;
              setState(() => index == null ? _classes.add(value) : _classes[index] = value);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
