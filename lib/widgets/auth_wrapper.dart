import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../screens/onboarding_screen.dart';
import '../screens/home_screen.dart';
import '../utils/app_colors.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();

  // Static method to refresh auth state from anywhere in the app
  static void refreshAuthState(BuildContext context) {
    final state = context.findAncestorStateOfType<_AuthWrapperState>();
    state?._checkAuthStatus();
  }
}

class _AuthWrapperState extends State<AuthWrapper> with WidgetsBindingObserver {
  final _authService = AuthService.instance;
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAuthStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Re-check auth when app comes to foreground
    if (state == AppLifecycleState.resumed) {
      _checkAuthStatus();
    }
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Initialize auth service and check for existing session
      final isAuth = await _authService.initializeAuth();

      if (mounted) {
        setState(() {
          _isAuthenticated = isAuth;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Auth initialization error: $e');
      if (mounted) {
        setState(() {
          _isAuthenticated = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingScreen();
    }

    // Navigate to appropriate screen based on auth state
    if (_isAuthenticated && _authService.currentUser != null) {
      return const HomeScreen();
    } else {
      return const OnboardingScreen();
    }
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a1a), Color(0xFF2a2a2a)],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo/icon placeholder
              Icon(Icons.church, size: 80, color: Colors.white),
              SizedBox(height: 24),
              Text(
                'Forge',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40),
              CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              SizedBox(height: 16),
              Text(
                'Loading...',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
