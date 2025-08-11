import 'package:ecom/features/chat/domain/entities/chat_user.dart';
import 'package:ecom/features/chat/domain/usecases/get_messages.dart';
import 'package:ecom/features/chat/domain/usecases/initiate_chat.dart';

import '../domain/usecases/get_users.dart';
import '../domain/entities/chat.dart';
import '../domain/entities/message.dart';
import '../domain/usecases/get_chats.dart';
import '../domain/usecases/send_message.dart';
import '../domain/usecases/receive_message.dart';

class ChatFacade {
  final GetChats _getChats;
  final SendMessage _sendMessage;
  final ReceiveMessage _receiveMessage;
  final GetUsers _getUsers;
  final InitiateChat _initiateChat;
  final GetMessages _getMessages;

  ChatFacade({
    required GetChats getChats,
    required SendMessage sendMessage,
    required ReceiveMessage receiveMessage,
    required GetUsers getUsers,
    required InitiateChat initiateChat,
    required GetMessages getMessages
  }) : _getChats = getChats,
       _sendMessage = sendMessage,
       _receiveMessage = receiveMessage,
       _getUsers = getUsers,
       _initiateChat = initiateChat,
       _getMessages = getMessages;

  /// Loads all chats for the authenticated user
  Future<List<Chat>> getChats() => _getChats();

  // Loads all users for authenticated user
  Future<List<ChatUser>> getUsers() => _getUsers();

  //Initiate chat between users
  Future<void> initiateChat(String userId) async {
    return await _initiateChat(userId);
  }

  /// Sends a text message to a specific chat
  Future<void> sendTextMessage(String chatId, String content) {
    return _sendMessage(chatId: chatId, content: content, type: 'text');
  }

  //fetch all messages of chat
  Future<List<Message>> getMessages(String chatId){
    return _getMessages(chatId);
  }

  /// Listens for incoming messages (both delivered and received)
  Stream<Message> listenForMessages() => _receiveMessage();
}
