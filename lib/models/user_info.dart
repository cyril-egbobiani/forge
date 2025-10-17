class UserInfo {
  final String name;
  final String greeting;
  final String avatarUrl;

  const UserInfo({
    required this.name,
    required this.greeting,
    required this.avatarUrl,
  });

  // Factory constructor for JSON serialization (future use)
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      name: json['name'] as String,
      greeting: json['greeting'] as String,
      avatarUrl: json['avatarUrl'] as String,
    );
  }

  // Convert to JSON (future use)
  Map<String, dynamic> toJson() {
    return {'name': name, 'greeting': greeting, 'avatarUrl': avatarUrl};
  }
}
