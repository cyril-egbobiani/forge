import 'package:flutter/material.dart';
import 'package:forge/utils/app_text_styles.dart';
import 'package:forge/utils/responsive_helper.dart';

class GamesPage extends StatelessWidget {
  const GamesPage({Key? key}) : super(key: key);

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
                'Games',
                style: AppTextStyles.h5.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Games list
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(20),
                  ),
                  child: Column(
                    children: [
                      _buildLightAndPathCard(),
                      SizedBox(height: ResponsiveHelper.h(20)),
                      _buildReflectionGardenCard(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLightAndPathCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A148C), Color(0xFF7B1FA2), Color(0xFF8E24AA)],
        ),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
        border: Border.all(color: const Color(0xFF9C27B0), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Game image area - hanging lights pattern
          SizedBox(
            width: double.infinity,
            height: ResponsiveHelper.h(200),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1A0E3A), Color(0xFF2D1B69)],
                ),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                border: Border.all(color: const Color(0xFF5E35B1), width: 1),
              ),
              child: Center(
                child: Text(
                  '🏮 Hanging Golden Lights 🏮\n✨ Lantern Pattern ✨',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.amber.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(20)),

          // Game title and description
          Text(
            'Light and Path',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(8)),
          Text(
            'Biblical Trivia and Quizzes',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(20)),

          // Play button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to Light and Path game
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C27B0),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(25)),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Play Game',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReflectionGardenCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A472A), Color(0xFF2D5A3D), Color(0xFF388E3C)],
        ),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
        border: Border.all(color: const Color(0xFF4CAF50), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Garden image area - cozy indoor scene
          SizedBox(
            width: double.infinity,
            height: ResponsiveHelper.h(200),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFD7CCC8),
                    Color(0xFFBCAAA4),
                    Color(0xFFA1887F),
                  ],
                ),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                border: Border.all(color: const Color(0xFF8BC34A), width: 1),
              ),
              child: Center(
                child: Text(
                  '🏠 Cozy Indoor Garden 🌱\n🪑 Plants & Furniture 🌿',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xFF3E2723),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(20)),

          // Game title and description
          Text(
            'Reflection Garden',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(8)),
          Text(
            'Guided Journal and creative prompts',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(20)),

          // Play button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to Reflection Garden
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(25)),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Play Game',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
