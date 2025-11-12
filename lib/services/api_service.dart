import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/teaching.dart';
import '../models/prayer_request.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  /// Health check endpoint
  Future<Map<String, dynamic>?> healthCheck() async {
    // Try each base URL until one works
    for (String baseUrl in ApiConfig.baseUrls) {
      ApiConfig.baseUrl = baseUrl;
      try {
        print('Trying health check with: ${ApiConfig.health}');
        final response = await http
            .get(Uri.parse(ApiConfig.health), headers: ApiConfig.headers)
            .timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
          print('✅ Successfully connected to: $baseUrl');
          return json.decode(response.body);
        } else {
          print('❌ HTTP ${response.statusCode} from: $baseUrl');
        }
      } catch (e) {
        print('❌ Connection failed to $baseUrl: $e');
        continue; // Try next URL
      }
    }

    print('❌ All connection attempts failed');
    return null;
  }

  // AUTHENTICATION API

  /// Login user
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('🔄 Flutter: Attempting login for $email');
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/api/auth/login'),
            headers: ApiConfig.headers,
            body: json.encode({'email': email, 'password': password}),
          )
          .timeout(ApiConfig.timeout);

      print('🔄 Flutter: Login response status: ${response.statusCode}');
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        print('✅ Flutter: Login successful');
        return {
          'success': true,
          'token': responseData['token'],
          'user': responseData['user'],
        };
      } else {
        print('❌ Flutter: Login failed - ${responseData['message']}');
        return {
          'success': false,
          'message': responseData['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      print('❌ Flutter: Login error - $e');
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  /// Register user
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      print('🔄 Flutter: Attempting registration for ${userData['email']}');
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/api/auth/register'),
            headers: ApiConfig.headers,
            body: json.encode(userData),
          )
          .timeout(ApiConfig.timeout);

      print('🔄 Flutter: Registration response status: ${response.statusCode}');
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Flutter: Registration successful');
        return {
          'success': true,
          'token': responseData['token'],
          'user': responseData['user'],
        };
      } else {
        print('❌ Flutter: Registration failed - ${responseData['message']}');
        return {
          'success': false,
          'message': responseData['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      print('❌ Flutter: Registration error - $e');
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  /// Logout user
  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/api/auth/logout'),
            headers: _getAuthHeaders(),
          )
          .timeout(ApiConfig.timeout);

      return json.decode(response.body);
    } catch (e) {
      print('❌ Flutter: Logout error - $e');
      return {'success': false, 'message': 'Logout failed'};
    }
  }

  /// Get user profile
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/api/auth/profile'),
            headers: _getAuthHeaders(),
          )
          .timeout(ApiConfig.timeout);

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'user': responseData['user']};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to get profile',
        };
      }
    } catch (e) {
      print('❌ Flutter: Get profile error - $e');
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateUserProfile(
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await http
          .put(
            Uri.parse('${ApiConfig.baseUrl}/api/auth/profile'),
            headers: _getAuthHeaders(),
            body: json.encode(updates),
          )
          .timeout(ApiConfig.timeout);

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'user': responseData['user']};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Update failed',
        };
      }
    } catch (e) {
      print('❌ Flutter: Update profile error - $e');
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  /// Verify token
  Future<Map<String, dynamic>> verifyToken() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/api/auth/verify'),
            headers: _getAuthHeaders(),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        return {'valid': true};
      } else {
        return {'valid': false};
      }
    } catch (e) {
      print('❌ Flutter: Token verification error - $e');
      return {'valid': false};
    }
  }

  /// Refresh token
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/api/auth/refresh'),
            headers: ApiConfig.headers,
            body: json.encode({'refreshToken': refreshToken}),
          )
          .timeout(ApiConfig.timeout);

      return json.decode(response.body);
    } catch (e) {
      print('❌ Flutter: Token refresh error - $e');
      return {'success': false, 'message': 'Token refresh failed'};
    }
  }

  /// Reset password
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/api/auth/reset-password'),
            headers: ApiConfig.headers,
            body: json.encode({'email': email}),
          )
          .timeout(ApiConfig.timeout);

      return json.decode(response.body);
    } catch (e) {
      print('❌ Flutter: Reset password error - $e');
      return {'success': false, 'message': 'Reset password failed'};
    }
  }

  /// Get headers with authorization
  Map<String, String> _getAuthHeaders() {
    final headers = Map<String, String>.from(ApiConfig.headers);

    // Add authorization header if token is available
    // This will be set by AuthService after successful login
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  String? _authToken;

  /// Set auth token for API requests
  void setAuthToken(String? token) {
    _authToken = token;
  }

  // TEACHINGS API

  /// Get all teachings
  Future<List<Teaching>> getTeachings() async {
    try {
      print('🔄 Flutter: Requesting teachings from ${ApiConfig.teachings}');
      final response = await http
          .get(Uri.parse(ApiConfig.teachings), headers: _getAuthHeaders())
          .timeout(ApiConfig.timeout);

      print('🔄 Flutter: Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('🔄 Flutter: Received ${data.length} teachings');
        if (data.isNotEmpty) {
          print('🔄 Flutter: Sample raw data: ${data[0]}');
        }
        final teachings = data.map((json) => Teaching.fromJson(json)).toList();
        print('🔄 Flutter: Parsed ${teachings.length} teachings successfully');
        return teachings;
      } else {
        throw Exception('Failed to load teachings: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Get teachings error: $e');
      return [];
    }
  }

  /// Get teaching by ID
  Future<Teaching?> getTeachingById(String id) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.teachings}/$id'),
            headers: ApiConfig.headers,
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Teaching.fromJson(data);
      } else {
        throw Exception('Failed to load teaching: ${response.statusCode}');
      }
    } catch (e) {
      print('Get teaching by ID error: $e');
      return null;
    }
  }

  /// Get teachings by series
  Future<List<Teaching>> getTeachingsBySeries(String series) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.teachings}/series/$series'),
            headers: ApiConfig.headers,
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Teaching.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load series teachings: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Get teachings by series error: $e');
      return [];
    }
  }

  /// Create new teaching
  Future<Teaching?> createTeaching({
    required String title,
    required String speaker,
    required String description,
    required String series,
    required String scripture,
    required int duration,
  }) async {
    try {
      final body = json.encode({
        'title': title,
        'speaker': speaker,
        'description': description,
        'series': series,
        'scripture': scripture,
        'duration': duration,
      });

      final response = await http
          .post(
            Uri.parse(ApiConfig.teachings),
            headers: {...ApiConfig.headers, 'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Teaching.fromJson(data);
      } else {
        throw Exception('Failed to create teaching: ${response.statusCode}');
      }
    } catch (e) {
      print('Create teaching error: $e');
      return null;
    }
  }

  // PRAYER REQUESTS API

  /// Get all prayer requests
  Future<List<PrayerRequest>> getPrayerRequests() async {
    try {
      final response = await http
          .get(Uri.parse(ApiConfig.prayers), headers: _getAuthHeaders())
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => PrayerRequest.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load prayer requests: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Get prayer requests error: $e');
      return [];
    }
  }

  /// Create new prayer request
  Future<PrayerRequest?> createPrayerRequest({
    required String title,
    required String description,
    String category = 'general',
    bool isAnonymous = false,
    String urgencyLevel = 'normal',
  }) async {
    try {
      final body = json.encode({
        'title': title,
        'description': description,
        'category': category,
        'isAnonymous': isAnonymous,
        'urgencyLevel': urgencyLevel,
      });

      final response = await http
          .post(
            Uri.parse(ApiConfig.prayers),
            headers: ApiConfig.headers,
            body: body,
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return PrayerRequest.fromJson(data);
      } else {
        throw Exception(
          'Failed to create prayer request: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Create prayer request error: $e');
      return null;
    }
  }

  /// Get prayer requests by category
  Future<List<PrayerRequest>> getPrayerRequestsByCategory(
    String category,
  ) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.prayers}/category/$category'),
            headers: ApiConfig.headers,
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => PrayerRequest.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load category prayer requests: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Get prayer requests by category error: $e');
      return [];
    }
  }
}
