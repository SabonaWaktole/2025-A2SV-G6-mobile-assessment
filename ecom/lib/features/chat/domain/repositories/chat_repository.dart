import 'package:ecom/features/chat/data/models/message_model.dart';
import 'package:ecom/features/chat/domain/entities/chat_user.dart';

import '../entities/chat.dart';
import '../entities/message.dart';

abstract class ChatRepository {

  Future<List<Chat>> getChats();
  Future<List<ChatUser>> getUsers();
  Stream<Message> receiveMessage();
  Future<void> initiateChat(String userId);
   Future<List<MessageModel>> getMessages(String chatId);
  Future<void> sendMessage({
    required String chatId,
    required String content,
    required String type,
  });
}
