class Teaching {
  final String title;
  final String speaker;
  final String duration;
  final String description;
  final String imageUrl;

  const Teaching({
    required this.title,
    required this.speaker,
    required this.duration,
    required this.description,
    required this.imageUrl,
  });

  // Factory constructor for JSON serialization (future use)
  factory Teaching.fromJson(Map<String, dynamic> json) {
    return Teaching(
      title: json['title'] as String,
      speaker: json['speaker'] as String,
      duration: json['duration'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  // Convert to JSON (future use)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'speaker': speaker,
      'duration': duration,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
