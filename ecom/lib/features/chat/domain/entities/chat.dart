import 'chat_user.dart';

class Chat {
  final String id;
  final ChatUser user1;
  final ChatUser user2;
  

  const Chat({
    required this.id,
    required this.user1,
    required this.user2,
  });
}
