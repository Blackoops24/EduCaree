import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educare/core/services/module_persistence_service.dart';

class FaceRecognitionPage extends ConsumerStatefulWidget {
  const FaceRecognitionPage({super.key});

  @override
  ConsumerState<FaceRecognitionPage> createState() => _FaceRecognitionPageState();
}

class _FaceRecognitionPageState extends ConsumerState<FaceRecognitionPage> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    ModulePersistenceService.instance.load('face-recognition-device').then((data) {
      if (mounted && data != null) setState(() => _initialized = data['initialized'] as bool? ?? false);
    }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Recognition Attendance'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Face Recognition System',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.videocam, size: 60, color: Colors.grey[600]),
                          const SizedBox(height: 12),
                          Text('Camera Feed', style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() => _initialized = true);
                        ModulePersistenceService.instance.save('face-recognition-device', {'initialized': true}).catchError((_) {});
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: Text(_initialized ? 'Camera Initialized' : 'Initialize Camera'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Recognition Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const ListTile(
                      title: Text('Last Recognition'),
                      trailing: Text('--'),
                    ),
                    const Divider(),
                    const ListTile(
                      title: Text('Confidence Score'),
                      trailing: Text('0%'),
                    ),
                    const Divider(),
                    ListTile(
                      title: Text('Status'),
                      trailing: Chip(label: Text(_initialized ? 'Ready' : 'Idle')),
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
