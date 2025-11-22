import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatService {
  IO.Socket? socket;

  void connect(
    String serverUrl,
    String roomId,
    String userId,
    String userName,
  ) {
    // Prevent multiple connections
    if (socket != null && socket!.connected) return;
    socket = IO.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.connect();
    socket!.onConnect((_) {
      socket!.emit('join-chat-room', roomId);
    });
    socket!.onConnectError((err) {
      // Optionally handle connection error
    });
    socket!.onError((err) {
      // Optionally handle socket error
    });
  }

  Future<void> sendMessage(
    String roomId,
    String userId,
    String userName,
    String content,
    String apiUrl,
    String token,
  ) async {
    // Emit via socket for real-time
    socket?.emit('send-chat-message', {
      'roomId': roomId,
      'senderId': userId,
      'senderName': userName,
      'content': content,
    });
    // Persist to backend
    try {
      await http.post(
        Uri.parse('$apiUrl/chat/$roomId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'content': content}),
      );
    } catch (e) {
      // Optionally handle error
    }
  }

  void onNewMessage(Function(Map) callback) {
    socket?.on('new-chat-message', (data) => callback(data));
  }

  void disconnect() {
    if (socket != null) {
      socket!.disconnect();
      socket = null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchMessages(
    String apiUrl,
    String roomId,
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('$apiUrl/chat/$roomId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['messages']);
    }
    return [];
  }
}
