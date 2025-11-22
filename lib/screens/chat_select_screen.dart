import 'package:flutter/material.dart';
import 'chat_screen.dart';

class ChatSelectScreen extends StatelessWidget {
  final String userId;
  final String userName;
  final String apiUrl;
  final String token;
  final String socketUrl;

  const ChatSelectScreen({
    required this.userId,
    required this.userName,
    required this.apiUrl,
    required this.token,
    required this.socketUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example group chat rooms
    final groupRooms = [
      {'name': 'General', 'id': 'general'},
      {'name': 'Events', 'id': 'events'},
      {'name': 'Prayer', 'id': 'prayer'},
    ];

    // Example private chat users (replace with real user list)
    // TODO: Replace with real user list fetched from backend or service
    final privateUsers = [];

    return Scaffold(
      appBar: AppBar(title: Text('Select Chat')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Group Chats',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ...groupRooms.map(
            (room) => ListTile(
              title: Text(room['name']!),
              leading: Icon(Icons.group),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      roomId: room['id']!,
                      userId: userId,
                      userName: userName,
                      apiUrl: apiUrl,
                      token: token,
                      socketUrl: socketUrl,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Private Chats',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          if (privateUsers.isEmpty)
            Center(child: Text('No users available.'))
          else
            ...privateUsers.map(
              (user) => ListTile(
                title: Text(user['name']!),
                leading: Icon(Icons.person),
                onTap: () {
                  // Room ID for private chat: sorted user IDs joined by _
                  final roomId = [userId, user['id']!].toList()..sort();
                  final privateRoomId = roomId.join('_');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        roomId: privateRoomId,
                        userId: userId,
                        userName: userName,
                        apiUrl: apiUrl,
                        token: token,
                        socketUrl: socketUrl,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
