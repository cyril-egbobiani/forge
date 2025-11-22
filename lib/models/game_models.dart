import 'package:flutter/material.dart';

enum GameType { lightAndPath, reflectionGarden }

enum BadgeType {
  firstPlay,
  streak3,
  streak7,
  streak30,
  perfectScore,
  quickThinker,
  dedicated,
  explorer,
  wisdom,
  reflection,
}

class GameSession {
  final String id;
  final String userId;
  final GameType gameType;
  final int score;
  final int totalQuestions;
  final Duration timeTaken;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  GameSession({
    required this.id,
    required this.userId,
    required this.gameType,
    required this.score,
    required this.totalQuestions,
    required this.timeTaken,
    required this.createdAt,
    this.metadata = const {},
  });

  double get scorePercentage => (score / totalQuestions) * 100;
  bool get isPerfectScore => score == totalQuestions;

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'gameType': gameType.toString(),
    'score': score,
    'totalQuestions': totalQuestions,
    'timeTakenSeconds': timeTaken.inSeconds,
    'createdAt': createdAt.toIso8601String(),
    'metadata': metadata,
  };

  factory GameSession.fromJson(Map<String, dynamic> json) => GameSession(
    id: json['id'],
    userId: json['userId'],
    gameType: GameType.values.firstWhere(
      (e) => e.toString() == json['gameType'],
    ),
    score: json['score'],
    totalQuestions: json['totalQuestions'],
    timeTaken: Duration(seconds: json['timeTakenSeconds']),
    createdAt: DateTime.parse(json['createdAt']),
    metadata: json['metadata'] ?? {},
  );
}

class Badge {
  final BadgeType type;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final DateTime? unlockedAt;
  final bool isUnlocked;

  Badge({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.unlockedAt,
    this.isUnlocked = false,
  });

  static Badge getBadgeDefinition(BadgeType type) {
    switch (type) {
      case BadgeType.firstPlay:
        return Badge(
          type: type,
          name: 'First Steps',
          description: 'Play your first game',
          icon: Icons.star,
          color: Colors.amber,
        );
      case BadgeType.streak3:
        return Badge(
          type: type,
          name: 'Getting Started',
          description: 'Play for 3 days in a row',
          icon: Icons.local_fire_department,
          color: Colors.orange,
        );
      case BadgeType.streak7:
        return Badge(
          type: type,
          name: 'Weekly Warrior',
          description: 'Play for 7 days in a row',
          icon: Icons.whatshot,
          color: Colors.red,
        );
      case BadgeType.streak30:
        return Badge(
          type: type,
          name: 'Devoted Disciple',
          description: 'Play for 30 days in a row',
          icon: Icons.diamond,
          color: Colors.purple,
        );
      case BadgeType.perfectScore:
        return Badge(
          type: type,
          name: 'Perfect Game',
          description: 'Get 100% in any game',
          icon: Icons.check_circle,
          color: Colors.green,
        );
      case BadgeType.quickThinker:
        return Badge(
          type: type,
          name: 'Quick Thinker',
          description: 'Complete a game in under 60 seconds',
          icon: Icons.flash_on,
          color: Colors.yellow,
        );
      case BadgeType.dedicated:
        return Badge(
          type: type,
          name: 'Dedicated Player',
          description: 'Play 50 games total',
          icon: Icons.emoji_events,
          color: Colors.blue,
        );
      case BadgeType.explorer:
        return Badge(
          type: type,
          name: 'Explorer',
          description: 'Try both game types',
          icon: Icons.explore,
          color: Colors.teal,
        );
      case BadgeType.wisdom:
        return Badge(
          type: type,
          name: 'Wisdom Seeker',
          description: 'Master of Light and Path',
          icon: Icons.lightbulb,
          color: Colors.amber,
        );
      case BadgeType.reflection:
        return Badge(
          type: type,
          name: 'Deep Thinker',
          description: 'Master of Reflection Garden',
          icon: Icons.self_improvement,
          color: Colors.green,
        );
    }
  }

