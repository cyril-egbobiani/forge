class ApiConfig {
  // Multiple base URLs to try (we'll test all of them)
  static const List<String> baseUrls = [
    'http://10.0.2.2:3000', // Android emulator
    'http://192.168.100.222:3000', // Your computer's IP for physical device
    'http://localhost:3000', // iOS simulator / Web
    'http://127.0.0.1:3000', // Alternative localhost
  ];

  // Current base URL (we'll update this dynamically)
  static String baseUrl = baseUrls[0];

  static String get apiUrl => '$baseUrl/api';

  // API Endpoints
  static String get health => '$apiUrl/health';
  static String get teachings => '$apiUrl/teachings';
  static String get prayers => '$apiUrl/prayers';
  static String get events => '$apiUrl/events';

  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Timeout duration
  static const Duration timeout = Duration(seconds: 30);
}
