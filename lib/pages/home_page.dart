import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forge/pages/devotional_page.dart';
import 'package:forge/pages/donation_page.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_dimensions.dart';
import '../utils/responsive_helper.dart';
import '../pages/prayer_requests_page.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    currentUser = AuthService.instance.currentUser;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context, designWidth: 375, designHeight: 812);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: ResponsiveHelper.h(16)),

          // User Profile Section
          _buildUserProfile(),

          SizedBox(height: ResponsiveHelper.h(24)),

          SizedBox(height: ResponsiveHelper.h(16)),

          // The Word Section
          _buildTheWordSection(),

          SizedBox(height: ResponsiveHelper.h(32)),

          // Quick Actions Section
          _buildQuickActionsSection(context),

          SizedBox(
            height: ResponsiveHelper.h(100),
          ), // Bottom padding for nav bar
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return Row(
      children: [
        // User Avatar
        Container(
          width: ResponsiveHelper.w(48),
          height: ResponsiveHelper.w(48),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
          ),
          child: CircleAvatar(
            radius: ResponsiveHelper.w(22),
            backgroundColor: Colors.black,
            child: const Icon(Icons.person, color: Colors.white), // Fallback
          ),
        ),

        SizedBox(width: ResponsiveHelper.w(12)),

        // Greeting Text
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hey,',
                style: GoogleFonts.archivoBlack(
                  color: Colors.grey[400],
                  fontSize: ResponsiveHelper.sp(16),
                  height: 1.6,
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(4)),
              Text(
                currentUser?.name ?? 'Welcome',
                style: GoogleFonts.archivoBlack(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(16),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),

        // Notification Icon
        Container(
          width: ResponsiveHelper.w(40),
          height: ResponsiveHelper.w(40),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(ResponsiveHelper.r(8)),
          ),
          child: Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: ResponsiveHelper.w(20),
          ),
        ),
      ],
    );
  }

  Widget _buildTheWordSection() {
    return Container(
      height: ResponsiveHelper.h(280),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20), // Squircle corners
        border: Border.all(color: Colors.white12),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Main FAITH text with gold gradient
            Center(
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFD4AF37)],
                ).createShader(bounds),
                child: Text(
                  'FAITH',
                  style: GoogleFonts.archivoBlack(
                    fontSize: ResponsiveHelper.sp(60),
                    letterSpacing: -2.0,
                    height: 1.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Verse reference at bottom
            Positioned(
              bottom: ResponsiveHelper.h(20),
              left: ResponsiveHelper.w(20),
              right: ResponsiveHelper.w(20),
              child: Center(
                child: Text(
                  'HEBREWS 11:1',
                  style: GoogleFonts.archivo(
                    fontSize: ResponsiveHelper.sp(12),
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.6,
                  ),
                ),
              ),
            ),
            // Daily Word label at top
            Positioned(
              top: ResponsiveHelper.h(20),
              left: ResponsiveHelper.w(20),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(12),
                  vertical: ResponsiveHelper.h(6),
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                ),
                child: Text(
                  'DAILY WORD',
                  style: GoogleFonts.archivo(
                    fontSize: ResponsiveHelper.sp(10),
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.archivoBlack(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(24),
            letterSpacing: -1.5,
            height: 1.0,
          ),
        ),

        SizedBox(height: ResponsiveHelper.h(16)),

        // Action Cards
        _buildActionCard(
          context: context,
          title: 'Prayer Request',
          subtitle:
              'Submit your prayer requests and let the community pray with you',
          iconPath: 'assets/icons/prayer.svg',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrayerRequestsPage()),
            );
          },
        ),

        SizedBox(height: ResponsiveHelper.h(12)),

        _buildActionCard(
          context: context,
          title: 'Donation',
          subtitle:
              'Support the ministry and make a difference in the community',
          iconPath: 'assets/icons/donation.svg',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DonationPage()),
            );
          },
        ),

        SizedBox(height: ResponsiveHelper.h(12)),

        _buildActionCard(
          context: context,
          title: 'Devotionals',
          subtitle:
              'Daily devotionals to strengthen your faith and spiritual growth',
          iconPath: 'assets/icons/devotional.svg',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DevotionalPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          border: Border.all(color: Colors.white12),
          borderRadius: BorderRadius.circular(20), // Squircle corners
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.archivo(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveHelper.sp(16),
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: ResponsiveHelper.h(4)),

                  Text(
                    subtitle,
                    style: GoogleFonts.archivo(
                      color: Colors.grey[400],
                      fontSize: ResponsiveHelper.sp(12),
                      height: 1.6,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            SizedBox(width: ResponsiveHelper.w(12)),

            // Icon
            SizedBox(
              width: ResponsiveHelper.w(48),
              height: ResponsiveHelper.w(48),
              // decoration: BoxDecoration(
              //   color: AppColors.primary.withOpacity(0.1),
              //   borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
              // ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: ResponsiveHelper.w(24),
                  height: ResponsiveHelper.w(24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
