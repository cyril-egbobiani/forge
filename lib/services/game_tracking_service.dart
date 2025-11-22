import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:forge/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/game_models.dart';
import '../models/user.dart';
import 'auth_service.dart';
 
class GameTrackingService extends ChangeNotifier {
  static final GameTrackingService _instance = GameTrackingService._internal();
  static GameTrackingService get instance => _instance;
  GameTrackingService._internal();

  List<GameSession> _sessions = [];
  List<Badge> _userBadges = [];
  Map<GameType, GameStats> _gameStats = {};
  List<LeaderboardEntry> _leaderboard = [];

  List<GameSession> get sessions => List.unmodifiable(_sessions);
  List<Badge> get userBadges => List.unmodifiable(_userBadges);
  Map<GameType, GameStats> get gameStats => Map.unmodifiable(_gameStats);
  List<LeaderboardEntry> get leaderboard => List.unmodifiable(_leaderboard);

  Future<void> initialize() async {
    await _loadData();
    _initializeBadges();
    notifyListeners();
  }

  Future<void> recordGameSession(GameSession session) async {
    // Save locally
    _sessions.add(session);
    await _updateStats(session);
    await _checkAndUnlockBadges(session);
    await _saveData();

    // Send to backend
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.gameSessions),
        headers: ApiConfig.headers,
        body: jsonEncode({
          'gameType': session.gameType.toString().split('.').last,
          'score': session.score,
          'totalQuestions': session.totalQuestions,
          'scorePercentage': session.scorePercentage,
          'timeTaken': session.timeTaken.inSeconds,
        }),
      );
      if (response.statusCode == 201) {
        print('Game session recorded on backend');
      } else {
        print('Failed to record game session: ${response.body}');
      }
    } catch (e) {
      print('Error posting game session: $e');
    }

    await fetchLeaderboard();
    notifyListeners();
  }

  Future<void> fetchLeaderboard() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.leaderboard),
        headers: ApiConfig.headers,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final entries = (data['leaderboard'] as List)
            .map((e) => LeaderboardEntry.fromJson(e))
            .toList();
        _leaderboard = entries;
      } else {
        print('Failed to fetch leaderboard: ${response.body}');
      }
    } catch (e) {
      print('Error fetching leaderboard: $e');
    }
  }

  Future<void> _updateStats(GameSession session) async {
    final gameType = session.gameType;
    final currentStats =
        _gameStats[gameType] ??
        GameStats(
          gameType: gameType,
          totalGames: 0,
          totalScore: 0,
          averageScore: 0.0,
          bestScore: 0,
          bestTime: const Duration(hours: 1),
          currentStreak: 0,
          longestStreak: 0,
          unlockedBadges: [],
        );

    final totalGames = currentStats.totalGames + 1;
    final totalScore = currentStats.totalScore + session.score;
    final averageScore = totalScore / totalGames;
    final bestScore = session.score > currentStats.bestScore
        ? session.score
        : currentStats.bestScore;
    final bestTime = session.timeTaken < currentStats.bestTime
        ? session.timeTaken
        : currentStats.bestTime;

    // Calculate streaks
    final streaks = _calculateStreaks(gameType);

    _gameStats[gameType] = GameStats(
      gameType: gameType,
      totalGames: totalGames,
      totalScore: totalScore,
      averageScore: averageScore,
      bestScore: bestScore,
      bestTime: bestTime,
      currentStreak: streaks['current'] ?? 0,
      longestStreak: streaks['longest'] ?? 0,
      unlockedBadges: _getUnlockedBadgesForGame(gameType),
    );
  }

  Map<String, int> _calculateStreaks(GameType gameType) {
    final gameSessions = _sessions.where((s) => s.gameType == gameType).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    if (gameSessions.isEmpty) return {'current': 0, 'longest': 0};

    int currentStreak = 0;
    int longestStreak = 0;
    int tempStreak = 1;

    DateTime? lastDate;

    for (final session in gameSessions.reversed) {
      final sessionDate = DateTime(
        session.createdAt.year,
        session.createdAt.month,
        session.createdAt.day,
      );

      if (lastDate == null) {
        lastDate = sessionDate;
        currentStreak = 1;
      } else {
        final daysDiff = lastDate.difference(sessionDate).inDays;

        if (daysDiff == 1) {
          tempStreak++;
          currentStreak = tempStreak;
        } else if (daysDiff > 1) {
          if (currentStreak == tempStreak) {
            currentStreak = 1;
          }
          tempStreak = 1;
        }
        lastDate = sessionDate;
      }

      if (tempStreak > longestStreak) {
        longestStreak = tempStreak;
      }
    }

    // Check if current streak is still valid (last play was yesterday or today)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final daysSinceLastPlay = today.difference(lastDate!).inDays;

    if (daysSinceLastPlay > 1) {
      currentStreak = 0;
    }

    return {'current': currentStreak, 'longest': longestStreak};
  }

  Future<void> _checkAndUnlockBadges(GameSession session) async {
    final newBadges = <Badge>[];

    // First play badge
    if (_sessions.length == 1) {
      newBadges.add(_unlockBadge(BadgeType.firstPlay));
    }

    // Perfect score badge
    if (session.isPerfectScore) {
      newBadges.add(_unlockBadge(BadgeType.perfectScore));
    }

    // Quick thinker badge
    if (session.timeTaken.inSeconds <= 60) {
      newBadges.add(_unlockBadge(BadgeType.quickThinker));
    }

    // Streak badges
    final allStreaks = _calculateGlobalStreaks();
    final currentStreak = allStreaks['current'] ?? 0;

    if (currentStreak >= 3 && !_hasBadge(BadgeType.streak3)) {
      newBadges.add(_unlockBadge(BadgeType.streak3));
    }
    if (currentStreak >= 7 && !_hasBadge(BadgeType.streak7)) {
      newBadges.add(_unlockBadge(BadgeType.streak7));
    }
    if (currentStreak >= 30 && !_hasBadge(BadgeType.streak30)) {
      newBadges.add(_unlockBadge(BadgeType.streak30));
    }

    // Dedicated player badge
    if (_sessions.length >= 50 && !_hasBadge(BadgeType.dedicated)) {
      newBadges.add(_unlockBadge(BadgeType.dedicated));
    }

    // Explorer badge
    final playedGameTypes = _sessions.map((s) => s.gameType).toSet();
    if (playedGameTypes.length >= 2 && !_hasBadge(BadgeType.explorer)) {
      newBadges.add(_unlockBadge(BadgeType.explorer));
    }

    // Game-specific mastery badges
    final gameStats = _gameStats[session.gameType];
    if (gameStats != null &&
        gameStats.totalGames >= 20 &&
        gameStats.averageScore >= 80) {
      if (session.gameType == GameType.lightAndPath &&
          !_hasBadge(BadgeType.wisdom)) {
        newBadges.add(_unlockBadge(BadgeType.wisdom));
      } else if (session.gameType == GameType.reflectionGarden &&
          !_hasBadge(BadgeType.reflection)) {
        newBadges.add(_unlockBadge(BadgeType.reflection));
      }
    }

    // Show badge notifications
    for (final badge in newBadges) {
      if (badge.isUnlocked) {
        _showBadgeUnlockedNotification(badge);
      }
    }

    // Unlock badges on backend
    for (final badge in newBadges) {
      try {
        final response = await http.post(
          Uri.parse(ApiConfig.unlockBadge),
          headers: ApiConfig.headers,
          body: jsonEncode({'badgeId': badge.type.toString().split('.').last}),
        );
        if (response.statusCode == 201) {
          print('Badge unlocked on backend');
        } else {
          print('Failed to unlock badge: ${response.body}');
        }
      } catch (e) {
        print('Error unlocking badge: $e');
      }
    }
  }

  Future<void> fetchUserBadges(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.userBadges}/$userId'),
        headers: ApiConfig.headers,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final badges = (data['userBadges'] as List)
            .map((e) => Badge.fromJson(e['badgeId']))
            .toList();
        _userBadges = badges;
        notifyListeners();
      } else {
        print('Failed to fetch user badges: ${response.body}');
      }
    } catch (e) {
      print('Error fetching user badges: $e');
    }
  }

  Map<String, int> _calculateGlobalStreaks() {
    final allSessions = _sessions.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    if (allSessions.isEmpty) return {'current': 0, 'longest': 0};

    // Group sessions by date
    final sessionsByDate = <DateTime, List<GameSession>>{};
    for (final session in allSessions) {
      final date = DateTime(
        session.createdAt.year,
        session.createdAt.month,
        session.createdAt.day,
      );
      sessionsByDate.putIfAbsent(date, () => []).add(session);
    }

    final playDates = sessionsByDate.keys.toList()..sort();

    int currentStreak = 0;
    int longestStreak = 0;
    int tempStreak = 1;

    for (int i = playDates.length - 1; i >= 0; i--) {
      if (i == playDates.length - 1) {
        currentStreak = 1;
        tempStreak = 1;
      } else {
        final daysDiff = playDates[i + 1].difference(playDates[i]).inDays;
        if (daysDiff == 1) {
          tempStreak++;
          if (i == playDates.length - 2 ||
              playDates[i + 2].difference(playDates[i + 1]).inDays == 1) {
            currentStreak = tempStreak;
          }
        } else {
          if (i == playDates.length - 2) {
            currentStreak = 1;
          }
          tempStreak = 1;
        }
      }

      if (tempStreak > longestStreak) {
        longestStreak = tempStreak;
      }
    }

    // Check if streak is still valid
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastPlayDate = playDates.isNotEmpty ? playDates.last : today;
    final daysSinceLastPlay = today.difference(lastPlayDate).inDays;

    if (daysSinceLastPlay > 1) {
      currentStreak = 0;
    }

    return {'current': currentStreak, 'longest': longestStreak};
  }

  Badge _unlockBadge(BadgeType type) {
    final badge = Badge.getBadgeDefinition(
      type,
    ).copyWith(isUnlocked: true, unlockedAt: DateTime.now());

    final existingIndex = _userBadges.indexWhere((b) => b.type == type);
    if (existingIndex != -1) {
      _userBadges[existingIndex] = badge;
    } else {
      _userBadges.add(badge);
    }

    return badge;
  }

  bool _hasBadge(BadgeType type) {
    return _userBadges.any((b) => b.type == type && b.isUnlocked);
  }

  List<Badge> _getUnlockedBadgesForGame(GameType gameType) {
    return _userBadges.where((b) => b.isUnlocked).toList();
  }

  void _showBadgeUnlockedNotification(Badge badge) {
    // This would trigger a notification/dialog
    // Implementation depends on your notification system
    if (kDebugMode) {
      print('🏆 Badge Unlocked: ${badge.name}');
    }
  }

  Future<void> _updateLeaderboard() async {
    final currentUser = AuthService.instance.currentUser;
    if (currentUser == null) return;

    final userStats = _getUserStats(currentUser);
    final userId = currentUser.id ?? 'unknown_user';

    // In a real app, this would sync with a backend
    // For now, we'll just update the local user's entry
    final existingIndex = _leaderboard.indexWhere((e) => e.userId == userId);
    if (existingIndex != -1) {
      _leaderboard[existingIndex] = userStats;
    } else {
      _leaderboard.add(userStats);
    }

    // Sort by total score
    _leaderboard.sort((a, b) => b.totalScore.compareTo(a.totalScore));
  }

  LeaderboardEntry _getUserStats(User user) {
    final userId = user.id ?? 'unknown_user';
    final userSessions = _sessions.where((s) => s.userId == userId).toList();
    final totalScore = userSessions.fold(
      0,
      (sum, session) => sum + session.score,
    );
    final averageScore = userSessions.isEmpty
        ? 0.0
        : totalScore / userSessions.length;
    final globalStreaks = _calculateGlobalStreaks();

    return LeaderboardEntry(
      userId: userId,
      username: user.name,
      totalScore: totalScore,
      gamesPlayed: userSessions.length,
      averageScore: averageScore,
      currentStreak: globalStreaks['current'] ?? 0,
      longestStreak: globalStreaks['longest'] ?? 0,
      badges: _userBadges.where((b) => b.isUnlocked).toList(),
      lastPlayed: userSessions.isNotEmpty
          ? userSessions.last.createdAt
          : DateTime.now(),
    );
  }

  void _initializeBadges() {
    if (_userBadges.isEmpty) {
      // Initialize all badge definitions as locked
      for (final badgeType in BadgeType.values) {
        if (!_userBadges.any((b) => b.type == badgeType)) {
          _userBadges.add(Badge.getBadgeDefinition(badgeType));
        }
      }
    }
  }

  GameStats? getStatsForGame(GameType gameType) {
    return _gameStats[gameType];
  }

  List<GameSession> getSessionsForGame(GameType gameType) {
    return _sessions.where((s) => s.gameType == gameType).toList();
  }

  int getCurrentStreak() {
    final streaks = _calculateGlobalStreaks();
    return streaks['current'] ?? 0;
  }

  int getTotalScore() {
    return _sessions.fold(0, (sum, session) => sum + session.score);
  }

  int getTotalGamesPlayed() {
    return _sessions.length;
  }

  double getAverageScore() {
    if (_sessions.isEmpty) return 0.0;
    return getTotalScore() / _sessions.length;
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // Save sessions
    final sessionsJson = _sessions.map((s) => s.toJson()).toList();
    await prefs.setString('game_sessions', jsonEncode(sessionsJson));

    // Save badges
    final badgesJson = _userBadges.map((b) => b.toJson()).toList();
    await prefs.setString('user_badges', jsonEncode(badgesJson));

    // Save game stats
    final statsJson = <String, dynamic>{};
    _gameStats.forEach((gameType, stats) {
      statsJson[gameType.toString()] = stats.toJson();
    });
    await prefs.setString('game_stats', jsonEncode(statsJson));
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load sessions
    final sessionsString = prefs.getString('game_sessions');
    if (sessionsString != null) {
      final sessionsList = jsonDecode(sessionsString) as List;
      _sessions = sessionsList
          .map((json) => GameSession.fromJson(json))
          .toList();
    }

    // Load badges
    final badgesString = prefs.getString('user_badges');
    if (badgesString != null) {
      final badgesList = jsonDecode(badgesString) as List;
      _userBadges = badgesList.map((json) => Badge.fromJson(json)).toList();
    }

    // Load game stats
    final statsString = prefs.getString('game_stats');
    if (statsString != null) {
      final statsMap = jsonDecode(statsString) as Map<String, dynamic>;
      _gameStats.clear();
      statsMap.forEach((gameTypeString, statsJson) {
        final gameType = GameType.values.firstWhere(
          (e) => e.toString() == gameTypeString,
        );
        _gameStats[gameType] = GameStats.fromJson(statsJson);
      });
    }
  }

  // Reset all data (for testing purposes)
  Future<void> resetAllData() async {
    _sessions.clear();
    _userBadges.clear();
    _gameStats.clear();
    _leaderboard.clear();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('game_sessions');
    await prefs.remove('user_badges');
    await prefs.remove('game_stats');

    _initializeBadges();
    notifyListeners();
  }
}
