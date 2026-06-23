import 'package:flutter/material.dart';

class NotificationManagementPage extends StatefulWidget {
  const NotificationManagementPage({super.key});

  @override
  State<NotificationManagementPage> createState() => _NotificationManagementPageState();
}

class _NotificationManagementPageState extends State<NotificationManagementPage> {
  final List<NotificationChannel> _channels = [
    NotificationChannel(id: 1, name: 'Push Notifications', enabled: true, description: 'Send app push alerts to parents and students.'),
    NotificationChannel(id: 2, name: 'Email Notifications', enabled: true, description: 'Send email notifications for important updates.'),
    NotificationChannel(id: 3, name: 'SMS Notifications', enabled: false, description: 'Send short SMS alerts for urgent communications.'),
  ];

  final List<NotificationType> _notificationTypes = [
    NotificationType(id: 1, name: 'Attendance Alerts', description: 'Notify parents about attendance status.', enabled: true),
    NotificationType(id: 2, name: 'Fee Due Alerts', description: 'Send reminders for pending fee payments.', enabled: true),
    NotificationType(id: 3, name: 'Exam Alerts', description: 'Notify students about upcoming exams.', enabled: false),
    NotificationType(id: 4, name: 'General Announcements', description: 'Broadcast school-wide announcements.', enabled: true),
  ];

  final List<ReportItem> _reports = [
    ReportItem(name: 'Student Reports', description: 'Download student progress and performance.', type: 'student'),
    ReportItem(name: 'Attendance Reports', description: 'Generate class and student attendance reports.', type: 'attendance'),
    ReportItem(name: 'Fee Reports', description: 'Create fee collection and pending fee reports.', type: 'fee'),
    ReportItem(name: 'Staff Reports', description: 'Create staff attendance and performance reports.', type: 'staff'),
    ReportItem(name: 'Library Reports', description: 'Generate book issue and inventory reports.', type: 'library'),
    ReportItem(name: 'Transport Reports', description: 'Create vehicle and route reports.', type: 'transport'),
  ];

  String _selectedReportType = 'student';

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
        _buildSectionHeader('Notification Channels', 'Enable and configure communication channels.'),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: _channels.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final channel = _channels[index];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: SwitchListTile(
                  title: Text(channel.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(channel.description),
                  value: channel.enabled,
                  onChanged: (value) => setState(() => channel.enabled = value),
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
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test notification sent via enabled channels.'))),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertsTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Notification Types', 'Select alert categories to activate.'),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: _notificationTypes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final type = _notificationTypes[index];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: SwitchListTile(
                  title: Text(type.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(type.description),
                  value: type.enabled,
                  onChanged: (value) => setState(() => type.enabled = value),
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
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Announcement queued for enabled notification types.'))),
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
          _buildSectionHeader('Generate PDF Reports', 'Choose a report type and export options.'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _reports
                .map((report) => ChoiceChip(
                      label: Text(report.name),
                      selected: _selectedReportType == report.type,
                      onSelected: (_) => setState(() => _selectedReportType = report.type),
                    ))
                .toList(),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Selected Report', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(_reports.firstWhere((item) => item.type == _selectedReportType).description),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Export PDF'),
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exporting ${_selectedReportType.toUpperCase()} report to PDF.'))),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.grid_on),
                        label: const Text('Export Excel'),
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exporting ${_selectedReportType.toUpperCase()} report to Excel.'))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Export Options', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('PDF and Excel export are available for student, attendance, fee, staff, library, and transport reports.'),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}

class NotificationChannel {
  NotificationChannel({required this.id, required this.name, required this.enabled, required this.description});

  final int id;
  final String name;
  bool enabled;
  final String description;
}

class NotificationType {
  NotificationType({required this.id, required this.name, required this.description, required this.enabled});

  final int id;
  final String name;
  final String description;
  bool enabled;
}

class ReportItem {
  ReportItem({required this.name, required this.description, required this.type});

  final String name;
  final String description;
  final String type;
}
