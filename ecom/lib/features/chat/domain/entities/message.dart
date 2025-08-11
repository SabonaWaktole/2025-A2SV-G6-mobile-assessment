import 'chat.dart';
import 'chat_user.dart';

class Message {
  final String id;
  final ChatUser sender;
  final Chat chat;
  final String content;
  final String type;

  const Message({
    required this.id,
    required this.sender,
    required this.chat,
    required this.content,
    required this.type,
  });

   Message toEntity() {
  return Message(
    id: id,
    sender: sender, // make sure this is also a domain User entity
    chat: chat,     // make sure this is a domain Chat entity
    content: content,
    type: type,
  );
}
}
