import 'package:flutter/material.dart';
import 'package:forge/config/api_config.dart';
import 'package:forge/screens/chat_select_screen.dart';
import 'package:forge/utils/responsive_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:forge/services/auth_service.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use AuthService for real user/session data
    final auth = AuthService.instance;
    final userId = auth.currentUser?.id ?? '';
    final userName = auth.currentUser?.name ?? '';
    final apiUrl = ApiConfig.apiUrl;
    final token = auth.authToken ?? '';
    final socketUrl = ApiConfig.socketUrl;

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(20),
                vertical: ResponsiveHelper.h(16),
              ),
              child: Text(
                'Chats',
                style: GoogleFonts.archivoBlack(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(24),
                  letterSpacing: -1.5,
                  height: 1.0,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.chat),
                  label: Text('Open Chats'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatSelectScreen(
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
            ),
          ],
        ),
      ),
    );
  }

  // ...existing code...
}
