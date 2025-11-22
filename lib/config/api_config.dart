class ApiConfig {
  // Socket.IO server URL
  static String get socketUrl =>
      'https://forge-backend-hdvz.onrender.com'; // Update to your actual socket server URL
  // Production backend URL from Render
  static const List<String> baseUrls = [
    'https://forge-backend-hdvz.onrender.com', // Primary - Render production
  ];

  // Current base URL (we'll update this dynamically)
  static String baseUrl = baseUrls[0];

  static String get apiUrl => '$baseUrl/api';

  // API Endpoints
  static String get health => '$apiUrl/health';
  static String get teachings => '$apiUrl/teachings';
  static String get prayers => '$apiUrl/prayers';
  static String get events => '$apiUrl/events';

  // Game endpoints
  static String get gameSessions => '$apiUrl/game-sessions';
  static String get leaderboard => '$apiUrl/game-sessions/leaderboard';
  static String get recentSessions => '$apiUrl/game-sessions/recent';

  // Badge endpoints
  static String get badges => '$apiUrl/badges';
  static String get userBadges => '$apiUrl/badges/user';
  static String get unlockBadge => '$apiUrl/badges/unlock';

  // Authentication Endpoints
  static String get authLogin => '$apiUrl/auth/login';
  static String get authRegister => '$apiUrl/auth/register';
  static String get authRefresh => '$apiUrl/auth/refresh';
  static String get authVerify => '$apiUrl/auth/verify';
  static String get authMe => '$apiUrl/auth/me';
  static String get authLogout => '$apiUrl/auth/logout';
  static String get authChangePassword => '$apiUrl/auth/change-password';

  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Timeout duration
  static const Duration timeout = Duration(
    seconds: 45,
  ); // Increased for mobile devices
}
