import 'package:flutter/material.dart';
import 'package:forge/utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_dimensions.dart';
import '../utils/responsive_helper.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubscribed = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ResponsiveHelper
    ResponsiveHelper.init(context, designWidth: 375, designHeight: 812);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: AppColors.background),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button
              _buildHeader(),

              // Form content
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

                      // Form
                      Expanded(child: _buildForm()),

                      // Sign up button
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
            controller: _usernameController,
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
        onPressed: _handleSignUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.r(28)),
          ),
        ),
        child: Text(
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

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement sign up logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Account created successfully!',
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
}
