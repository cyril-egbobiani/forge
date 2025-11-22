import 'package:flutter/material.dart';
import 'package:forge/screens/home_screen.dart';
import 'package:forge/utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_dimensions.dart';
import '../utils/responsive_helper.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  final _authService = AuthService.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: AppColors.background),
        child: SafeArea(
          child: Column(
            children: [
              // Back button section - fixed at top
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ResponsiveHelper.h(16)),
                    _buildBackButton(),
                    SizedBox(height: ResponsiveHelper.h(16)),
                  ],
                ),
              ),

              // Main content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title section
                      _buildTitleSection(),

                      SizedBox(height: ResponsiveHelper.h(24)),

                      // Scrollable Form section
                      Expanded(
                        child: SingleChildScrollView(
                          child: _buildFormSection(),
                        ),
                      ),

                      SizedBox(height: ResponsiveHelper.h(24)),

                      // Login button - fixed at bottom
                      _buildLoginButton(),

                      SizedBox(height: ResponsiveHelper.h(30)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: ResponsiveHelper.w(40),
        height: ResponsiveHelper.w(40),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(ResponsiveHelper.r(8)),
        ),
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: ResponsiveHelper.w(20),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back',
          style: AppTextStyles.h1.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveHelper.sp(32),
          ),
        ),

        SizedBox(height: ResponsiveHelper.h(8)),

        Text(
          'It\'s helpful to provide a good reason for why the email address is required.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white.withOpacity(0.7),
            fontSize: ResponsiveHelper.sp(16),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email field
          _buildInputField(
            controller: _emailController,
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              if (!_isValidEmail(value.trim())) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),

          SizedBox(height: ResponsiveHelper.h(16)),

          // Password field
          _buildInputField(
            controller: _passwordController,
            hintText: 'Password',
            obscureText: _obscurePassword,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              child: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.white.withOpacity(0.5),
                size: ResponsiveHelper.w(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        style: AppTextStyles.bodyMedium.copyWith(
          color: Colors.white,
          fontSize: ResponsiveHelper.sp(16),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white.withOpacity(0.5),
            fontSize: ResponsiveHelper.sp(16),
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          errorStyle: AppTextStyles.bodySmall.copyWith(
            color: Colors.red.shade300,
            fontSize: ResponsiveHelper.sp(12),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(20),
            vertical: ResponsiveHelper.h(16),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: ResponsiveHelper.h(56),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isLoading
              ? AppColors.primary.withOpacity(0.7)
              : AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.r(28)),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: ResponsiveHelper.w(24),
                height: ResponsiveHelper.w(24),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Login',
                style: AppTextStyles.buttonLarge.copyWith(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(16),
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (result.isSuccess) {
          _showSnackBar('Welcome back, ${result.user?.name}!');

          // Navigate to home screen and clear the login stack
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          _showSnackBar(result.message ?? 'Login failed');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Network error. Please try again.');
      }
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF000000),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.r(8)),
        ),
      ),
    );
  }
}
