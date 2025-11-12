import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _refreshTokenKey = 'refresh_token';

  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();
  AuthService._();

  final ApiService _apiService = ApiService();
  User? _currentUser;
  String? _authToken;

  // Getters
  User? get currentUser => _currentUser;
  String? get authToken => _authToken;
  bool get isAuthenticated => _currentUser != null && _authToken != null;

  /// Initialize auth service and check for existing session
  Future<bool> initializeAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Try to get stored token and user data
      _authToken = prefs.getString(_tokenKey);
      final userData = prefs.getString(_userKey);

      if (_authToken != null && userData != null) {
        // Parse stored user data
        final userJson = jsonDecode(userData);
        _currentUser = User.fromJson(userJson);

        // Set token in API service
        _apiService.setAuthToken(_authToken);

        // Verify token is still valid
        final isValid = await _verifyToken();
        if (isValid) {
          return true;
        } else {
          // Token expired, try to refresh
          return await _refreshAuthToken();
        }
      }

      return false;
    } catch (e) {
      print('Auth initialization error: $e');
      await clearAuthData();
      return false;
    }
  }

  /// Login with email and password
  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);

      if (response['success'] == true) {
        final token = response['token'];
        final userData = response['user'];

        if (token != null && userData != null) {
          _authToken = token;
          _currentUser = User.fromJson(userData);

          // Set token in API service for authenticated requests
          _apiService.setAuthToken(token);

          // Store auth data
          await _storeAuthData(token, userData);

          return AuthResult.success(_currentUser!);
        }
      }

      return AuthResult.failure(response['message'] ?? 'Login failed');
    } catch (e) {
      print('Login error: $e');
      return AuthResult.failure('Network error. Please try again.');
    }
  }

  /// Register new user
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final response = await _apiService.register({
        'name': name,
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
      });

      if (response['success'] == true) {
        final token = response['token'];
        final userData = response['user'];

        if (token != null && userData != null) {
          _authToken = token;
          _currentUser = User.fromJson(userData);

          // Set token in API service for authenticated requests
          _apiService.setAuthToken(token);

          // Store auth data
          await _storeAuthData(token, userData);

          return AuthResult.success(_currentUser!);
        }
      }

      return AuthResult.failure(response['message'] ?? 'Registration failed');
    } catch (e) {
      print('Registration error: $e');
      return AuthResult.failure('Network error. Please try again.');
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      // Call logout endpoint if needed
      if (_authToken != null) {
        await _apiService.logout();
      }
    } catch (e) {
      print('Logout API error: $e');
    } finally {
      // Clear local data regardless of API call result
      await clearAuthData();
    }
  }

  /// Get current user profile
  Future<User?> getCurrentUserProfile() async {
    try {
      if (_authToken == null) return null;

      final response = await _apiService.getUserProfile();
      if (response['success'] == true && response['user'] != null) {
        _currentUser = User.fromJson(response['user']);

        // Update stored user data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userKey, jsonEncode(_currentUser!.toJson()));

        return _currentUser;
      }

      return null;
    } catch (e) {
      print('Get profile error: $e');
      return null;
    }
  }

  /// Update user profile
  Future<AuthResult> updateProfile(Map<String, dynamic> updates) async {
    try {
      final response = await _apiService.updateUserProfile(updates);

      if (response['success'] == true && response['user'] != null) {
        _currentUser = User.fromJson(response['user']);

        // Update stored user data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userKey, jsonEncode(_currentUser!.toJson()));

        return AuthResult.success(_currentUser!);
      }

      return AuthResult.failure(response['message'] ?? 'Update failed');
    } catch (e) {
      print('Update profile error: $e');
      return AuthResult.failure('Network error. Please try again.');
    }
  }

  /// Store authentication data
  Future<void> _storeAuthData(
    String token,
    Map<String, dynamic> userData,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(userData));
  }

  /// Clear all authentication data
  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    await prefs.remove(_refreshTokenKey);

    _authToken = null;
    _currentUser = null;

    // Clear token from API service
    _apiService.setAuthToken(null);
  }

  /// Verify if current token is valid
  Future<bool> _verifyToken() async {
    try {
      if (_authToken == null) return false;

      final response = await _apiService.verifyToken();
      return response['valid'] == true;
    } catch (e) {
      print('Token verification error: $e');
      return false;
    }
  }

  /// Refresh authentication token
  Future<bool> _refreshAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(_refreshTokenKey);

      if (refreshToken == null) return false;

      final response = await _apiService.refreshToken(refreshToken);

      if (response['success'] == true) {
        final newToken = response['token'];
        if (newToken != null) {
          _authToken = newToken;
          await prefs.setString(_tokenKey, newToken);
          return true;
        }
      }

      return false;
    } catch (e) {
      print('Token refresh error: $e');
      return false;
    }
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    try {
      final response = await _apiService.resetPassword(email);
      return response['success'] == true;
    } catch (e) {
      print('Reset password error: $e');
      return false;
    }
  }
}

/// Authentication result wrapper
class AuthResult {
  final bool isSuccess;
  final String? message;
  final User? user;

  AuthResult._({required this.isSuccess, this.message, this.user});

  factory AuthResult.success(User user) {
    return AuthResult._(isSuccess: true, user: user);
  }

  factory AuthResult.failure(String message) {
    return AuthResult._(isSuccess: false, message: message);
  }
}
