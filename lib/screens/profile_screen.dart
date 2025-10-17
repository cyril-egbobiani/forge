import 'package:flutter/material.dart';
import '../design_system.dart';
import '../widgets/common/section_widget.dart';
import '../data/mock_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Profile', style: AppTypography.titleMedium),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: AppColors.primary),
            onPressed: () {
              // TODO: Navigate to settings
              debugPrint('Navigate to settings');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSpacing.lg),

            // Profile Header
            _buildProfileHeader(),

            SizedBox(height: AppSpacing.section),

            // Quick Stats
            SectionWidget(title: 'Your Stats', content: _buildQuickStats()),

            SizedBox(height: AppSpacing.section),

            // Account Settings
            SectionWidget(title: 'Account', content: _buildAccountSettings()),

            SizedBox(height: AppSpacing.section),

            // App Settings
            SectionWidget(title: 'Preferences', content: _buildAppSettings()),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: AppDecorations.card,
      child: Column(
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.surfaceContainer,
            backgroundImage: NetworkImage(MockData.userInfo.avatarUrl),
          ),

          SizedBox(height: AppSpacing.xl),

          // Name
          Text(MockData.userInfo.name, style: AppTypography.headlineSmall),

          SizedBox(height: AppSpacing.sm),

          // Member since
          Text(
            'Member since January 2023',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.secondaryText,
            ),
          ),

          SizedBox(height: AppSpacing.xl),

          // Edit Profile Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Navigate to edit profile
                debugPrint('Edit profile');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.surface,
                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: Text(
                'Edit Profile',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.surface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Events Attended',
            value: '24',
            icon: Icons.event,
          ),
        ),
        SizedBox(width: AppSpacing.xl),
        Expanded(
          child: _buildStatCard(
            title: 'Prayer Requests',
            value: '8',
            icon: Icons.favorite,
          ),
        ),
        SizedBox(width: AppSpacing.xl),
        Expanded(
          child: _buildStatCard(
            title: 'Donations',
            value: '12',
            icon: Icons.volunteer_activism,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: AppIconSizes.lg),
          SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettings() {
    return Column(
      children: [
        _buildSettingItem(
          icon: Icons.person,
          title: 'Personal Information',
          subtitle: 'Update your details',
          onTap: () => debugPrint('Personal Information'),
        ),
        _buildSettingItem(
          icon: Icons.security,
          title: 'Privacy & Security',
          subtitle: 'Manage your privacy settings',
          onTap: () => debugPrint('Privacy & Security'),
        ),
        _buildSettingItem(
          icon: Icons.notifications,
          title: 'Notifications',
          subtitle: 'Customize your notifications',
          onTap: () => debugPrint('Notifications'),
        ),
      ],
    );
  }

  Widget _buildAppSettings() {
    return Column(
      children: [
        _buildSettingItem(
          icon: Icons.palette,
          title: 'Theme',
          subtitle: 'Light, Dark, or System',
          onTap: () => debugPrint('Theme'),
        ),
        _buildSettingItem(
          icon: Icons.language,
          title: 'Language',
          subtitle: 'English',
          onTap: () => debugPrint('Language'),
        ),
        _buildSettingItem(
          icon: Icons.help,
          title: 'Help & Support',
          subtitle: 'Get help and support',
          onTap: () => debugPrint('Help & Support'),
        ),
        _buildSettingItem(
          icon: Icons.logout,
          title: 'Sign Out',
          subtitle: 'Sign out of your account',
          onTap: () => debugPrint('Sign Out'),
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSpacing.lg),
        margin: EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? AppColors.error : AppColors.primary,
              size: AppIconSizes.lg,
            ),
            SizedBox(width: AppSpacing.xl),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelLarge.copyWith(
                      color: isDestructive
                          ? AppColors.error
                          : AppColors.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.tertiaryText,
              size: AppIconSizes.md,
            ),
          ],
        ),
      ),
    );
  }
}
