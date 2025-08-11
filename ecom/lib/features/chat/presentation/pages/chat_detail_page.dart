import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../bloc/chat_bloc/chat_bloc.dart';
import '../bloc/chat_bloc/chat_event.dart';
import '../bloc/chat_bloc/chat_state.dart';
import '../widgets/chat_input_field.dart';
// import '../widgets/chat_message_bubble.dart';

class ChatDetailPage extends StatefulWidget {
  final Chat chat;
  final String currentUserId;

  const ChatDetailPage({
    super.key,
    required this.chat,
    required this.currentUserId,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final ScrollController _scrollController = ScrollController();
  List<Message> _messages = [];

  late final StreamSubscription _chatSubscription;

  @override
  void initState() {
    super.initState();

    final chatBloc = context.read<ChatBloc>();

    // Dispatch event to load messages for this chat
    chatBloc.add(LoadMessages(chatId: widget.chat.id));
    debugPrint('${widget.chat.id} chat id');

    // Listen for messages loaded and new incoming messages
    _chatSubscription = chatBloc.stream.listen((state) {
      if (!mounted) return; // 🚀 Prevent setState after dispose

      if (state is MessagesLoaded) {
        setState(() {
          _messages = state.messages;
        });
        _scrollToBottom();
      } else if (state is MessageReceivedState) {
        if (state.message.chat.id == widget.chat.id) {
          setState(() {
            _messages.add(state.message);
          });
          _scrollToBottom();
        }
      }
    });
  }

  @override
  void dispose() {
    _chatSubscription.cancel(); // 🚀 Stop receiving events
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _sendMessage(String content) {
    if (content.trim().isEmpty) return;

    context.read<ChatBloc>().add(
      SendChatMessage(chatId: widget.chat.id, content: content.trim()),
    );

    final currentUser = (widget.chat.user1.id == widget.currentUserId)
        ? widget.chat.user1
        : widget.chat.user2;

    final message = Message(
      id: DateTime.now().toIso8601String(),
      sender: currentUser,
      chat: widget.chat,
      content: content.trim(),
      type: 'text',
    );

    setState(() {
      _messages.add(message);
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final chatPartner = (widget.chat.user1.id == widget.currentUserId)
        ? widget.chat.user1
        : widget.chat.user2;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text(
                chatPartner.name[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatPartner.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Online",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg.sender.id == widget.currentUserId;

                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      gradient: isMe
                          ? LinearGradient(
                              colors: [Colors.blue[400]!, Colors.blue[600]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : LinearGradient(
                              colors: [Colors.grey[200]!, Colors.grey[300]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(2, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isMe ? 20 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 20),
                      ),
                    ),
                    child: Text(
                      msg.content,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: ChatInputField(onSend: _sendMessage),
          ),
        ],
      ),
    );
  }
}
