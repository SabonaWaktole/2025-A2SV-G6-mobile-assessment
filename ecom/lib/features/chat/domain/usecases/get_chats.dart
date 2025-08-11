import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class GetChats {
  final ChatRepository repository;
  GetChats(this.repository);

  Future<List<Chat>> call() => repository.getChats();
}
