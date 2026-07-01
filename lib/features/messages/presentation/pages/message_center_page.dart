import 'package:flutter/material.dart';
import 'package:educare/core/widgets/form_validation.dart';
import 'package:educare/core/widgets/persistent_module_state.dart';

class MessageCenterPage extends StatefulWidget {
  const MessageCenterPage({super.key});

  @override
  State<MessageCenterPage> createState() => _MessageCenterPageState();
}

class _MessageCenterPageState extends PersistentModuleState<MessageCenterPage> {
  final List<MessageThread> _threads = [
    MessageThread(
      id: 1,
      sender: 'Principal Office',
      message: 'Please review the assembly agenda for tomorrow.',
    ),
    MessageThread(
      id: 2,
      sender: 'Accounts Team',
      message: 'Fee summary report is ready for approval.',
    ),
    MessageThread(
      id: 3,
      sender: 'Transport Desk',
      message: 'Route 4 vehicle maintenance has been completed.',
    ),
  ];

  @override
  String get moduleKey => 'messages';

  @override
  Map<String, dynamic> exportState() => {
    'threads': _threads.map((thread) => thread.toJson()).toList(),
  };

  @override
  void importState(Map<String, dynamic> data) {
    _threads
      ..clear()
      ..addAll(
        (data['threads'] as List? ?? []).map(
          (item) =>
              MessageThread.fromJson(Map<String, dynamic>.from(item as Map)),
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
                  'Message Center',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showMessageDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('New Message'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Create and manage internal school communications.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _threads.isEmpty
                ? const Center(child: Text('No messages.'))
                : ListView.separated(
                    itemCount: _threads.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final thread = _threads[index];
                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.message_outlined),
                          ),
                          title: Text(thread.sender),
                          subtitle: Text(thread.message),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () =>
                                    _showMessageDialog(context, thread: thread),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () =>
                                    setState(() => _threads.removeAt(index)),
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

  void _showMessageDialog(BuildContext context, {MessageThread? thread}) {
    final senderController = TextEditingController(text: thread?.sender ?? '');
    final messageController = TextEditingController(
      text: thread?.message ?? '',
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(thread == null ? 'New Message' : 'Edit Message'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: senderController,
              decoration: const InputDecoration(labelText: 'Sender / Group'),
            ),
            TextField(
              controller: messageController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Message'),
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
              if (senderController.text.trim().isEmpty ||
                  messageController.text.trim().isEmpty) {
                focusAndRevealController(
                  context,
                  senderController.text.trim().isEmpty
                      ? senderController
                      : messageController,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Complete all message fields.')),
                );
                return;
              }
              setState(() {
                if (thread == null) {
                  _threads.add(
                    MessageThread(
                      id: _threads.isEmpty ? 1 : _threads.last.id + 1,
                      sender: senderController.text.trim(),
                      message: messageController.text.trim(),
                    ),
                  );
                } else {
                  thread
                    ..sender = senderController.text.trim()
                    ..message = messageController.text.trim();
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

class MessageThread {
  MessageThread({
    required this.id,
    required this.sender,
    required this.message,
  });

  final int id;
  String sender;
  String message;

  Map<String, dynamic> toJson() => {
    'id': id,
    'sender': sender,
    'message': message,
  };

  factory MessageThread.fromJson(Map<String, dynamic> json) => MessageThread(
    id: json['id'] as int,
    sender: json['sender'] as String,
    message: json['message'] as String,
  );
}
