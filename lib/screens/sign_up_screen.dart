import 'package:flutter/material.dart';
import 'package:forge/utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_dimensions.dart';
import '../utils/responsive_helper.dart';
import '../services/auth_service.dart';
import '../screens/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isSubscribed = false;
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  final _authService = AuthService.instance;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ResponsiveHelper
    ResponsiveHelper.init(context, designWidth: 375, designHeight: 812);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: AppColors.background),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button - fixed at top
              _buildHeader(),

              // Scrollable content section
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: ResponsiveHelper.h(16)),

                      // Title
                      _buildTitle(),

                      SizedBox(height: ResponsiveHelper.h(8)),

                      // Subtitle
                      _buildSubtitle(),

                      SizedBox(height: ResponsiveHelper.h(24)),

                      // Scrollable Form section
                      Expanded(
                        child: SingleChildScrollView(child: _buildForm()),
                      ),

                      // Sign up button - fixed at bottom
                      _buildSignUpButton(),

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

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: ResponsiveHelper.w(40),
              height: ResponsiveHelper.h(40),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(ResponsiveHelper.r(20)),
              ),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: ResponsiveHelper.w(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Create an Account',
      style: AppTextStyles.h2.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: ResponsiveHelper.sp(28),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'It\'s helpful to provide a good reason for why the email address is required.',
      style: AppTextStyles.bodyMedium.copyWith(
        color: Colors.white.withOpacity(0.7),
        fontSize: ResponsiveHelper.sp(14),
        height: 1.4,
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Username field
          _buildTextField(
            controller: _nameController,
            hintText: 'Username',
            isHighlighted: true,
          ),

          SizedBox(height: AppSpacing.md),

          // Email field
          _buildTextField(
            controller: _emailController,
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
          ),

          SizedBox(height: AppSpacing.md),

          // Password field
          _buildTextField(
            controller: _passwordController,
            hintText: 'Password',
            isPassword: true,
          ),

          SizedBox(height: AppSpacing.md),

          // Phone field
          _buildTextField(
            controller: _phoneController,
            hintText: 'Phone (optional)',
            keyboardType: TextInputType.phone,
          ),

          SizedBox(height: ResponsiveHelper.h(24)),

          // Newsletter checkbox
          _buildNewsletterCheckbox(),

          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
    bool isHighlighted = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
        border: Border.all(
          color: isHighlighted
              ? const Color(0xFFFFD700)
              : Colors.white.withOpacity(0.2),
          width: isHighlighted ? 2 : 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        keyboardType: keyboardType,
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
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(16),
            vertical: ResponsiveHelper.h(16),
          ),
          suffixIcon: isPassword
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  child: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.white.withOpacity(0.5),
                    size: ResponsiveHelper.w(20),
                  ),
                )
              : null,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $hintText';
          }
          if (hintText == 'Email' && !value.contains('@')) {
            return 'Please enter a valid email';
          }
          if (hintText == 'Password' && value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildNewsletterCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isSubscribed = !_isSubscribed;
            });
          },
          child: Container(
            width: ResponsiveHelper.w(20),
            height: ResponsiveHelper.w(20),
            margin: EdgeInsets.only(top: ResponsiveHelper.h(2)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ResponsiveHelper.r(4)),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1.5,
              ),
              color: _isSubscribed
                  ? const Color(0xFFFFD700)
                  : Colors.transparent,
            ),
            child: _isSubscribed
                ? Icon(
                    Icons.check,
                    color: Colors.black,
                    size: ResponsiveHelper.w(14),
                  )
                : null,
          ),
        ),

        SizedBox(width: ResponsiveHelper.w(12)),

        Expanded(
          child: Text(
            'Stay up to date with the latest news and resources delivered directly to your inbox',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.7),
              fontSize: ResponsiveHelper.sp(14),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      height: ResponsiveHelper.h(56),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSignUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isLoading ? Colors.grey : Colors.white,
          foregroundColor: Colors.black,
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
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Sign up',
                style: AppTextStyles.buttonLarge.copyWith(
                  color: Colors.black,
                  fontSize: ResponsiveHelper.sp(16),
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authService.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (result.isSuccess) {
          _showSnackBar('Welcome to Forge, ${result.user?.name}!');

          // Navigate to home screen and clear the registration stack
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        } else {
          _showSnackBar(result.message ?? 'Registration failed');
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2a2a2a),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.r(8)),
        ),
      ),
    );
  }
}
