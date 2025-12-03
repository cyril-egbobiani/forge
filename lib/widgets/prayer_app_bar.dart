import 'package:flutter/material.dart';
import 'package:forge/utils/responsive_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_dimensions.dart';
import '../utils/app_colors.dart';

class PrayerAppBar extends StatelessWidget {
  const PrayerAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      backgroundColor: AppColors.background,
      expandedHeight: ResponsiveHelper.h(160),
      floating: true,
      snap: true,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(color: AppColors.dark950),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Prayer Requests',
                    style: GoogleFonts.archivoBlack(
                      fontSize: 24,
                      letterSpacing: -1.5,
                      height: 1.0,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'Share your heart with the community',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
