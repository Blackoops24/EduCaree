import 'package:flutter/material.dart';

class CalendarOverviewPage extends StatelessWidget {
  const CalendarOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final events = [
      ('Morning Assembly', '08:30 AM', 'Main Courtyard'),
      ('Parent Teacher Meeting', '11:00 AM', 'Conference Hall'),
      ('Basketball Practice', '03:30 PM', 'Sports Complex'),
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Calendar', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('Review upcoming academic, administrative, and activity events.', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: events.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.calendar_today_outlined)),
                    title: Text(event.$1),
                    subtitle: Text('${event.$2} • ${event.$3}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}