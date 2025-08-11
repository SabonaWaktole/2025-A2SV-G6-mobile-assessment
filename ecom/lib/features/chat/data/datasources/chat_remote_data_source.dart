import 'dart:convert';
import 'dart:async';

// ignore: library_prefixes
import 'package:ecom/features/chat/data/models/user_model.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChats();
  Stream<MessageModel> receiveMessage();
  Future<void> sendMessage(String chatId, String content, String type);
  Future<List<ChatUserModel>> getUsers();
  Future<void> initiateChat(String userId);
  Future<List<MessageModel>> getMessages(String chatId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final AuthLocalDataSource authLocalDataSource;
  final String baseUrl;
  late IO.Socket _socket;
  bool _socketInitialized = false;

  ChatRemoteDataSourceImpl({
    required this.authLocalDataSource,
    required this.baseUrl,
  });

  Future<void> _initSocket() async {
    if (_socketInitialized) return;

    final token = await authLocalDataSource.getCachedToken();

    if (token == null) throw Exception('No auth token found');



    _socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
          
    );

    _socket.connect();

    _socket.onConnect((_) => debugPrint('✅ Socket connected to url $baseUrl'));
    _socket.onDisconnect((_) => debugPrint('❌ Socket disconnected'));

    // Listen to all events for debugging
    _socket.onAny((event, data) {
      debugPrint('🔵 Socket event received: $event => $data');
    });

    _socket.onError((error) {
      debugPrint('⚠️ Socket error: $error');
    });

    _socketInitialized = true;
  }

  @override
  Future<List<ChatModel>> getChats() async {
    final token = await authLocalDataSource.getCachedToken();

    final response = await http.get(
      Uri.parse('$baseUrl/api/v3/chats/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    debugPrint('📥 getChats response status: ${response.statusCode}');
    debugPrint('📥 getChats response body\n: ${response.body}');

    /**
     * {"statusCode":200,"message":"","data":[{"_id":"689a0f31d1ddc4bf3039a679","user1":{"_id":"6899b198817e9a3287ca459e","name":"sabona","email":"sabonawak@gmail.com","__v":0},"user2":{"_id":"6891c0bbfa0604c7c17f079d","name":"ermi","email":"user@gmail.com","__v":0},"createdAt":"2025-08-11T15:41:37.353Z","updatedAt":"2025-08-11T15:41:37.353Z","__v":0},{"_id":"689a11c2d1ddc4bf3039a746","user1":{"_id":"6899b198817e9a3287ca459e","name":"sabona","email":"sabonawak@gmail.com","__v":0},"user2":{"_id":"6893161b3f94e073b1b65b74","name":"abu","email":"abu@gmail.com","__v":0},"createdAt":"2025-08-11T15:52:34.872Z","updatedAt":"2025-08-11T15:52:34.872Z","__v":0},{"_id":"689a11d5d1ddc4bf3039a776","user1":{"_id":"6899b198817e9a3287ca459e","name":"sabona","email":"sabonawak@gmail.com","__v":0},"user2":{"_id":"689346d9c293c0e593bf69c9","name":"mes","email":"mes@gmail.com","__v":0},"createdAt":"2025-08-11T15:52:53.314Z","updatedAt":"2025-08-11T15:52:53.314Z","__v":0},{"_id":"689a130bd1ddc4bf3039a7de","user1":{"_id":"6899b198817e

     */

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> chatList = decoded['data'];
      return chatList.map((e) => ChatModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load chats');
    }
  }

  @override
  Stream<MessageModel> receiveMessage() {
    final controller = StreamController<MessageModel>();

    _initSocket().then((_) {
      _socket.on('message:received', (data) {
        controller.add(MessageModel.fromJson(data));
      });
      _socket.on('message:delivered', (data) {
        controller.add(MessageModel.fromJson(data));
      });
    });

    controller.onCancel = () {
      _socket.off('message:received');
      _socket.off('message:delivered');
      controller.close();
    };

    return controller.stream;
  }

  @override
  Future<void> sendMessage(String chatId, String content, String type) async {
    await _initSocket();
    final token = await authLocalDataSource.getCachedToken();
    debugPrint('TOKEN IS $token');

    final dataToSend = {'chatId': chatId, 'content': content, 'type': type};

    debugPrint('Sending message data: $dataToSend');

    _socket.emit('message:send', {
      'chatId': chatId,
      'content': content,
      'type': type,
    });

    _socket.once('message:sent', (data) {
      debugPrint('✅ Message sent ack received: $data');
    });

    debugPrint('📤 Message emitted to server');

    // Listen for ack event from server, e.g., 'message:sent'
    _socket.once('message:sent', (data) {
      debugPrint('✅ Message sent ack received: $data');
    });
  }

  @override
  Future<List<ChatUserModel>> getUsers() async {
    final token = await authLocalDataSource.getCachedToken();
    if (token == null) {
      throw Exception('No auth token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/v3/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['data'] is List) {
        final List<dynamic> usersJson = decoded['data'];
        debugPrint('the users are \n $usersJson ');
        return usersJson.map((e) => ChatUserModel.fromJson(e)).toList();
      } else {
        throw Exception('Unexpected JSON format');
      }
    } else {
      throw Exception('Failed to fetch users: ${response.statusCode}');
    }
  }

  @override
  Future<void> initiateChat(String userId) async {
    final url = Uri.parse(
      'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3/chats',
    );
    final accesToken = await authLocalDataSource.getCachedToken();
    debugPrint('TOKEN IS $accesToken');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accesToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'userId': userId}), // receiver's user id
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to initiate chat with userId: $userId');
    }
    debugPrint(
      'THE INITIATE CHAT WRESPONSE BODY LOOKS LIKE THE FOLLOWING\n${response.body}',
    );
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId) async {
    final url = Uri.parse('$baseUrl/api/v3/chats/$chatId/messages');

    final token = await authLocalDataSource.getCachedToken();
    if (token == null) {
      throw Exception('No auth token found');
    }

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // <-- Add this
      },
    );

    debugPrint(
      '${response.statusCode} status co00000000000000000000000000000000000000000000000000000000000000000000000000000000000000de for getMessages',
    );
    debugPrint(
      'getMessages respo000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000nse body: ${response.body}',
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['data'];
      return jsonList.map((json) => MessageModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }
}

/**
 * type'(dynamic) => ChatModel' is not a subtype of type '(String, dynamic) => MApEntry<dynamic, dynamic>' of transform in type cast
 * 
 * 
 * curl --location 'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3/chats' \
--data '{
    "userId": "66c730840740f8c2bae904e0"
}'
 */
