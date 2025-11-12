class Teaching {
  final String? id;
  final String title;
  final String speaker;
  final String description;
  final String? series;
  final String? scripture;
  final int duration; // in minutes
  final String? audioUrl;
  final DateTime datePreached;
  final DateTime createdAt;
  final DateTime updatedAt;

  Teaching({
    this.id,
    required this.title,
    required this.speaker,
    required this.description,
    this.series,
    this.scripture,
    required this.duration,
    this.audioUrl,
    required this.datePreached,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert from JSON
  factory Teaching.fromJson(Map<String, dynamic> json) {
    return Teaching(
      id: json['_id'] ?? json['id'],
      title: json['title'] ?? '',
      speaker: json['speaker'] is Map
          ? json['speaker']['name'] ?? 'Pastor'
          : json['speaker'] ?? 'Pastor',
      description: json['description'] ?? '',
      series: json['series'] is Map ? json['series']['name'] : json['series'],
      scripture: json['scripture'] is Map
          ? json['scripture']['reference']
          : json['scripture'],
      duration: json['audioFile'] is Map
          ? (json['audioFile']['duration'] != null
                ? json['audioFile']['duration'] ~/ 60
                : 0)
          : json['duration'] ?? 0,
      audioUrl: json['audioFile'] is Map
          ? json['audioFile']['path']
          : json['audioUrl'],
      datePreached: json['datePreached'] != null
          ? DateTime.parse(json['datePreached'])
          : json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'title': title,
      'speaker': speaker,
      'description': description,
      if (series != null) 'series': series,
      if (scripture != null) 'scripture': scripture,
      'duration': duration,
      if (audioUrl != null) 'audioUrl': audioUrl,
      'datePreached': datePreached.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper methods
  String get formattedDate {
    return '${datePreached.day}/${datePreached.month}/${datePreached.year}';
  }

  String get durationText {
    if (duration < 60) {
      return '${duration}m';
    } else {
      final hours = duration ~/ 60;
      final minutes = duration % 60;
      return '${hours}h ${minutes}m';
    }
  }

  bool get hasAudio => audioUrl != null && audioUrl!.isNotEmpty;
}
