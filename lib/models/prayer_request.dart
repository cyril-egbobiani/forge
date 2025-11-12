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
      updates:
          (json['updates'] as List?)
              ?.map((update) => PrayerUpdate.fromJson(update))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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
}

class PrayerUpdate {
  final String message;
  final DateTime date;

  PrayerUpdate({required this.message, required this.date});

  factory PrayerUpdate.fromJson(Map<String, dynamic> json) {
    return PrayerUpdate(
      message: json['message'] ?? '',
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'date': date.toIso8601String()};
  }
}
