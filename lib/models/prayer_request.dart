class PrayerRequest {
  final String? id;
  final String title;
  final String description;
  final String category;
  final bool isAnonymous;
  final String urgencyLevel; // 'low', 'normal', 'high', 'urgent'
  final String status; // 'active', 'closed', 'answered'
  final bool isAnswered;
  final String? authorId;
  final String? authorName;
  final List<PrayerUpdate> updates;
  final List<PrayerComment> comments;
  final int prayerCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  PrayerRequest({
    this.id,
    required this.title,
    required this.description,
    this.category = 'general',
    this.isAnonymous = false,
    this.urgencyLevel = 'normal',
    this.status = 'active',
    this.isAnswered = false,
    this.authorId,
    this.authorName,
    this.updates = const [],
    this.comments = const [],
    this.prayerCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PrayerRequest.fromJson(Map<String, dynamic> json) {
    return PrayerRequest(
      id: json['_id'] ?? json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'general',
      isAnonymous: json['isAnonymous'] ?? false,
      urgencyLevel: json['urgencyLevel'] ?? 'normal',
      status: json['status'] ?? 'active',
      isAnswered: json['isAnswered'] ?? false,
      authorId: json['author']?['_id'] ?? json['authorId'],
      authorName: json['author']?['name'] ?? json['authorName'],
      updates: _parseUpdates(json['updates']),
      comments: _parseComments(json['comments']),
      prayerCount: json['prayerCount'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'title': title,
      'description': description,
      'category': category,
      'isAnonymous': isAnonymous,
      'urgencyLevel': urgencyLevel,
      'status': status,
      'isAnswered': isAnswered,
      if (authorId != null) 'authorId': authorId,
      if (authorName != null) 'authorName': authorName,
      'updates': updates.map((update) => update.toJson()).toList(),
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'prayerCount': prayerCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String get displayAuthor {
    if (isAnonymous) return 'Anonymous';
    return authorName ?? 'Unknown';
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  bool get isUrgent => urgencyLevel == 'urgent' || urgencyLevel == 'high';

  static List<PrayerUpdate> _parseUpdates(dynamic updatesJson) {
    try {
      if (updatesJson == null) return [];
      if (updatesJson is! List) return [];

      return updatesJson
          .where((update) => update is Map<String, dynamic>)
          .map((update) {
            try {
              return PrayerUpdate.fromJson(update as Map<String, dynamic>);
            } catch (e) {
              print('Error parsing prayer update: $e');
              return null;
            }
          })
          .where((update) => update != null)
          .cast<PrayerUpdate>()
          .toList();
    } catch (e) {
      print('Error parsing updates list: $e');
      return [];
    }
  }

  static List<PrayerComment> _parseComments(dynamic commentsJson) {
    try {
      if (commentsJson == null) return [];
      if (commentsJson is! List) return [];

      return commentsJson
          .where((comment) => comment is Map<String, dynamic>)
          .map((comment) {
            try {
              return PrayerComment.fromJson(comment as Map<String, dynamic>);
            } catch (e) {
              print('Error parsing prayer comment: $e');
              return null;
            }
          })
          .where((comment) => comment != null)
          .cast<PrayerComment>()
          .toList();
    } catch (e) {
      print('Error parsing comments list: $e');
      return [];
    }
  }
}

class PrayerUpdate {
  final String message;
  final DateTime date;
  final String? createdBy;

  PrayerUpdate({required this.message, required this.date, this.createdBy});

  factory PrayerUpdate.fromJson(Map<String, dynamic> json) {
    try {
      return PrayerUpdate(
        message:
            json['text']?.toString() ??
            json['message']?.toString() ??
            '', // Backend uses 'text', frontend expects 'message'
        date: PrayerUpdate._parseDateTime(json['createdAt'] ?? json['date']),
        createdBy: json['createdBy']?.toString(),
      );
    } catch (e) {
      print('Error parsing PrayerUpdate: $e');
      print('JSON data: $json');
      // Return a default update if parsing fails
      return PrayerUpdate(
        message: 'Update failed to load',
        date: DateTime.now(),
      );
    }
  }

  static DateTime _parseDateTime(dynamic dateValue) {
    try {
      if (dateValue == null) return DateTime.now();
      if (dateValue is DateTime) return dateValue;
      return DateTime.parse(dateValue.toString());
    } catch (e) {
      print('Error parsing date: $e, value: $dateValue');
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'text': message, // Backend expects 'text'
      'message': message, // Keep for frontend compatibility
      'createdAt': date.toIso8601String(),
      'date': date.toIso8601String(),
      if (createdBy != null) 'createdBy': createdBy,
    };
  }
}

class PrayerComment {
  final String text;
  final DateTime createdAt;
  final String? userId;
  final String? userName;
  final bool isEncouragement;

  PrayerComment({
    required this.text,
    required this.createdAt,
    this.userId,
    this.userName,
    this.isEncouragement = true,
  });

  factory PrayerComment.fromJson(Map<String, dynamic> json) {
    try {
      return PrayerComment(
        text: json['text']?.toString() ?? '',
        createdAt: _parseDateTime(json['createdAt']),
        userId: _parseUserId(json),
        userName: _parseUserName(json),
        isEncouragement: json['isEncouragement'] ?? true,
      );
    } catch (e) {
      print('Error parsing PrayerComment: $e');
      print('JSON data: $json');
      // Return a default comment if parsing fails
      return PrayerComment(
        text: 'Comment failed to load',
        createdAt: DateTime.now(),
      );
    }
  }

  static DateTime _parseDateTime(dynamic dateValue) {
    try {
      if (dateValue == null) return DateTime.now();
      if (dateValue is DateTime) return dateValue;
      return DateTime.parse(dateValue.toString());
    } catch (e) {
      print('Error parsing date: $e, value: $dateValue');
      return DateTime.now();
    }
  }

  static String? _parseUserId(Map<String, dynamic> json) {
    try {
      // Try different possible structures safely
      if (json['user'] is Map<String, dynamic>) {
        return json['user']['_id']?.toString();
      }
      return json['userId']?.toString() ?? json['user_id']?.toString();
    } catch (e) {
      print('Error parsing user ID: $e');
      return null;
    }
  }

  static String? _parseUserName(Map<String, dynamic> json) {
    try {
      // Try different possible structures safely
      if (json['user'] is Map<String, dynamic>) {
        return json['user']['name']?.toString();
      }
      return json['userName']?.toString() ??
          json['user_name']?.toString() ??
          'Anonymous';
    } catch (e) {
      print('Error parsing user name: $e');
      return 'Anonymous';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      if (userId != null) 'userId': userId,
      if (userName != null) 'userName': userName,
      'isEncouragement': isEncouragement,
    };
  }
}
