import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/lucide.dart';
import '../models/prayer_request.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_dimensions.dart';
import '../utils/app_colors.dart';
import '../utils/time_utils.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

class PrayerCard extends StatelessWidget {
  final PrayerRequest request;
  final VoidCallback onTap;
  final VoidCallback? onEdit;

  const PrayerCard({
    super.key,
    required this.request,
    required this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.dark900,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: AppColors.dark800, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: AppSpacing.sm),
                _buildTitle(),
                SizedBox(height: AppSpacing.xs),
                _buildDescription(),
                SizedBox(height: AppSpacing.md),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: _getCategoryColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getCategoryColor().withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              request.category.isEmpty ? 'General' : request.category,
              style: AppTextStyles.caption.copyWith(
                color: _getCategoryColor(),
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.xs),
        Flexible(
          child: Text(
            TimeUtils.getTimeAgo(request.createdAt),
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      request.title.isEmpty ? 'Untitled Prayer' : request.title,
      style: AppTextStyles.bodySmall.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
        height: 1.2,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription() {
    return Text(
      request.description.isEmpty
          ? 'No description available'
          : request.description,
      style: AppTextStyles.bodyMedium.copyWith(
        color: Colors.white.withOpacity(0.7),
        height: 1.4,
        fontSize: 14,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter(BuildContext context) {
    final displayName = request.isAnonymous
        ? 'Anonymous'
        : (request.authorName?.trim().isNotEmpty == true
              ? request.authorName!.trim()
              : 'Unknown');
    final avatarLetter = (displayName.isNotEmpty && displayName != 'Anonymous')
        ? displayName[0].toUpperCase()
        : '?';
    // Get current user from Provider
    final currentUser = Provider.of<User?>(context, listen: false);
    final isOwnRequest =
        !request.isAnonymous &&
        currentUser != null &&
        request.authorId != null &&
        request.authorId == currentUser.id;
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(
            avatarLetter,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            'By $displayName',
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Iconify(Lucide.heart, size: 12, color: Colors.red.shade400),
              const SizedBox(width: 4),
              Text(
                '${request.prayerCount}',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.red.shade400,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        if (isOwnRequest && onEdit != null) ...[
          SizedBox(width: AppSpacing.xs),
          IconButton(
            icon: Icon(Icons.edit, color: AppColors.primary, size: 18),
            tooltip: 'Edit Prayer Request',
            onPressed: onEdit,
          ),
        ],
      ],
    );
  }

  Color _getCategoryColor() {
    switch (request.category.toLowerCase()) {
      case 'personal':
        return Colors.blue.shade500;
      case 'family':
        return Colors.green.shade500;
      case 'health':
        return Colors.red.shade500;
      case 'church':
        return Colors.purple.shade500;
      case 'community':
        return Colors.orange.shade500;
      default:
        return AppColors.primary;
    }
  }
}