  Badge copyWith({DateTime? unlockedAt, bool? isUnlocked}) {
    return Badge(
      type: type,
      name: name,
      description: description,
      icon: icon,
      color: color,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type.toString(),
    'name': name,
    'description': description,
    'unlockedAt': unlockedAt?.toIso8601String(),
    'isUnlocked': isUnlocked,
  };

  factory Badge.fromJson(Map<String, dynamic> json) {
    final definition = getBadgeDefinition(
      BadgeType.values.firstWhere((e) => e.toString() == json['type']),
    );

    return definition.copyWith(
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : null,
      isUnlocked: json['isUnlocked'] ?? false,
    );
  }
}

class LeaderboardEntry {
  final String userId;
  final String username;
  final int totalScore;
  final int gamesPlayed;
  final double averageScore;
  final int currentStreak;
  final int longestStreak;
  final List<Badge> badges;
  final DateTime lastPlayed;

  LeaderboardEntry({
    required this.userId,
    required this.username,
    required this.totalScore,
    required this.gamesPlayed,
    required this.averageScore,
    required this.currentStreak,
    required this.longestStreak,
    required this.badges,
    required this.lastPlayed,
  });

  int get badgeCount => badges.where((b) => b.isUnlocked).length;

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'username': username,
    'totalScore': totalScore,
    'gamesPlayed': gamesPlayed,
    'averageScore': averageScore,
    'currentStreak': currentStreak,
    'longestStreak': longestStreak,
    'badges': badges.map((b) => b.toJson()).toList(),
    'lastPlayed': lastPlayed.toIso8601String(),
  };

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      LeaderboardEntry(
        userId: json['userId'],
        username: json['username'],
        totalScore: json['totalScore'],
        gamesPlayed: json['gamesPlayed'],
        averageScore: json['averageScore'].toDouble(),
        currentStreak: json['currentStreak'],
        longestStreak: json['longestStreak'],
        badges: (json['badges'] as List)
            .map((badgeJson) => Badge.fromJson(badgeJson))
            .toList(),
        lastPlayed: DateTime.parse(json['lastPlayed']),
      );
}

class GameStats {
  final GameType gameType;
  final int totalGames;
  final int totalScore;
  final double averageScore;
  final int bestScore;
  final Duration bestTime;
  final int currentStreak;
  final int longestStreak;
  final List<Badge> unlockedBadges;

  GameStats({
    required this.gameType,
    required this.totalGames,
    required this.totalScore,
    required this.averageScore,
    required this.bestScore,
    required this.bestTime,
    required this.currentStreak,
    required this.longestStreak,
    required this.unlockedBadges,
  });

  Map<String, dynamic> toJson() => {
    'gameType': gameType.toString(),
    'totalGames': totalGames,
    'totalScore': totalScore,
    'averageScore': averageScore,
    'bestScore': bestScore,
    'bestTimeSeconds': bestTime.inSeconds,
    'currentStreak': currentStreak,
    'longestStreak': longestStreak,
    'unlockedBadges': unlockedBadges.map((b) => b.toJson()).toList(),
  };

  factory GameStats.fromJson(Map<String, dynamic> json) => GameStats(
    gameType: GameType.values.firstWhere(
      (e) => e.toString() == json['gameType'],
    ),
    totalGames: json['totalGames'],
    totalScore: json['totalScore'],
    averageScore: json['averageScore'].toDouble(),
    bestScore: json['bestScore'],
    bestTime: Duration(seconds: json['bestTimeSeconds']),
    currentStreak: json['currentStreak'],
    longestStreak: json['longestStreak'],
    unlockedBadges: (json['unlockedBadges'] as List)
        .map((badgeJson) => Badge.fromJson(badgeJson))
        .toList(),
  );
}
