import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/lucide.dart';
import 'package:forge/utils/app_colors.dart';
import 'package:forge/utils/app_dimensions.dart';
import 'package:forge/models/prayer_request.dart';

class PrayerDetailScreen extends StatefulWidget {
  final PrayerRequest prayer;

  const PrayerDetailScreen({super.key, required this.prayer});

  @override
  State<PrayerDetailScreen> createState() => _PrayerDetailScreenState();
}

class _PrayerDetailScreenState extends State<PrayerDetailScreen> {
  PrayerRequest? _currentPrayer;
  bool _hasUserPrayed = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentPrayer = widget.prayer;
    _checkIfUserPrayed();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _checkIfUserPrayed() {
    setState(() {
      _hasUserPrayed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPrayer == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildHeroAppBar(),
          SliverPadding(
            padding: EdgeInsets.all(AppSpacing.xl),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPrayerContentCard(),
                  SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatsCard(
                          'Prayers',
                          _currentPrayer!.prayerCount.toString(),
                          Lucide.heart,
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildStatsCard(
                          'Days',
                          _getDaysAgo(),
                          Lucide.clock,
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildStatsCard(
                          'Comments',
                          _getCommentsCount(),
                          Lucide.message_circle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      floating: true,
      pinned: true,
      expandedHeight: 140,
      leading: Container(
        margin: EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.dark800.withOpacity(0.9),
          borderRadius: AppBorderRadius.md,
          border: Border.all(color: Colors.white12),
        ),
        child: IconButton(
          icon: Iconify(
            Lucide.arrow_left,
            color: Colors.white,
            size: AppSizes.iconSm,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs / 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            borderRadius: AppBorderRadius.sm,
          ),
          child: Text(
            _currentPrayer!.category.toUpperCase(),
            style: GoogleFonts.archivo(
              fontSize: AppTypographyScale.metadataText,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: 1.2,
            ),
          ),
        ),
        centerTitle: false,
        titlePadding: EdgeInsets.only(
          left: AppSpacing.xl,
          bottom: AppSpacing.md,
        ),
      ),
    );
  }

  Widget _buildPrayerContentCard() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.cardInternal),
      decoration: BoxDecoration(
        color: AppColors.dark800,
        borderRadius: AppBorderRadius.xl,
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppSizes.avatarMd,
                height: AppSizes.avatarMd,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: AppBorderRadius.md,
                ),
                child: Iconify(
                  Lucide.user,
                  color: AppColors.primary,
                  size: AppSizes.iconMd,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentPrayer!.authorName ?? 'Anonymous',
                      style: GoogleFonts.archivo(
                        fontSize: AppTypographyScale.primaryText,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    Text(
                      _getTimeAgo(),
                      style: GoogleFonts.archivo(
                        fontSize: AppTypographyScale.metadataText,
                        color: Colors.grey[500],
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            _currentPrayer!.title,
            style: GoogleFonts.archivoBlack(
              fontSize: AppTypographyScale.primaryText * 1.5, // 24px (16 * 1.5)
              letterSpacing: -1.5,
              height: 1.2,
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            _currentPrayer!.description,
            style: GoogleFonts.archivo(
              fontSize: AppTypographyScale.primaryText,
              fontWeight: FontWeight.w400,
              color: Colors.grey[300],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(String label, String value, String lucideIcon) {
    return Container(
      constraints: BoxConstraints(
        minHeight: AppSizes.listRowHeight * 0.8, // Reduce min height slightly
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.dark800,
        borderRadius: AppBorderRadius.xl,
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Iconify(lucideIcon, color: AppColors.primary, size: AppSizes.iconSm),
          SizedBox(height: AppSpacing.xs / 2),
          Flexible(
            child: Text(
              value,
              style: GoogleFonts.archivoBlack(
                fontSize:
                    AppTypographyScale.primaryText * 0.9, // Slightly smaller
                letterSpacing: -1.0,
                height: 1.0,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: AppSpacing.xs / 4),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.archivo(
                fontSize:
                    AppTypographyScale.metadataText * 0.9, // Slightly smaller
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
                height: 1.1,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      width: double.infinity,
      height: AppSizes.buttonHeightLg,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _hasUserPrayed ? null : _prayForRequest,
          borderRadius: BorderRadius.circular(
            AppSizes.buttonHeightLg / 2,
          ), // Perfect pill shape
          child: Container(
            decoration: BoxDecoration(
              gradient: _hasUserPrayed
                  ? LinearGradient(
                      colors: [
                        AppColors.dark800.withOpacity(0.8),
                        AppColors.dark800,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                  : LinearGradient(
                      colors: [
                        Color(0xFFFFD700), // Bright gold top
                        Color(0xFFB8860B), // Deeper gold bottom
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
              borderRadius: BorderRadius.circular(
                AppSizes.buttonHeightLg / 2,
              ), // Perfect pill shape
              border: Border.all(
                color: _hasUserPrayed
                    ? AppColors.primary.withOpacity(0.3)
                    : Colors.transparent,
                width: 1,
              ),
              boxShadow: [
                if (!_hasUserPrayed) ...[
                  // Vibrant gold glow for active state
                  BoxShadow(
                    color: Color(0xFFFFD700).withOpacity(0.5),
                    blurRadius: AppSpacing.md,
                    offset: Offset(0, AppSpacing.xs),
                  ),
                  // Secondary deeper shadow
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: AppSpacing.sm,
                    offset: Offset(0, AppSpacing.xs / 2),
                  ),
                ] else ...[
                  // Subtle shadow for completed state
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: AppSpacing.xs,
                    offset: Offset(0, AppSpacing.xs / 2),
                  ),
                ],
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Iconify(
                  _hasUserPrayed ? Lucide.check_circle : Lucide.heart,
                  color: _hasUserPrayed ? AppColors.primary : Colors.black,
                  size: AppSizes.iconSm,
                ),
                SizedBox(width: AppSpacing.sm),
                Text(
                  _hasUserPrayed ? 'Prayed' : 'Pray',
                  style: GoogleFonts.archivoBlack(
                    fontSize: AppTypographyScale.secondaryText,
                    letterSpacing: 1.2,
                    color: _hasUserPrayed ? AppColors.primary : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(_currentPrayer!.createdAt);

    if (difference.inDays > 0) {
      return 'd ago';
    } else if (difference.inHours > 0) {
      return 'h ago';
    } else {
      return 'm ago';
    }
  }

  String _getDaysAgo() {
    final difference = DateTime.now().difference(_currentPrayer!.createdAt);
    return difference.inDays.toString();
  }

  String _getCommentsCount() {
    return _currentPrayer!.comments.length.toString();
  }

  void _prayForRequest() {
    HapticFeedback.lightImpact();
    setState(() {
      _hasUserPrayed = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Your prayer has been added '),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
