import 'package:flutter/material.dart';
import 'package:forge/utils/app_text_styles.dart';
import 'package:forge/utils/responsive_helper.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(20),
                vertical: ResponsiveHelper.h(16),
              ),
              child: Text(
                'Chats',
                style: AppTextStyles.h5.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Chat list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(20),
                ),
                itemCount: _getChatItems().length,
                itemBuilder: (context, index) {
                  final chat = _getChatItems()[index];
                  return _buildChatItem(
                    avatarColor: chat['avatarColor'],
                    name: chat['name'],
                    message: chat['message'],
                    time: chat['time'],
                    icon: chat['icon'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatItem({
    required Color avatarColor,
    required String name,
    required String message,
    required String time,
    required IconData icon,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
      child: Row(
        children: [
          // Profile picture/avatar
          Container(
            width: ResponsiveHelper.w(48),
            height: ResponsiveHelper.w(48),
            decoration: BoxDecoration(
              color: avatarColor,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: ResponsiveHelper.w(24),
            ),
          ),

          SizedBox(width: ResponsiveHelper.w(16)),

          // Chat content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Name
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.sp(16),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    // Time
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.sp(14),
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: ResponsiveHelper.h(4)),

                // Message preview
                Text(
                  message,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.sp(14),
                    color: Colors.white.withOpacity(0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getChatItems() {
    return [
      {
        'avatarColor': const Color(0xFF2196F3),
        'name': 'Michael Smith',
        'message': 'Let\'s schedule a meeting to discuss',
        'time': '09:45',
        'icon': Icons.person,
      },
      {
        'avatarColor': const Color(0xFFFF9800),
        'name': 'Michael Smith',
        'message': 'Let\'s schedule a meeting to discuss',
        'time': '09:45',
        'icon': Icons.business,
      },
      {
        'avatarColor': const Color(0xFF795548),
        'name': 'Michael Smith',
        'message': 'Let\'s schedule a meeting to discuss',
        'time': '09:45',
        'icon': Icons.pets,
      },
      {
        'avatarColor': const Color(0xFF3F51B5),
        'name': 'Michael Smith',
        'message': 'Let\'s schedule a meeting to discuss',
        'time': '09:45',
        'icon': Icons.work,
      },
    ];
  }
}
