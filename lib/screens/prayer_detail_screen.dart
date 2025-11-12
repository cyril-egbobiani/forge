import 'package:flutter/material.dart';
import 'package:forge/utils/app_colors.dart';
import 'package:forge/utils/responsive_helper.dart';
import 'package:forge/utils/app_text_styles.dart';
import 'package:forge/utils/app_dimensions.dart';
import 'package:forge/models/prayer_request.dart';

class PrayerDetailScreen extends StatefulWidget {
  final PrayerRequest prayer;

  const PrayerDetailScreen({super.key, required this.prayer});

  @override
  State<PrayerDetailScreen> createState() => _PrayerDetailScreenState();
}

class _PrayerDetailScreenState extends State<PrayerDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPrayerHeader(),
                  SizedBox(height: AppSpacing.md),
                  _buildPrayerContent(),
                  SizedBox(height: AppSpacing.md),
                  _buildPrayerStats(),
                  SizedBox(height: AppSpacing.lg),
                  _buildActionButtons(),
                  SizedBox(height: AppSpacing.md),
                  _buildPrayerComments(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: _getCategoryColor(widget.prayer.category),
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.prayer.title,
          style: AppTextStyles.h6.copyWith(color: Colors.white, fontSize: 16),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _getCategoryColor(widget.prayer.category),
                _getCategoryColor(widget.prayer.category).withOpacity(0.8),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite,
                  size: 80,
                  color: Colors.white.withOpacity(0.8),
                ),
                SizedBox(height: 8),
                Text(
                  'Prayer Request',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(12),
                vertical: ResponsiveHelper.h(6),
              ),
              decoration: BoxDecoration(
                color: _getCategoryColor(
                  widget.prayer.category,
                ).withOpacity(0.2),
                borderRadius: BorderRadius.circular(ResponsiveHelper.r(20)),
              ),
              child: Text(
                widget.prayer.category.toUpperCase(),
                style: AppTextStyles.caption.copyWith(
                  color: _getCategoryColor(widget.prayer.category),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Spacer(),
            if (widget.prayer.status == 'answered')
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(12),
                  vertical: ResponsiveHelper.h(6),
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.r(20)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: ResponsiveHelper.w(16),
                    ),
                    SizedBox(width: ResponsiveHelper.w(4)),
                    Text(
                      'ANSWERED',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.h(16)),
        Text(
          widget.prayer.title,
          style: AppTextStyles.h4.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(8)),
        Row(
          children: [
            CircleAvatar(
              radius: ResponsiveHelper.w(16),
              backgroundColor: AppColors.primary.withOpacity(0.2),
              child: Icon(
                Icons.person,
                color: AppColors.primary,
                size: ResponsiveHelper.w(18),
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(8)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Anonymous', // TODO: Use actual author
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  widget.prayer.timeAgo,
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrayerContent() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.dark900,
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prayer Request',
            style: AppTextStyles.h6.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(12)),
          Text(
            widget.prayer.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.9),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.comment,
            count: '8', // TODO: Use actual comment count
            label: 'Comments',
            color: Colors.blue,
          ),
        ),
        SizedBox(width: ResponsiveHelper.w(16)),
        Expanded(
          child: _buildStatCard(
            icon: Icons.share,
            count: '3', // TODO: Use actual share count
            label: 'Shared',
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String count,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.dark900,
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: ResponsiveHelper.w(24)),
          SizedBox(height: ResponsiveHelper.h(4)),
          Text(
            count,
            style: AppTextStyles.h6.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Secondary actions
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _addComment,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withOpacity(0.3)),
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveHelper.h(12),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.r(8)),
                  ),
                ),
                icon: Icon(Icons.comment_outlined),
                label: Text('Comment'),
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(12)),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _sharePrayer,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withOpacity(0.3)),
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveHelper.h(12),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.r(8)),
                  ),
                ),
                icon: Icon(Icons.share_outlined),
                label: Text('Share'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrayerComments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prayer Comments',
          style: AppTextStyles.h6.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(12)),

        // Sample comments - TODO: Load real comments from backend
        _buildCommentCard(
          author: 'Sarah M.',
          comment:
              'Praying for strength and healing during this time. God is with you! 🙏',
          timeAgo: '2 hours ago',
        ),
        _buildCommentCard(
          author: 'John D.',
          comment: 'Our small group is praying for this request tonight.',
          timeAgo: '5 hours ago',
        ),
        _buildCommentCard(
          author: 'Mary K.',
          comment:
              'Lifted this up in prayer this morning. Trusting in God\'s plan.',
          timeAgo: '1 day ago',
        ),

        SizedBox(height: ResponsiveHelper.h(16)),

        Container(
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.dark900.withOpacity(0.5),
            borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Column(
            children: [
              Icon(
                Icons.add_comment,
                color: Colors.white.withOpacity(0.5),
                size: ResponsiveHelper.w(32),
              ),
              SizedBox(height: ResponsiveHelper.h(8)),
              Text(
                'Add your prayer comment',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(8)),
              ElevatedButton(
                onPressed: _addComment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.r(8)),
                  ),
                ),
                child: Text('Add Comment'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentCard({
    required String author,
    required String comment,
    required String timeAgo,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.dark900,
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: ResponsiveHelper.w(16),
            backgroundColor: AppColors.primary.withOpacity(0.2),
            child: Icon(
              Icons.person,
              color: AppColors.primary,
              size: ResponsiveHelper.w(16),
            ),
          ),
          SizedBox(width: ResponsiveHelper.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      author,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.w(8)),
                    Text(
                      timeAgo,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.h(4)),
                Text(
                  comment,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'personal':
        return Colors.blue;
      case 'family':
        return Colors.green;
      case 'health':
        return Colors.red;
      case 'church':
        return Colors.purple;
      case 'community':
        return Colors.orange;
      default:
        return AppColors.primary;
    }
  }

  void _addComment() {
    // TODO: Implement comment functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Comment feature coming soon!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _sharePrayer() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share feature coming soon!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
