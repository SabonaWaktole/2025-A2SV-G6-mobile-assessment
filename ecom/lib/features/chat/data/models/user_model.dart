import '../../domain/entities/chat_user.dart';

class ChatUserModel extends ChatUser {
  const ChatUserModel({
    required String id,
    required String name,
    required String email,
  }) : super(id: id, name: name, email: email);

  factory ChatUserModel.fromJson(Map<String, dynamic> json) {
    return ChatUserModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
    };
  }

  toList() {}

  factory ChatUserModel.fromEntity(ChatUser user) {
    return ChatUserModel(
      id: user.id,
      name: user.name, email: user.email,
      // map other fields here
    );
  }
}
