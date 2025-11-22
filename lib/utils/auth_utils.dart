import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/auth_wrapper.dart';

class AuthUtils {
  /// Logout user and refresh authentication state
  static Future<void> logout(BuildContext context) async {
    try {
      await AuthService.instance.logout();

      if (context.mounted) {
        // Refresh auth state to navigate to login screen
        AuthWrapper.refreshAuthState(context);

        // Show logout confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error logging out'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black,
          ),
        );
      }
    }
  }

  /// Check if user is currently authenticated
  static bool get isAuthenticated => AuthService.instance.isAuthenticated;

  /// Get current user
  static get currentUser => AuthService.instance.currentUser;

  /// Refresh authentication state manually
  static void refreshAuthState(BuildContext context) {
    AuthWrapper.refreshAuthState(context);
  }
}
