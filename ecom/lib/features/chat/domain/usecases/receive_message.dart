import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class ReceiveMessage {
  final ChatRepository repository;
  ReceiveMessage(this.repository);

  Stream<Message> call() => repository.receiveMessage();
}
