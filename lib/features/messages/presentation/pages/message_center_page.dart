import 'package:flutter/material.dart';

class MessageCenterPage extends StatelessWidget {
  const MessageCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final threads = [
      ('Principal Office', 'Please review the assembly agenda for tomorrow.', '2m ago'),
      ('Accounts Team', 'Fee summary report is ready for approval.', '18m ago'),
      ('Transport Desk', 'Route 4 vehicle maintenance has been completed.', '1h ago'),
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Message Center', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('Track internal conversations and school-wide communication updates.', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: threads.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final thread = threads[index];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.message_outlined)),
                    title: Text(thread.$1),
                    subtitle: Text(thread.$2),
                    trailing: Text(thread.$3, style: Theme.of(context).textTheme.bodySmall),
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