import 'package:flutter/material.dart';
import '../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final String userId;
  final String userName;
  final String apiUrl;
  final String token;
  final String socketUrl;

  const ChatScreen({
    required this.roomId,
    required this.userId,
    required this.userName,
    required this.apiUrl,
    required this.token,
    required this.socketUrl,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _chatService.connect(
      widget.socketUrl,
      widget.roomId,
      widget.userId,
      widget.userName,
    );
    _chatService.onNewMessage((msg) {
      if (mounted) {
        // Prevent duplicate: only add if not already present
        final incoming = Map<String, dynamic>.from(msg);
        final isDuplicate = _messages.any((m) {
          final mTime =
              DateTime.tryParse(m['createdAt'] ?? '') ?? DateTime.now();
          final iTime =
              DateTime.tryParse(incoming['createdAt'] ?? '') ?? DateTime.now();
          return m['content'] == incoming['content'] &&
              m['senderId'] == incoming['senderId'] &&
              (m['createdAt'] == incoming['createdAt'] ||
                  (mTime.difference(iTime).inSeconds.abs() < 2));
        });
        if (!isDuplicate) {
          setState(() {
            _messages.add(incoming);
          });
        }
      }
    });
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final history = await _chatService.fetchMessages(
        widget.apiUrl,
        widget.roomId,
        widget.token,
      );
      if (mounted) {
        setState(() {
          _messages = history;
        });
      }
    } catch (e) {
      // Optionally show error
    }
  }

  @override
  void dispose() {
    _chatService.disconnect();
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    if (widget.userId.isEmpty || widget.token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be logged in to send messages.')),
      );
      return;
    }
    _chatService.sendMessage(
      widget.roomId,
      widget.userId,
      widget.userName,
      text,
      widget.apiUrl,
      widget.token,
    );
    // Optimistically add message for instant display
    setState(() {
      _messages.add({
        'senderId': widget.userId,
        'senderName': widget.userName,
        'content': text,
        'createdAt': DateTime.now().toIso8601String(),
      });
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['senderId'] == widget.userId;
                final time = msg['createdAt'] != null
                    ? DateTime.tryParse(msg['createdAt'].toString())
                    : null;
                final formattedTime = time != null
                    ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
                    : '';
                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['senderName'] ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isMe ? Colors.blue : Colors.black,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(msg['content'] ?? ''),
                        SizedBox(height: 2),
                        Text(
                          formattedTime,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
