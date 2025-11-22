import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../utils/app_dimensions.dart';
import '../widgets/prayer_request_card.dart';

class PrayerRequestScreen extends StatefulWidget {
  const PrayerRequestScreen({super.key});

  @override
  State<PrayerRequestScreen> createState() => _PrayerRequestScreenState();
}

class _PrayerRequestScreenState extends State<PrayerRequestScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Answered', 'Urgent', 'Ongoing', 'New'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with Gold Gradient Title
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            floating: true,
            pinned: true,
            expandedHeight: 120,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: ShaderMask(
                shaderCallback: (bounds) =>
                    AppColors.goldGradient.createShader(bounds),
                child: Text(
                  'Prayer Requests',
                  style: GoogleFonts.archivoBlack(
                    fontSize: 24,
                    letterSpacing: -1.5,
                    height: 1.0,
                    color: Colors.white,
                  ),
                ),
              ),
              centerTitle: false,
              titlePadding: EdgeInsets.only(left: AppSpacing.xl, bottom: 16),
            ),
            actions: [
              // Add Prayer Request Button
              Padding(
                padding: EdgeInsets.only(right: AppSpacing.md),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.subtleGoldGradient,
                    borderRadius: AppBorderRadius.md,
                    boxShadow: [AppShadows.goldGlow],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add, color: Colors.black, size: 20),
                    onPressed: _addNewPrayerRequest,
                  ),
                ),
              ),
            ],
          ),

          // Filter Categories (Transaction UI Pattern - Generous Horizontal Spacing)
          SliverToBoxAdapter(
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = filter == _selectedFilter;
                  return Container(
                    margin: EdgeInsets.only(right: AppSpacing.md),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => setState(() => _selectedFilter = filter),
                        borderRadius: AppBorderRadius.lg,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.dark800,
                            borderRadius: AppBorderRadius.lg,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.white12,
                              width: 1,
                            ),
                            boxShadow: isSelected
                                ? [AppShadows.goldGlow]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              filter,
                              style: GoogleFonts.archivo(
                                fontSize: AppTypographyScale.secondaryText,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.black : Colors.white,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Main Content - Bento Grid Layout with Generous Spacing
          SliverPadding(
            padding: EdgeInsets.all(AppSpacing.xl), // 32px major padding
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Overview Cards (Bento Grid Pattern)
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatsCard(
                          'Total Requests',
                          '248',
                          Icons.favorite_border,
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildStatsCard(
                          'This Week',
                          '12',
                          Icons.trending_up,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md),

                  // Active Prayer Request (Large Featured Card)
                  _buildFeaturedPrayerCard(),
                  SizedBox(height: AppSpacing.lg),

                  // Section Header
                  Text(
                    'Recent Requests',
                    style: GoogleFonts.archivoBlack(
                      fontSize: 20,
                      letterSpacing: -1.5,
                      height: 1.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),

          // Prayer Requests List (Transaction UI Pattern)
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final request = _getFilteredRequests()[index];
                return PrayerRequestCard(
                  requestTitle: request.title,
                  requesterName: request.requesterName,
                  timeAgo: request.timeAgo,
                  prayerCount: request.prayerCount,
                  status: request.status,
                  onTap: () => _openPrayerDetail(request),
                );
              }, childCount: _getFilteredRequests().length),
            ),
          ),

          // Bottom Spacing
          SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  /// Stats Card (Small Bento Grid Element)
  Widget _buildStatsCard(String title, String count, IconData icon) {
    return Container(
      height: 80,
      padding: EdgeInsets.all(AppSpacing.cardInternal),
      decoration: BoxDecoration(
        color: AppColors.dark800,
        borderRadius: AppBorderRadius.xl,
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 16),
              SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.archivo(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[400],
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerLeft,
            child: ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.goldGradient.createShader(bounds),
              child: Text(
                count,
                style: GoogleFonts.archivoBlack(
                  fontSize: 24,
                  letterSpacing: -1.5,
                  height: 1.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Featured Prayer Card (Large Bento Grid Element)
  Widget _buildFeaturedPrayerCard() {
    return Container(
      height: 140,
      padding: EdgeInsets.all(AppSpacing.cardInternal),
      decoration: BoxDecoration(
        color: AppColors.dark800,
        borderRadius: AppBorderRadius.xl,
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
        boxShadow: [AppShadows.goldGlow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with priority indicator
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs / 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: AppBorderRadius.sm,
                ),
                child: Text(
                  'FEATURED',
                  style: GoogleFonts.archivo(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Spacer(),
              Text(
                '2h ago',
                style: GoogleFonts.archivo(
                  fontSize: AppTypographyScale.metadataText,
                  color: Colors.grey[500],
                  height: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),

          // Prayer content
          Text(
            'Healing for my grandmother\'s surgery tomorrow',
            style: GoogleFonts.archivo(
              fontSize: AppTypographyScale.primaryText,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSpacing.xs),

          Text(
            'by Sarah Johnson',
            style: GoogleFonts.archivo(
              fontSize: AppTypographyScale.secondaryText,
              color: Colors.grey[400],
              height: 1.4,
            ),
          ),

          Spacer(),

          // Action row
          Row(
            children: [
              Icon(Icons.favorite, color: AppColors.primary, size: 16),
              SizedBox(width: AppSpacing.xs),
              Text(
                '47 prayers',
                style: GoogleFonts.archivo(
                  fontSize: AppTypographyScale.metadataText,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.subtleGoldGradient,
                  borderRadius: AppBorderRadius.sm,
                ),
                child: Text(
                  'PRAY',
                  style: GoogleFonts.archivo(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Sample data
  List<PrayerRequestData> _getFilteredRequests() {
    final allRequests = [
      PrayerRequestData(
        title: 'Job interview tomorrow',
        requesterName: 'Michael Chen',
        timeAgo: '3h ago',
        prayerCount: 23,
        status: PrayerStatus.urgent,
      ),
      PrayerRequestData(
        title: 'Safe travels for mission trip',
        requesterName: 'Grace Williams',
        timeAgo: '5h ago',
        prayerCount: 31,
        status: PrayerStatus.ongoing,
      ),
      PrayerRequestData(
        title: 'Marriage reconciliation',
        requesterName: 'David Thompson',
        timeAgo: '1d ago',
        prayerCount: 89,
        status: PrayerStatus.answered,
      ),
      PrayerRequestData(
        title: 'Financial provision',
        requesterName: 'Lisa Martinez',
        timeAgo: '2d ago',
        prayerCount: 156,
        status: PrayerStatus.ongoing,
      ),
      PrayerRequestData(
        title: 'Wisdom in decision making',
        requesterName: 'James Wilson',
        timeAgo: '3d ago',
        prayerCount: 67,
        status: PrayerStatus.new_request,
      ),
    ];

    if (_selectedFilter == 'All') return allRequests;

    return allRequests.where((request) {
      switch (_selectedFilter) {
        case 'Answered':
          return request.status == PrayerStatus.answered;
        case 'Urgent':
          return request.status == PrayerStatus.urgent;
        case 'Ongoing':
          return request.status == PrayerStatus.ongoing;
        case 'New':
          return request.status == PrayerStatus.new_request;
        default:
          return true;
      }
    }).toList();
  }

  void _addNewPrayerRequest() {
    debugPrint('Add new prayer request');
    // Navigate to add prayer screen
  }

  void _openPrayerDetail(PrayerRequestData request) {
    debugPrint('Open prayer detail: ${request.title}');
    // Navigate to prayer detail screen
  }
}
