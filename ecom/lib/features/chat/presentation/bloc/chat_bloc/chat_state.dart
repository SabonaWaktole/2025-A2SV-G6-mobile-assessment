import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat.dart';
import '../../../domain/entities/message.dart';

abstract class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Chat> chats;

  ChatLoaded({required this.chats});

  @override
  List<Object?> get props => [chats];
}

class ChatError extends ChatState {
  final String message;

  ChatError({required this.message});

  @override
  List<Object?> get props => [message];
}

class MessageReceivedState extends ChatState {
  final Message message;

  MessageReceivedState({required this.message});

  @override
  List<Object?> get props => [message];
}


class MessagesLoading extends ChatState {}

class MessagesLoaded extends ChatState {
  final List<Message> messages;

  MessagesLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class MessagesError extends ChatState {
  final String message;

  MessagesError({required this.message});  // named parameter

  @override
  List<Object?> get props => [message];
}


