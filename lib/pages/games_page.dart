import 'package:flutter/material.dart';
import 'package:forge/utils/app_dimensions.dart';
import 'package:forge/utils/app_text_styles.dart';
import 'package:forge/utils/responsive_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/game_tracking_service.dart';
import '../models/game_models.dart';
import '../screens/game_stats_screen.dart';
import '../screens/light_and_path_game_screen.dart';
import '../screens/reflection_garden_game_screen.dart';
import '../utils/app_colors.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({Key? key}) : super(key: key);

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  final GameTrackingService _gameService = GameTrackingService.instance;

  @override
  void initState() {
    super.initState();
    _gameService.addListener(_onGameServiceUpdate);
  }

  @override
  void dispose() {
    _gameService.removeListener(_onGameServiceUpdate);
    super.dispose();
  }

  void _onGameServiceUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context, designWidth: 375, designHeight: 812);

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with stats
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Games',
                    style: GoogleFonts.archivoBlack(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(24),
                      letterSpacing: -1.5,
                      height: 1.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GameStatsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.w(12),
                        vertical: ResponsiveHelper.h(6),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.w(20),
                        ),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.analytics_outlined,
                            color: AppColors.primary,
                            size: ResponsiveHelper.w(16),
                          ),
                          SizedBox(width: ResponsiveHelper.w(4)),
                          Text(
                            'Stats',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Quick stats overview
            _buildQuickStatsOverview(),
            SizedBox(height: ResponsiveHelper.h(10)),

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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                child: Image.asset(
                  'assets/images/LightAndPath.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text(
                        '🏮 Hanging Golden Lights 🏮\n✨ Lantern Pattern ✨',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LightAndPathGameScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000000),
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                child: Image.asset(
                  'assets/images/ReflectionGarden.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text(
                        '🏠 Cozy Indoor Garden 🌱\n🪑 Plants & Furniture 🌿',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xFF3E2723),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReflectionGardenGameScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000000),
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

  Widget _buildQuickStatsOverview() {
    final totalScore = _gameService.getTotalScore();
    final totalGames = _gameService.getTotalGamesPlayed();
    final currentStreak = _gameService.getCurrentStreak();
    final unlockedBadges = _gameService.userBadges
        .where((b) => b.isUnlocked)
        .length;

    if (totalGames == 0) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
        padding: EdgeInsets.all(ResponsiveHelper.w(16)),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.emoji_events_outlined,
              color: AppColors.primary,
              size: ResponsiveHelper.w(24),
            ),
            SizedBox(width: ResponsiveHelper.w(12)),
            Expanded(
              child: Text(
                'Start your spiritual gaming journey!',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Score', totalScore.toString(), Icons.star),
          _buildStatItem('Games', totalGames.toString(), Icons.games),
          _buildStatItem(
            'Streak',
            '${currentStreak}d',
            Icons.local_fire_department,
          ),
          _buildStatItem(
            'Badges',
            unlockedBadges.toString(),
            Icons.emoji_events,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: ResponsiveHelper.w(20)),
        SizedBox(height: ResponsiveHelper.h(4)),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: Colors.grey[400]),
        ),
      ],
    );
  }
}
