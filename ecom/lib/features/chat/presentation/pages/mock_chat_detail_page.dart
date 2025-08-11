// import 'package:flutter/material.dart';
// import '../../data/models/chat_model.dart';
// import '../../data/models/message_model.dart';
// import '../../data/datasources/mock_chat_remote_data_source.dart';

// class MockChatDetailPage extends StatelessWidget {
//   final ChatModel chat;
//   final MockChatRemoteDataSource dataSource;

//   const MockChatDetailPage({
//     super.key,
//     required this.chat,
//     required this.dataSource,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final List<MessageModel> messages = dataSource.getCachedMessages(chat.id);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 1,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               chat.user1.name,
//               style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 2),
//             const Text(
//               "online",
//               style: TextStyle(color: Colors.grey, fontSize: 12),
//             ),
//           ],
//         ),
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final msg = messages[index];
//                 final bool isMe = msg.sender.id == chat.user1.id;

//                 return Align(
//                   alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                     decoration: BoxDecoration(
//                       color: isMe ? Colors.blue : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       msg.content,
//                       style: TextStyle(
//                         color: isMe ? Colors.white : Colors.black87,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           _buildMessageInput(),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageInput() {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         child: Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: "Write your message",
//                   filled: true,
//                   fillColor: Colors.grey[100],
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 14),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(25),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.send, color: Colors.blue),
//               onPressed: () {},
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
