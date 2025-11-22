import 'package:flutter/material.dart';
import '../models/game_models.dart' as game;
import '../services/game_tracking_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/responsive_helper.dart';
import '../utils/app_dimensions.dart';
import 'package:google_fonts/google_fonts.dart';

class GameStatsScreen extends StatefulWidget {
  const GameStatsScreen({Key? key}) : super(key: key);

  @override
  State<GameStatsScreen> createState() => _GameStatsScreenState();
}

class _GameStatsScreenState extends State<GameStatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GameTrackingService _gameService = GameTrackingService.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.dark800,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Game Stats',
                        style: GoogleFonts.archivoBlack(
                          fontSize: 22,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40), // For symmetry
                ],
              ),
            ),
            // TabBar
            Container(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.dark800,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TabBar(
                tabAlignment: TabAlignment.fill,
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                labelColor: Colors.black,
                labelPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                unselectedLabelColor: Colors.grey[400],
                labelStyle: GoogleFonts.archivo(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.w(18),
                ),
                dividerColor: Colors.transparent,
                unselectedLabelStyle: GoogleFonts.archivo(
                  fontWeight: FontWeight.normal,
                  fontSize: ResponsiveHelper.w(18),
                ),
                tabs: [
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.all(ResponsiveHelper.w(8)),
                      child: Text(
                        'Overview',
                        style: GoogleFonts.archivo(
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveHelper.w(16),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.all(ResponsiveHelper.w(8)),
                      child: Text(
                        'Badges',
                        style: GoogleFonts.archivo(
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveHelper.w(16),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.all(ResponsiveHelper.w(8)),
                      child: Text(
                        'Leaderboard',
                        style: GoogleFonts.archivo(
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveHelper.w(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xl),
            // TabBarView
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildBadgesTab(),
                  _buildLeaderboardTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverallStats(),
          SizedBox(height: ResponsiveHelper.h(24)),
          _buildGameSpecificStats(),
          SizedBox(height: ResponsiveHelper.h(24)),
          _buildRecentSessions(),
        ],
      ),
    );
  }

  Widget _buildOverallStats() {
    final totalScore = _gameService.getTotalScore();
    final totalGames = _gameService.getTotalGamesPlayed();
    final averageScore = _gameService.getAverageScore();
    final currentStreak = _gameService.getCurrentStreak();

    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.dark800,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall Performance',
            style: GoogleFonts.archivoBlack(
              fontSize: 18,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Score',
                  totalScore.toString(),
                  Icons.star,
                  AppColors.primary,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildStatCard(
                  'Games Played',
                  totalGames.toString(),
                  Icons.games,
                  Colors.blue,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Average Score',
                  '${averageScore.toStringAsFixed(1)}%',
                  Icons.trending_up,
                  Colors.green,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildStatCard(
                  'Current Streak',
                  '$currentStreak days',
                  Icons.local_fire_department,
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: GoogleFonts.archivoBlack(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            title,
            style: GoogleFonts.archivo(color: Colors.grey[400], fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGameSpecificStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Game Performance',
          style: AppTextStyles.h6.copyWith(color: AppColors.primary),
        ),
        SizedBox(height: ResponsiveHelper.h(16)),
        _buildGameStatsCard(game.GameType.lightAndPath),
        SizedBox(height: ResponsiveHelper.h(16)),
        _buildGameStatsCard(game.GameType.reflectionGarden),
      ],
    );
  }

  Widget _buildGameStatsCard(game.GameType gameType) {
    final stats = _gameService.getStatsForGame(gameType);
    final gameName = gameType == game.GameType.lightAndPath
        ? 'Light and Path'
        : 'Reflection Garden';
    final gameIcon = gameType == game.GameType.lightAndPath
        ? Icons.lightbulb
        : Icons.self_improvement;

    if (stats == null) {
      return Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(16)),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(gameIcon, color: Colors.grey, size: ResponsiveHelper.w(32)),
            SizedBox(height: ResponsiveHelper.h(8)),
            Text(
              gameName,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
            ),
            SizedBox(height: ResponsiveHelper.h(4)),
            Text(
              'Not played yet',
              style: AppTextStyles.caption.copyWith(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                gameIcon,
                color: AppColors.primary,
                size: ResponsiveHelper.w(24),
              ),
              SizedBox(width: ResponsiveHelper.w(8)),
              Text(
                gameName,
                style: AppTextStyles.h6.copyWith(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(16)),
          Row(
            children: [
              Expanded(
                child: _buildMiniStatCard('Games', stats.totalGames.toString()),
              ),
              SizedBox(width: ResponsiveHelper.w(8)),
              Expanded(
                child: _buildMiniStatCard('Best Score', '${stats.bestScore}%'),
              ),
              SizedBox(width: ResponsiveHelper.w(8)),
              Expanded(
                child: _buildMiniStatCard(
                  'Average',
                  '${stats.averageScore.toStringAsFixed(1)}%',
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(8)),
              Expanded(
                child: _buildMiniStatCard(
                  'Best Time',
                  '${stats.bestTime.inMinutes}:${(stats.bestTime.inSeconds % 60).toString().padLeft(2, '0')}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStatCard(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: AppTextStyles.caption.copyWith(color: Colors.grey[400]),
        ),
      ],
    );
  }

  Widget _buildRecentSessions() {
    final recentSessions = _gameService.sessions.take(5).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (recentSessions.isEmpty) {
      return Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(16)),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        ),
        child: Center(
          child: Text(
            'No games played yet',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Games',
          style: AppTextStyles.h6.copyWith(color: AppColors.primary),
        ),
        SizedBox(height: ResponsiveHelper.h(16)),
        ...recentSessions.map((session) => _buildSessionCard(session)),
      ],
    );
  }

  Widget _buildSessionCard(game.GameSession session) {
    final gameName = session.gameType == game.GameType.lightAndPath
        ? 'Light and Path'
        : 'Reflection Garden';
    final gameIcon = session.gameType == game.GameType.lightAndPath
        ? Icons.lightbulb
        : Icons.self_improvement;

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(8)),
      padding: EdgeInsets.all(ResponsiveHelper.w(12)),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            gameIcon,
            color: AppColors.primary,
            size: ResponsiveHelper.w(20),
          ),
          SizedBox(width: ResponsiveHelper.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gameName,
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                ),
                Text(
                  '${session.score}/${session.totalQuestions} • ${session.scorePercentage.toStringAsFixed(0)}%',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${session.timeTaken.inMinutes}:${(session.timeTaken.inSeconds % 60).toString().padLeft(2, '0')}',
                style: AppTextStyles.caption.copyWith(color: AppColors.primary),
              ),
              Text(
                '${session.createdAt.day}/${session.createdAt.month}',
                style: AppTextStyles.caption.copyWith(color: Colors.grey[400]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Achievements',
            style: AppTextStyles.h5.copyWith(color: AppColors.primary),
          ),
          SizedBox(height: ResponsiveHelper.h(16)),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: ResponsiveHelper.w(16),
              mainAxisSpacing: ResponsiveHelper.h(16),
              childAspectRatio: 0.8,
            ),
            itemCount: _gameService.userBadges.length,
            itemBuilder: (context, index) {
              final badge = _gameService.userBadges[index];
              return _buildBadgeCard(badge);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(game.Badge badge) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: badge.isUnlocked
            ? badge.color.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: Border.all(
          color: badge.isUnlocked
              ? badge.color.withOpacity(0.5)
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            badge.icon,
            size: ResponsiveHelper.w(32),
            color: badge.isUnlocked ? badge.color : Colors.grey,
          ),
          SizedBox(height: ResponsiveHelper.h(12)),
          Text(
            badge.name,
            style: AppTextStyles.bodyMedium.copyWith(
              color: badge.isUnlocked ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveHelper.h(8)),
          Text(
            badge.description,
            style: AppTextStyles.caption.copyWith(
              color: badge.isUnlocked ? Colors.grey[300] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          if (badge.isUnlocked && badge.unlockedAt != null) ...[
            SizedBox(height: ResponsiveHelper.h(8)),
            Text(
              'Unlocked ${badge.unlockedAt!.day}/${badge.unlockedAt!.month}',
              style: AppTextStyles.caption.copyWith(
                color: badge.color.withOpacity(0.7),
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLeaderboardTab() {
    final leaderboard = _gameService.leaderboard;

    if (leaderboard.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: ResponsiveHelper.w(64),
              color: Colors.grey,
            ),
            SizedBox(height: ResponsiveHelper.h(16)),
            Text(
              'No leaderboard data yet',
              style: AppTextStyles.h6.copyWith(color: Colors.grey),
            ),
            SizedBox(height: ResponsiveHelper.h(8)),
            Text(
              'Play some games to see your ranking!',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      itemCount: leaderboard.length,
      itemBuilder: (context, index) {
        final entry = leaderboard[index];
        return _buildLeaderboardCard(entry, index + 1);
      },
    );
  }

  Widget _buildLeaderboardCard(game.LeaderboardEntry entry, int rank) {
    final isCurrentUser =
        entry.userId ==
        GameTrackingService.instance.sessions.firstOrNull?.userId;

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(8)),
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? AppColors.primary.withOpacity(0.1)
            : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: Border.all(
          color: isCurrentUser
              ? AppColors.primary.withOpacity(0.5)
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: ResponsiveHelper.w(32),
            height: ResponsiveHelper.w(32),
            decoration: BoxDecoration(
              color: rank <= 3
                  ? [Colors.amber, Colors.grey, Colors.orange][rank - 1]
                  : Colors.grey.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: rank <= 3 ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: ResponsiveHelper.w(16)),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.username,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${entry.gamesPlayed} games',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.grey[400],
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.w(8)),
                    Text(
                      '${entry.averageScore.toStringAsFixed(1)}% avg',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Score and badges
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                entry.totalScore.toString(),
                style: AppTextStyles.h6.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: ResponsiveHelper.w(16),
                    color: Colors.amber,
                  ),
                  SizedBox(width: ResponsiveHelper.w(4)),
                  Text(
                    '${entry.badgeCount}',
                    style: AppTextStyles.caption.copyWith(color: Colors.amber),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
