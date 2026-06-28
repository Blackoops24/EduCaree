import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educare/core/services/module_persistence_service.dart';

class BiometricIntegrationPage extends ConsumerStatefulWidget {
  const BiometricIntegrationPage({super.key});

  @override
  ConsumerState<BiometricIntegrationPage> createState() => _BiometricIntegrationPageState();
}

class _BiometricIntegrationPageState extends ConsumerState<BiometricIntegrationPage> {
  final Set<String> _syncedDevices = {};

  @override
  void initState() {
    super.initState();
    ModulePersistenceService.instance.load('biometric-sync').then((data) {
      if (mounted && data != null) setState(() => _syncedDevices.addAll(List<String>.from(data['devices'] as List? ?? [])));
    }).catchError((_) {});
  }

  void _sync(String device) {
    setState(() => _syncedDevices.add(device));
    ModulePersistenceService.instance.save('biometric-sync', {'devices': _syncedDevices.toList()}).catchError((_) {});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$device synced successfully.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometric Integration'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Biometric Devices',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.fingerprint, color: Colors.blue),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ZKTeco Device', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('Main Entrance', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                        Chip(label: Text('Active', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => _sync('ZKTeco Device'),
                      icon: const Icon(Icons.sync),
                      label: Text(_syncedDevices.contains('ZKTeco Device') ? 'Synced' : 'Sync Device'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.fingerprint, color: Colors.blue),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('eSSL Device', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('Staff Room', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                        Chip(label: Text('Active', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => _sync('eSSL Device'),
                      icon: const Icon(Icons.sync),
                      label: Text(_syncedDevices.contains('eSSL Device') ? 'Synced' : 'Sync Device'),
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
