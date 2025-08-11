abstract class ChatLocalDataSource {
  // For offline support or caching in the future
  Future<void> cacheChats(List<Map<String, dynamic>> chats);
  Future<List<Map<String, dynamic>>> getCachedChats();
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  List<Map<String, dynamic>> _cached = [];

  @override
  Future<void> cacheChats(List<Map<String, dynamic>> chats) async {
    _cached = chats;
  }

  @override
  Future<List<Map<String, dynamic>>> getCachedChats() async {
    return _cached;
  }
}
