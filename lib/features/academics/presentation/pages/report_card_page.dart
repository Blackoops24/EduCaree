import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportCardPage extends ConsumerWidget {
  final int studentId;
  final int classId;

  const ReportCardPage({super.key, required this.studentId, required this.classId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Card'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {},
            tooltip: 'Download PDF',
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {},
            tooltip: 'Print',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Student Report Card',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Student Name'),
                      subtitle: Text('Roll No: 001'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.school),
                      title: Text('Class'),
                      subtitle: Text('10-A'),
                    ),
                    const SizedBox(height: 16),
                    const Text('Performance Summary', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const ListTile(
                      title: Text('GPA'),
                      trailing: Text('3.8'),
                    ),
                    const ListTile(
                      title: Text('CGPA'),
                      trailing: Text('3.75'),
                    ),
                    const ListTile(
                      title: Text('Overall Grade'),
                      trailing: Text('A+'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
