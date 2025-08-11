import 'package:ecom/features/chat/domain/entities/chat_user.dart';
import 'package:ecom/features/chat/domain/repositories/chat_repository.dart';

class GetUsers {
  final ChatRepository repository;

  GetUsers(this.repository);

  Future<List<ChatUser>> call() {
    return repository.getUsers();
  }
}
