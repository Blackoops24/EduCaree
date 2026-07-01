import 'package:flutter/material.dart';
import 'package:educare/core/widgets/form_validation.dart';
import 'package:educare/core/widgets/persistent_module_state.dart';

class NotificationManagementPage extends StatefulWidget {
  const NotificationManagementPage({super.key});

  @override
  State<NotificationManagementPage> createState() =>
      _NotificationManagementPageState();
}

class _NotificationManagementPageState
    extends PersistentModuleState<NotificationManagementPage> {
  final List<NotificationChannel> _channels = [
    NotificationChannel(
      id: 1,
      name: 'Push Notifications',
      enabled: true,
      description: 'Send app push alerts to parents and students.',
    ),
    NotificationChannel(
      id: 2,
      name: 'Email Notifications',
      enabled: true,
      description: 'Send email notifications for important updates.',
    ),
    NotificationChannel(
      id: 3,
      name: 'SMS Notifications',
      enabled: false,
      description: 'Send short SMS alerts for urgent communications.',
    ),
  ];

  final List<NotificationType> _notificationTypes = [
    NotificationType(
      id: 1,
      name: 'Attendance Alerts',
      description: 'Notify parents about attendance status.',
      enabled: true,
    ),
    NotificationType(
      id: 2,
      name: 'Fee Due Alerts',
      description: 'Send reminders for pending fee payments.',
      enabled: true,
    ),
    NotificationType(
      id: 3,
      name: 'Exam Alerts',
      description: 'Notify students about upcoming exams.',
      enabled: false,
    ),
    NotificationType(
      id: 4,
      name: 'General Announcements',
      description: 'Broadcast school-wide announcements.',
      enabled: true,
    ),
  ];

  final List<ReportItem> _reports = [
    ReportItem(
      name: 'Student Reports',
      description: 'Download student progress and performance.',
      type: 'student',
    ),
    ReportItem(
      name: 'Attendance Reports',
      description: 'Generate class and student attendance reports.',
      type: 'attendance',
    ),
    ReportItem(
      name: 'Fee Reports',
      description: 'Create fee collection and pending fee reports.',
      type: 'fee',
    ),
    ReportItem(
      name: 'Staff Reports',
      description: 'Create staff attendance and performance reports.',
      type: 'staff',
    ),
    ReportItem(
      name: 'Library Reports',
      description: 'Generate book issue and inventory reports.',
      type: 'library',
    ),
    ReportItem(
      name: 'Transport Reports',
      description: 'Create vehicle and route reports.',
      type: 'transport',
    ),
  ];

  String _selectedReportType = 'student';

  @override
  String get moduleKey => 'notifications';

  @override
  Map<String, dynamic> exportState() => {
    'channels': _channels.map((item) => item.toJson()).toList(),
    'types': _notificationTypes.map((item) => item.toJson()).toList(),
  };

  @override
  void importState(Map<String, dynamic> data) {
    _channels
      ..clear()
      ..addAll(
        (data['channels'] as List? ?? []).map(
          (item) => NotificationChannel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        ),
      );
    _notificationTypes
      ..clear()
      ..addAll(
        (data['types'] as List? ?? []).map(
          (item) =>
              NotificationType.fromJson(Map<String, dynamic>.from(item as Map)),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications & Reports'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Channels'),
              Tab(text: 'Alerts'),
              Tab(text: 'Reports'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildChannelsTab(context),
            _buildAlertsTab(context),
            _buildReportsTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelsTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Notification Channels',
          'Enable and configure communication channels.',
          action: () => _showChannelDialog(context),
          actionLabel: 'Add Channel',
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: _channels.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final channel = _channels[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(
                        channel.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(channel.description),
                      value: channel.enabled,
                      onChanged: (value) =>
                          setState(() => channel.enabled = value),
                    ),
                    OverflowBar(
                      alignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () =>
                              _showChannelDialog(context, channel: channel),
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                        ),
                        TextButton.icon(
                          onPressed: () =>
                              setState(() => _channels.removeAt(index)),
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.send),
            label: const Text('Send Test Notification'),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Test notification sent via enabled channels.'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertsTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Notification Types',
          'Select alert categories to activate.',
          action: () => _showTypeDialog(context),
          actionLabel: 'Add Alert',
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: _notificationTypes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final type = _notificationTypes[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(
                        type.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(type.description),
                      value: type.enabled,
                      onChanged: (value) =>
                          setState(() => type.enabled = value),
                    ),
                    OverflowBar(
                      alignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () => _showTypeDialog(context, type: type),
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                        ),
                        TextButton.icon(
                          onPressed: () => setState(
                            () => _notificationTypes.removeAt(index),
                          ),
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.campaign),
            label: const Text('Publish Announcement'),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Announcement queued for enabled notification types.',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReportsTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Generate PDF Reports',
            'Choose a report type and export options.',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _reports
                .map(
                  (report) => ChoiceChip(
                    label: Text(report.name),
                    selected: _selectedReportType == report.type,
                    onSelected: (_) =>
                        setState(() => _selectedReportType = report.type),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Report',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _reports
                        .firstWhere((item) => item.type == _selectedReportType)
                        .description,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Export PDF'),
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Exporting ${_selectedReportType.toUpperCase()} report to PDF.',
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.grid_on),
                        label: const Text('Export Excel'),
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Exporting ${_selectedReportType.toUpperCase()} report to Excel.',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Export Options',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'PDF and Excel export are available for student, attendance, fee, staff, library, and transport reports.',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    String subtitle, {
    VoidCallback? action,
    String? actionLabel,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(subtitle, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          if (action != null && actionLabel != null)
            ElevatedButton(onPressed: action, child: Text(actionLabel)),
        ],
      ),
    );
  }

  void _showChannelDialog(
    BuildContext context, {
    NotificationChannel? channel,
  }) {
    final nameController = TextEditingController(text: channel?.name ?? '');
    final descriptionController = TextEditingController(
      text: channel?.description ?? '',
    );
    _showConfigDialog(
      context,
      title: channel == null ? 'Add Channel' : 'Edit Channel',
      nameController: nameController,
      descriptionController: descriptionController,
      onSave: () {
        setState(() {
          if (channel == null) {
            _channels.add(
              NotificationChannel(
                id: _channels.isEmpty ? 1 : _channels.last.id + 1,
                name: nameController.text.trim(),
                enabled: true,
                description: descriptionController.text.trim(),
              ),
            );
          } else {
            channel
              ..name = nameController.text.trim()
              ..description = descriptionController.text.trim();
          }
        });
      },
    );
  }

  void _showTypeDialog(BuildContext context, {NotificationType? type}) {
    final nameController = TextEditingController(text: type?.name ?? '');
    final descriptionController = TextEditingController(
      text: type?.description ?? '',
    );
    _showConfigDialog(
      context,
      title: type == null ? 'Add Alert Type' : 'Edit Alert Type',
      nameController: nameController,
      descriptionController: descriptionController,
      onSave: () {
        setState(() {
          if (type == null) {
            _notificationTypes.add(
              NotificationType(
                id: _notificationTypes.isEmpty
                    ? 1
                    : _notificationTypes.last.id + 1,
                name: nameController.text.trim(),
                description: descriptionController.text.trim(),
                enabled: true,
              ),
            );
          } else {
            type
              ..name = nameController.text.trim()
              ..description = descriptionController.text.trim();
          }
        });
      },
    );
  }

  void _showConfigDialog(
    BuildContext context, {
    required String title,
    required TextEditingController nameController,
    required TextEditingController descriptionController,
    required VoidCallback onSave,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty ||
                  descriptionController.text.trim().isEmpty) {
                focusAndRevealController(
                  context,
                  nameController.text.trim().isEmpty
                      ? nameController
                      : descriptionController,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Complete all configuration fields.'),
                  ),
                );
                return;
              }
              onSave();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class NotificationChannel {
  NotificationChannel({
    required this.id,
    required this.name,
    required this.enabled,
    required this.description,
  });

  final int id;
  String name;
  bool enabled;
  String description;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'enabled': enabled,
    'description': description,
  };

  factory NotificationChannel.fromJson(Map<String, dynamic> json) =>
      NotificationChannel(
        id: json['id'] as int,
        name: json['name'] as String,
        enabled: json['enabled'] as bool,
        description: json['description'] as String,
      );
}

class NotificationType {
  NotificationType({
    required this.id,
    required this.name,
    required this.description,
    required this.enabled,
  });

  final int id;
  String name;
  String description;
  bool enabled;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'enabled': enabled,
  };

  factory NotificationType.fromJson(Map<String, dynamic> json) =>
      NotificationType(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String,
        enabled: json['enabled'] as bool,
      );
}

class ReportItem {
  ReportItem({
    required this.name,
    required this.description,
    required this.type,
  });

  final String name;
  final String description;
  final String type;
}
