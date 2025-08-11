import 'package:flutter/material.dart';
import '../../domain/entities/chat.dart';

class ChatListTile extends StatelessWidget {
  final Chat chat;
  final VoidCallback onTap;

  const ChatListTile({super.key, required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final otherUser = chat.user2; // Simplification: show user1 as other user

    return ListTile(
      leading: CircleAvatar(child: Text(otherUser.name[0])),
      title: Text(otherUser.name),
      subtitle: const Text('Tap to chat'), // Optionally show last message preview
      onTap: onTap,
    );
  }
}
