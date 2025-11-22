import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../utils/app_dimensions.dart';
import '../utils/app_text_styles.dart';

/// Prayer Request Card following transaction list UI patterns
/// Extracted design system: 72px rows, leading status icons, trailing metadata
class PrayerRequestCard extends StatelessWidget {
  final String requestTitle;
  final String requesterName;
  final String timeAgo;
  final int prayerCount;
  final PrayerStatus status;
  final VoidCallback? onTap;

  const PrayerRequestCard({
    super.key,
    required this.requestTitle,
    required this.requesterName,
    required this.timeAgo,
    required this.prayerCount,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.listRowHeight,
      margin: EdgeInsets.only(bottom: AppSpacing.xs),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppBorderRadius.md,
          child: Container(
            padding: AppListLayout.listRowPadding,
            decoration: BoxDecoration(
              color: AppColors.dark800,
              borderRadius: AppBorderRadius.md,
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                // Leading Status Icon (48px circle - transaction pattern)
                _buildStatusIcon(),
                SizedBox(width: AppSizes.listItemSpacing),

                // Content Area (flexible space - transaction pattern)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Primary Text (16px medium weight)
                      Text(
                        requestTitle,
                        style: GoogleFonts.archivo(
                          fontSize: AppTypographyScale.primaryText,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppSpacing.xs / 2),

                      // Secondary Text (14px regular)
                      Text(
                        'by $requesterName',
                        style: GoogleFonts.archivo(
                          fontSize: AppTypographyScale.secondaryText,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[400],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // Trailing Area (right-aligned metadata - transaction pattern)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Prayer Count (16px bold - amount pattern)
                    Text(
                      '$prayerCount',
                      style: GoogleFonts.archivo(
                        fontSize: AppTypographyScale.amountText,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(),
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs / 2),

                    // Time Metadata (12px low opacity)
                    Text(
                      timeAgo,
                      style: GoogleFonts.archivo(
                        fontSize: AppTypographyScale.metadataText,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[500],
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Status icon following transaction UI pattern (colored background + semantic icon)
  Widget _buildStatusIcon() {
    return Container(
      width: AppSizes.listAvatarSize,
      height: AppSizes.listAvatarSize,
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.15),
        borderRadius: AppBorderRadius.md,
        border: Border.all(color: _getStatusColor().withOpacity(0.3), width: 1),
      ),
      child: Icon(
        _getStatusIcon(),
        color: _getStatusColor(),
        size: AppSizes.listIconSize,
      ),
    );
  }

  /// Get status color following transaction UI color coding
  Color _getStatusColor() {
    switch (status) {
      case PrayerStatus.answered:
        return const Color(0xFF00C896); // Green for positive/answered
      case PrayerStatus.urgent:
        return const Color(0xFFFF6B6B); // Red for urgent/critical
      case PrayerStatus.ongoing:
        return AppColors.primary; // Gold for active/ongoing
      case PrayerStatus.new_request:
        return const Color(0xFF4ECDC4); // Teal for new requests
    }
  }

  /// Get status icon following transaction UI semantic patterns
  IconData _getStatusIcon() {
    switch (status) {
      case PrayerStatus.answered:
        return Icons.check_circle_outline;
      case PrayerStatus.urgent:
        return Icons.priority_high;
      case PrayerStatus.ongoing:
        return Icons.access_time;
      case PrayerStatus.new_request:
        return Icons.new_label_outlined;
    }
  }
}

/// Prayer request status enum for semantic organization
enum PrayerStatus { answered, urgent, ongoing, new_request }

/// Extended prayer list following transaction UI patterns
class PrayerRequestsList extends StatelessWidget {
  final List<PrayerRequestData> requests;

  const PrayerRequestsList({super.key, required this.requests});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return PrayerRequestCard(
          requestTitle: request.title,
          requesterName: request.requesterName,
          timeAgo: request.timeAgo,
          prayerCount: request.prayerCount,
          status: request.status,
          onTap: () {
            // Handle prayer request tap
            debugPrint('Tapped: ${request.title}');
          },
        );
      },
    );
  }
}

/// Data model for prayer requests
class PrayerRequestData {
  final String title;
  final String requesterName;
  final String timeAgo;
  final int prayerCount;
  final PrayerStatus status;

  const PrayerRequestData({
    required this.title,
    required this.requesterName,
    required this.timeAgo,
    required this.prayerCount,
    required this.status,
  });
}
