import '../../domain/entities/message.dart';
import 'chat_model.dart';
import 'user_model.dart';

class MessageModel extends Message {
  const MessageModel({
    required String id,
    required ChatUserModel sender,
    required ChatModel chat,
    required String content,
    required String type,
  }) : super(
          id: id,
          sender: sender,
          chat: chat,
          content: content,
          type: type,
        );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
      sender: ChatUserModel.fromJson(json['sender']),
      chat: ChatModel.fromJson(json['chat']),
      content: json['content'],
      type: json['type'],
    );
  }

  @override
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
