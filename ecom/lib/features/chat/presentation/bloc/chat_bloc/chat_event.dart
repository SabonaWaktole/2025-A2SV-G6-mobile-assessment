import 'package:equatable/equatable.dart';
import '../../../domain/entities/message.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadChats extends ChatEvent {}

class SendChatMessage extends ChatEvent {
  final String chatId;
  final String content;

  SendChatMessage({required this.chatId, required this.content});

  @override
  List<Object?> get props => [chatId, content];
}

class NewMessageReceived extends ChatEvent {
  final Message message;

  NewMessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}

// Event for initiating a new chat with a user by their userId
class InitiateChatEvent extends ChatEvent {
  final String userId;

  InitiateChatEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

// Message loading event
class LoadMessages extends ChatEvent {
  final String chatId; // or chatId depending on your API

  LoadMessages({required this.chatId});

  @override
  List<Object?> get props => [chatId];
}
