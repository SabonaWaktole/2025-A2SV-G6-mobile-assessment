import '../../domain/entities/chat.dart';
import 'user_model.dart';
// import '../../domain/entities/chat.dart';
// import 'user_model.dart';

class ChatModel extends Chat {
  const ChatModel({
    required String id,
    required ChatUserModel user1,
    required ChatUserModel user2,
  }) : super(id: id, user1: user1, user2: user2);

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'],
      user1: ChatUserModel.fromJson(json['user1']),
      user2: ChatUserModel.fromJson(json['user2']),
    );
  }
  static ChatModel fromEntity(Chat chat) {
    return ChatModel(
      id: chat.id,
      user1: ChatUserModel.fromEntity(chat.user1),
      user2: ChatUserModel.fromEntity(chat.user2),
      // Add any other fields your ChatModel needs here
    );
  }
}


// data/models/chat_model.dart



// extension ChatModelExtension on ChatModel {
//   static ChatModel fromEntity(Chat chat) {
//     return ChatModel(
//       id: chat.id,
//       user1: ChatUserModel.fromEntity(chat.user1),
//       user2: ChatUserModel.fromEntity(chat.user2),
//       // Add any other fields your ChatModel needs here
//     );
//   }
// }
