class Activity {
  final String title;
  final String imageUrl;

  const Activity({required this.title, required this.imageUrl});

  // Factory constructor for JSON serialization (future use)
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  // Convert to JSON (future use)
  Map<String, dynamic> toJson() {
    return {'title': title, 'imageUrl': imageUrl};
  }
}
