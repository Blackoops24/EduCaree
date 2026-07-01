import 'package:flutter/material.dart';
import 'package:educare/core/widgets/form_validation.dart';
import 'package:educare/core/widgets/persistent_module_state.dart';

class CalendarOverviewPage extends StatefulWidget {
  const CalendarOverviewPage({super.key});

  @override
  State<CalendarOverviewPage> createState() => _CalendarOverviewPageState();
}

class _CalendarOverviewPageState
    extends PersistentModuleState<CalendarOverviewPage> {
  final List<CalendarEvent> _events = [
    CalendarEvent(
      id: 1,
      title: 'Morning Assembly',
      time: '08:30 AM',
      location: 'Main Courtyard',
    ),
    CalendarEvent(
      id: 2,
      title: 'Parent Teacher Meeting',
      time: '11:00 AM',
      location: 'Conference Hall',
    ),
    CalendarEvent(
      id: 3,
      title: 'Basketball Practice',
      time: '03:30 PM',
      location: 'Sports Complex',
    ),
  ];

  @override
  String get moduleKey => 'calendar';

  @override
  Map<String, dynamic> exportState() => {
    'events': _events.map((event) => event.toJson()).toList(),
  };

  @override
  void importState(Map<String, dynamic> data) {
    _events
      ..clear()
      ..addAll(
        (data['events'] as List? ?? []).map(
          (item) =>
              CalendarEvent.fromJson(Map<String, dynamic>.from(item as Map)),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Calendar',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showEventDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('New Event'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Create and manage academic, administrative, and activity events.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _events.isEmpty
                ? const Center(child: Text('No calendar events.'))
                : ListView.separated(
                    itemCount: _events.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final event = _events[index];
                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.calendar_today_outlined),
                          ),
                          title: Text(event.title),
                          subtitle: Text('${event.time} • ${event.location}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () =>
                                    _showEventDialog(context, event: event),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () =>
                                    setState(() => _events.removeAt(index)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showEventDialog(BuildContext context, {CalendarEvent? event}) {
    final titleController = TextEditingController(text: event?.title ?? '');
    final timeController = TextEditingController(text: event?.time ?? '');
    final locationController = TextEditingController(
      text: event?.location ?? '',
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event == null ? 'New Event' : 'Edit Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Event Title'),
            ),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(labelText: 'Time'),
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
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
              if (titleController.text.trim().isEmpty ||
                  timeController.text.trim().isEmpty ||
                  locationController.text.trim().isEmpty) {
                focusAndRevealController(
                  context,
                  titleController.text.trim().isEmpty
                      ? titleController
                      : timeController.text.trim().isEmpty
                      ? timeController
                      : locationController,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Complete all event fields.')),
                );
                return;
              }
              setState(() {
                if (event == null) {
                  _events.add(
                    CalendarEvent(
                      id: _events.isEmpty ? 1 : _events.last.id + 1,
                      title: titleController.text.trim(),
                      time: timeController.text.trim(),
                      location: locationController.text.trim(),
                    ),
                  );
                } else {
                  event
                    ..title = titleController.text.trim()
                    ..time = timeController.text.trim()
                    ..location = locationController.text.trim();
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class CalendarEvent {
  CalendarEvent({
    required this.id,
    required this.title,
    required this.time,
    required this.location,
  });

  final int id;
  String title;
  String time;
  String location;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'time': time,
    'location': location,
  };

  factory CalendarEvent.fromJson(Map<String, dynamic> json) => CalendarEvent(
    id: json['id'] as int,
    title: json['title'] as String,
    time: json['time'] as String,
    location: json['location'] as String,
  );
}
