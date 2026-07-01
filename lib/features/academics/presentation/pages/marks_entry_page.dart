import 'package:flutter/material.dart';
import 'package:educare/core/widgets/form_validation.dart';
import 'package:educare/core/widgets/persistent_module_state.dart';

class MarksEntryPage extends StatefulWidget {
  const MarksEntryPage({
    super.key,
    required this.examId,
    required this.sectionId,
  });

  final int examId;
  final int sectionId;

  @override
  State<MarksEntryPage> createState() => _MarksEntryPageState();
}

class _MarksEntryPageState extends PersistentModuleState<MarksEntryPage> {
  final _studentController = TextEditingController();
  final _marksController = TextEditingController();
  final List<({String student, int marks})> _records = [];
  int? _editingIndex;

  @override
  String get moduleKey => 'marks-${widget.examId}-${widget.sectionId}';
  @override
  Map<String, dynamic> exportState() => {
    'records': _records
        .map((item) => {'student': item.student, 'marks': item.marks})
        .toList(),
  };
  @override
  void importState(Map<String, dynamic> data) {
    _records
      ..clear()
      ..addAll(
        (data['records'] as List? ?? []).map((item) {
          final map = Map<String, dynamic>.from(item as Map);
          return (
            student: map['student'] as String,
            marks: map['marks'] as int,
          );
        }),
      );
  }

  @override
  void dispose() {
    _studentController.dispose();
    _marksController.dispose();
    super.dispose();
  }

  void _save() {
    final student = _studentController.text.trim();
    final marks = int.tryParse(_marksController.text);
    if (student.isEmpty || marks == null || marks < 0 || marks > 100) {
      focusAndRevealController(
        context,
        student.isEmpty ? _studentController : _marksController,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a student and marks between 0 and 100.'),
        ),
      );
      return;
    }
    setState(() {
      final value = (student: student, marks: marks);
      if (_editingIndex == null) {
        _records.add(value);
      } else {
        _records[_editingIndex!] = value;
      }
      _editingIndex = null;
      _studentController.clear();
      _marksController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marks Entry')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Exam ${widget.examId} • Section ${widget.sectionId}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _studentController,
            decoration: const InputDecoration(labelText: 'Student Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _marksController,
            decoration: const InputDecoration(labelText: 'Obtained Marks'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _save,
            child: Text(_editingIndex == null ? 'Save Marks' : 'Update Marks'),
          ),
          const SizedBox(height: 20),
          ...List.generate(_records.length, (index) {
            final record = _records[index];
            return Card(
              child: ListTile(
                title: Text(record.student),
                subtitle: Text('${record.marks}/100'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => setState(() {
                        _editingIndex = index;
                        _studentController.text = record.student;
                        _marksController.text = record.marks.toString();
                      }),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => setState(() => _records.removeAt(index)),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
