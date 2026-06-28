import 'package:educare/core/providers.dart';
import 'package:educare/core/services/module_persistence_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({required this.showSettings, super.key});

  final bool showSettings;

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late bool _settingsSelected;
  bool _emailNotifications = true;
  bool _desktopNotifications = true;
  bool _compactTables = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authViewModelProvider).user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _settingsSelected = widget.showSettings;
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final data = await ModulePersistenceService.instance.load('account-settings');
      if (data == null || !mounted) return;
      setState(() {
        _emailNotifications = data['emailNotifications'] as bool? ?? true;
        _desktopNotifications = data['desktopNotifications'] as bool? ?? true;
        _compactTables = data['compactTables'] as bool? ?? false;
      });
    } catch (_) {}
  }

  Future<void> _saveSettings() async {
    await ModulePersistenceService.instance.save('account-settings', {
      'emailNotifications': _emailNotifications,
      'desktopNotifications': _desktopNotifications,
      'compactTables': _compactTables,
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_settingsSelected ? 'Settings' : 'My Profile')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: false, icon: Icon(Icons.person_outline), label: Text('My Profile')),
                  ButtonSegment(value: true, icon: Icon(Icons.settings_outlined), label: Text('Settings')),
                ],
                selected: {_settingsSelected},
                onSelectionChanged: (value) => setState(() => _settingsSelected = value.single),
              ),
              const SizedBox(height: 24),
              if (_settingsSelected) _buildSettings(context) else _buildProfile(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfile(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CircleAvatar(radius: 42, child: Icon(Icons.person_outline, size: 42)),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Display Name'),
                validator: (value) => value == null || value.trim().isEmpty ? 'Enter a display name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value ?? '')
                    ? null
                    : 'Enter a valid email address',
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (!(_formKey.currentState?.validate() ?? false)) return;
                    await ref.read(authViewModelProvider.notifier).updateProfile(
                          name: _nameController.text.trim(),
                          email: _emailController.text.trim(),
                        );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved.')));
                  },
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettings(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Email notifications'),
            subtitle: const Text('Receive important school updates by email.'),
            value: _emailNotifications,
            onChanged: (value) => setState(() => _emailNotifications = value),
          ),
          SwitchListTile(
            title: const Text('Desktop notifications'),
            subtitle: const Text('Show notifications while EduCare is open.'),
            value: _desktopNotifications,
            onChanged: (value) => setState(() => _desktopNotifications = value),
          ),
          SwitchListTile(
            title: const Text('Compact tables'),
            subtitle: const Text('Reduce spacing in data-heavy screens.'),
            value: _compactTables,
            onChanged: (value) => setState(() => _compactTables = value),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await _saveSettings();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings saved.')));
                  } catch (_) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to save settings.')));
                  }
                },
                child: const Text('Save Settings'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
