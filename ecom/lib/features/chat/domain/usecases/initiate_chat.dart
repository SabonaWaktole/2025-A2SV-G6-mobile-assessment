import '../repositories/chat_repository.dart';

class InitiateChat {
  final ChatRepository repository;

  InitiateChat(this.repository);

  Future<void> call(String userId) async {
    return await repository.initiateChat(userId);
  }
}
