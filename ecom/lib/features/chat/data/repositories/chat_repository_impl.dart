import 'package:ecom/features/chat/data/models/message_model.dart';
import 'package:ecom/features/chat/domain/entities/chat_user.dart';

import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Chat>> getChats() async {
    return await remoteDataSource.getChats();
  }

  @override
  Stream<Message> receiveMessage() {
    return remoteDataSource.receiveMessage();
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String content,
    required String type,
  }) async {
    await remoteDataSource.sendMessage(chatId, content, type);
  }

  @override
  Future<List<ChatUser>> getUsers() async {
    return await remoteDataSource.getUsers();
  }

  @override
  Future<void> initiateChat(String userId) async {
    try {
      await remoteDataSource.initiateChat(userId);
    } catch (e) {
      throw Exception('Could not initiate chat: $e');
    }
}

  @override
  Future<List<MessageModel>> getMessages(String chatId) async {
    try {
      final messages = await remoteDataSource.getMessages(chatId);
      return messages;
    } catch (e) {
      // Handle or rethrow exceptions here if needed
      rethrow;
    }
  }

}