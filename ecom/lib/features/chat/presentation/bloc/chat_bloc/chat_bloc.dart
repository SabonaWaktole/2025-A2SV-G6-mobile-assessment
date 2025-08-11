import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';
import '../../../domain/usecases/get_chats.dart';
import '../../../domain/usecases/get_messages.dart';   // <-- Added
import '../../../domain/usecases/send_message.dart';
import '../../../domain/usecases/receive_message.dart';
import '../../../domain/usecases/initiate_chat.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChats getChats;
  final GetMessages getMessages;  // <-- New use case for messages
  final SendMessage sendMessage;
  final ReceiveMessage receiveMessage;
  final InitiateChat initiateChat;

  ChatBloc({
    required this.getChats,
    required this.getMessages,
    required this.sendMessage,
    required this.receiveMessage,
    required this.initiateChat,
  }) : super(ChatInitial()) {
    on<LoadChats>(_onLoadChats);
    on<LoadMessages>(_onLoadMessages);   // <-- New handler for loading messages
    on<SendChatMessage>(_onSendChatMessage);
    on<NewMessageReceived>(_onNewMessageReceived);
    on<InitiateChatEvent>(_onInitiateChat);

    receiveMessage().listen((message) {
      add(NewMessageReceived(message));
    });

    // Automatically load chats on bloc creation
    add(LoadChats());
  }

  Future<void> _onLoadChats(LoadChats event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final chats = await getChats();
      emit(ChatLoaded(chats: chats));
    } catch (e) {
      emit(ChatError(message: e.toString()));
    }
  }

  Future<void> _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    emit(MessagesLoading());
    try {
      final messageModels = await getMessages(event.chatId);
final messages = messageModels.map((m) => m.toEntity()).toList();
emit(MessagesLoaded(messages));


    } catch (e) {
      emit(MessagesError(message: e.toString()));
    }
  }

  Future<void> _onSendChatMessage(SendChatMessage event, Emitter<ChatState> emit) async {
    try {
      await sendMessage(
        chatId: event.chatId,
        content: event.content,
        type: 'text',
      );
    } catch (_) {
      // handle send error optionally
    }
  }

  void _onNewMessageReceived(NewMessageReceived event, Emitter<ChatState> emit) {
    emit(MessageReceivedState(message: event.message));
  }

  Future<void> _onInitiateChat(InitiateChatEvent event, Emitter<ChatState> emit) async {
    try {
      await initiateChat(event.userId);
      add(LoadChats()); // Refresh chat list after initiating chat
    } catch (e) {
      emit(ChatError(message: e.toString()));
    }
  }
}
