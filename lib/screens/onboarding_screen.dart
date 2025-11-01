import 'package:flutter/material.dart';
import 'package:forge/utils/app_colors.dart';
import 'package:lottie/lottie.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_dimensions.dart';
import '../utils/responsive_helper.dart';
import 'sign_up_screen.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              children: [
                // Status bar spacing
                SizedBox(height: ResponsiveHelper.h(20)),

                // Icons Section
                Expanded(flex: 6, child: _buildIconsSection()),

                // Content Section
                Expanded(flex: 3, child: _buildContentSection()),

                // Buttons Section
                Expanded(flex: 2, child: _buildButtonsSection(context)),

                // Bottom spacing
                SizedBox(height: ResponsiveHelper.h(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconsSection() {
    return Center(
      child: SizedBox(
        width: ResponsiveHelper.w(375),
        height: ResponsiveHelper.h(375),
        child: Lottie.asset(
          'assets/animations/3dIcon.json',
          width: ResponsiveHelper.w(376),
          height: ResponsiveHelper.h(408),
          fit: BoxFit.contain,
          repeat: true,
          animate: true,
          // Fallback widget while loading or if animation fails
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackIcons();
          },
          // Loading placeholder
          frameBuilder: (context, child, composition) {
            if (composition == null) {
              return _buildLoadingPlaceholder();
            }
            return child;
          },
        ),
      ),
    );
  }

  // Fallback icons in case Lottie animation doesn't load
  Widget _buildFallbackIcons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Top row - Trophy and Target
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildIcon('🏆', -20, -10),
            SizedBox(width: ResponsiveHelper.w(40)),
            _buildIcon('🎯', 20, -30),
          ],
        ),

        SizedBox(height: ResponsiveHelper.h(40)),

        // Middle - Puzzle piece (centered)
        _buildIcon('🧩', 0, 0, size: 80),

        SizedBox(height: ResponsiveHelper.h(40)),

        // Bottom row - Medal and Crown
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildIcon('🏅', -30, 10),
            SizedBox(width: ResponsiveHelper.w(40)),
            _buildIcon('👑', 10, -10),
          ],
        ),
      ],
    );
  }

  // Loading placeholder
  Widget _buildLoadingPlaceholder() {
    return Container(
      width: ResponsiveHelper.w(300),
      height: ResponsiveHelper.h(300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(20)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFFD700).withOpacity(0.3),
            const Color(0xFFFFA500).withOpacity(0.2),
            const Color(0xFFFF8C00).withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: ResponsiveHelper.w(40),
              height: ResponsiveHelper.w(40),
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(16)),
            Text(
              'Loading animation...',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(
    String emoji,
    double offsetX,
    double offsetY, {
    double size = 60,
  }) {
    return Transform.translate(
      offset: Offset(ResponsiveHelper.w(offsetX), ResponsiveHelper.h(offsetY)),
      child: Container(
        width: ResponsiveHelper.w(size),
        height: ResponsiveHelper.w(size),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveHelper.r(20)),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFD700), Color(0xFFFFA500), Color(0xFFFF8C00)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withOpacity(0.3),
              blurRadius: ResponsiveHelper.r(20),
              offset: Offset(0, ResponsiveHelper.h(8)),
            ),
          ],
        ),
        child: Center(
          child: Text(
            emoji,
            style: TextStyle(fontSize: ResponsiveHelper.sp(size * 0.5)),
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Build, Learn, Become',
          style: AppTextStyles.h2.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveHelper.sp(25),
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: ResponsiveHelper.h(12)),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'Connect with your community, deepen your faith, and grow into the person you\'re meant to be. Your journey starts here',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
              fontSize: ResponsiveHelper.sp(15),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildButtonsSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Sign up button (White)
        SizedBox(
          width: double.infinity,
          height: ResponsiveHelper.h(56),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()),
              );
            },
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
                fontSize: ResponsiveHelper.sp(15),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        SizedBox(height: ResponsiveHelper.h(16)),

        // Login button (Dark)
        SizedBox(
          width: double.infinity,
          height: ResponsiveHelper.h(56),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.dark800,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.r(28)),
              ),
            ),
            child: Text(
              'Login',
              style: AppTextStyles.buttonLarge.copyWith(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(15),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
