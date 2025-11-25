import 'package:flutter/material.dart';
import 'package:forge/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_dimensions.dart';
import '../utils/responsive_helper.dart';
import '../services/api_service.dart';
import '../models/teaching.dart';
import '../screens/teaching_detail_screen.dart';

class TeachingsPage extends StatefulWidget {
  const TeachingsPage({super.key});

  @override
  State<TeachingsPage> createState() => _TeachingsPageState();
}

class _TeachingsPageState extends State<TeachingsPage> {
  final ApiService _apiService = ApiService();
  List<Teaching> _teachings = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  String _selectedSeries = 'All';

  @override
  void initState() {
    super.initState();
    _loadTeachings();
  }

  Future<void> _loadTeachings() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
          _error = null;
        });
      }

      // First, establish connection (like in the test screen)
      final healthResult = await _apiService.healthCheck();
      if (healthResult == null) {
        throw Exception('Unable to connect to server');
      }

      // Now get teachings with established connection
      final teachings = await _apiService.getTeachings();

      if (mounted) {
        setState(() {
          _teachings = teachings;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load teachings: $e';
          _isLoading = false;
        });
      }
    }
  }

  List<Teaching> get _filteredTeachings {
    var filtered = _teachings.where((teaching) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          teaching.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          teaching.speaker.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          teaching.description.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

      final matchesSeries =
          _selectedSeries == 'All' ||
          (teaching.series?.toLowerCase() == _selectedSeries.toLowerCase());

      return matchesSearch && matchesSeries;
    }).toList();

    return filtered;
  }

  Set<String> get _availableSeries {
    final series = _teachings
        .where(
          (teaching) => teaching.series != null && teaching.series!.isNotEmpty,
        )
        .map((teaching) => teaching.series!)
        .toSet();
    return {'All', ...series};
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context, designWidth: 375, designHeight: 812);

    return RefreshIndicator(
      onRefresh: _loadTeachings,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ResponsiveHelper.h(16)),

            // Header with search
            _buildHeader(),

            SizedBox(height: ResponsiveHelper.h(24)),

            // Search and Filter
            _buildSearchAndFilter(),

            SizedBox(height: ResponsiveHelper.h(24)),

            // Content
            if (_isLoading)
              _buildLoadingState()
            else if (_error != null)
              _buildErrorState()
            else if (_teachings.isEmpty)
              _buildEmptyState()
            else
              _buildContent(),

            SizedBox(height: ResponsiveHelper.h(100)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'The Word',
          style: GoogleFonts.archivoBlack(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(24),
            letterSpacing: -1.5,
            height: 1.0,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(12),
            vertical: ResponsiveHelper.h(6),
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF2a2a2a),
            borderRadius: BorderRadius.circular(ResponsiveHelper.r(20)),
          ),
          child: Text(
            '${_teachings.length} teachings',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.7),
              fontSize: ResponsiveHelper.sp(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Column(
      children: [
        // Search Bar
        Container(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
          decoration: BoxDecoration(
            color: AppColors.dark900,
            borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
          ),
          child: TextField(
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search teachings, speakers...',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withOpacity(0.5),
              ),
              border: InputBorder.none,
              icon: Icon(Icons.search, color: Colors.white.withOpacity(0.5)),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),

        SizedBox(height: ResponsiveHelper.h(16)),

        // Series Filter
        if (_availableSeries.length > 1) _buildSeriesFilter(),
      ],
    );
  }

  Widget _buildSeriesFilter() {
    return SizedBox(
      height: ResponsiveHelper.h(40),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _availableSeries.length,
        itemBuilder: (context, index) {
          final series = _availableSeries.elementAt(index);
          final isSelected = series == _selectedSeries;

          return Container(
            margin: EdgeInsets.only(right: ResponsiveHelper.w(8)),
            child: FilterChip(
              showCheckmark: false,
              label: Text(
                series,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedSeries = series;
                });
              },
              backgroundColor: AppColors.dark900,
              selectedColor: const Color(0xFFFFD700),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(ResponsiveHelper.r(20)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: ResponsiveHelper.h(100)),
          const CircularProgressIndicator(color: Color(0xFFFFD700)),
          SizedBox(height: ResponsiveHelper.h(16)),
          Text(
            'Loading teachings...',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: ResponsiveHelper.h(100)),
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: ResponsiveHelper.w(48),
          ),
          SizedBox(height: ResponsiveHelper.h(16)),
          Text(
            _error!,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveHelper.h(16)),
          ElevatedButton(
            onPressed: _loadTeachings,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF000000),
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: ResponsiveHelper.h(100)),
          Icon(
            Icons.library_books,
            color: Colors.white.withOpacity(0.3),
            size: ResponsiveHelper.w(64),
          ),
          SizedBox(height: ResponsiveHelper.h(16)),
          Text(
            'No teachings found',
            style: AppTextStyles.h6.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(8)),
          Text(
            'Check back later for new content',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final filteredTeachings = _filteredTeachings;

    if (filteredTeachings.isEmpty) {
      return Center(
        child: Column(
          children: [
            SizedBox(height: ResponsiveHelper.h(100)),
            Icon(
              Icons.search_off,
              color: Colors.white.withOpacity(0.3),
              size: ResponsiveHelper.w(64),
            ),
            SizedBox(height: ResponsiveHelper.h(16)),
            Text(
              'No teachings match your search',
              style: AppTextStyles.h6.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(8)),
            Text(
              'Try adjusting your search or filters',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Featured Teaching (latest one)
        if (filteredTeachings.isNotEmpty)
          _buildFeaturedTeaching(filteredTeachings.first),

        SizedBox(height: ResponsiveHelper.h(24)),

        // Recent Teachings Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'All Teachings',
              style: AppTextStyles.h6.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveHelper.sp(18),
              ),
            ),
            Text(
              '${filteredTeachings.length} found',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withOpacity(0.5),
                fontSize: ResponsiveHelper.sp(12),
              ),
            ),
          ],
        ),

        SizedBox(height: ResponsiveHelper.h(16)),

        // Teaching List
        ...filteredTeachings.map((teaching) => _buildTeachingCard(teaching)),
      ],
    );
  }

  Widget _buildFeaturedTeaching(Teaching teaching) {
    // Demo video URL for featured teaching
    final demoVideoUrl =
        'https://www.youtube.com/live/ybDdGykAL-E?si=efSyqBaDKY3AhdSd';
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(8),
                  vertical: ResponsiveHelper.h(4),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
                ),
                child: Text(
                  'LATEST',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveHelper.sp(10),
                  ),
                ),
              ),
              const Spacer(),
              if (teaching.series != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(8),
                    vertical: ResponsiveHelper.h(4),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
                  ),
                  child: Text(
                    teaching.series!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: ResponsiveHelper.sp(10),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.h(12)),

          // Display demo video link
          Text(
            'Video Link: $demoVideoUrl',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.7),
              fontSize: ResponsiveHelper.sp(12),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(8)),

          // Replace video preview with demo video preview
          Container(
            height: ResponsiveHelper.h(120),
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
            ),
            child: Center(
              child: Icon(
                Icons.play_circle_filled,
                color: Colors.white,
                size: ResponsiveHelper.w(48),
              ),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(12)),

          Text(
            teaching.title,
            style: AppTextStyles.h6.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveHelper.sp(16),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: ResponsiveHelper.h(4)),

          Text(
            '${teaching.speaker} • ${teaching.durationText}',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.7),
              fontSize: ResponsiveHelper.sp(12),
            ),
          ),

          if (teaching.scripture != null) ...[
            SizedBox(height: ResponsiveHelper.h(4)),
            Text(
              teaching.scripture!,
              style: AppTextStyles.bodySmall.copyWith(
                color: const Color(0xFFFFD700),
                fontSize: ResponsiveHelper.sp(11),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],

          SizedBox(height: ResponsiveHelper.h(8)),

          Text(
            teaching.description,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.6),
              fontSize: ResponsiveHelper.sp(11),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: ResponsiveHelper.h(12)),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _playTeaching(teaching),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000000),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveHelper.h(12),
                    ),
                  ),
                  icon: Icon(
                    teaching.hasVideo
                        ? Icons.play_arrow
                        : teaching.hasAudio
                        ? Icons.play_arrow
                        : Icons.read_more,
                    size: ResponsiveHelper.w(20),
                  ),
                  label: Text(
                    teaching.hasVideo
                        ? 'Watch Now'
                        : teaching.hasAudio
                        ? 'Listen Now'
                        : 'Read Now',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveHelper.sp(14),
                    ),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(12)),
              IconButton(
                onPressed: () => _shareTeaching(teaching),
                icon: Icon(
                  Icons.share,
                  color: Colors.white.withOpacity(0.7),
                  size: ResponsiveHelper.w(24),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeachingCard(Teaching teaching) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
      ),
      child: InkWell(
        onTap: () => _playTeaching(teaching),
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
        child: Row(
          children: [
            Container(
              width: ResponsiveHelper.w(60),
              height: ResponsiveHelper.w(60),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(ResponsiveHelper.r(8)),
                image: teaching.hasVideo && teaching.thumbnailUrl != null
                    ? DecorationImage(
                        image: NetworkImage(teaching.thumbnailUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  if (teaching.hasVideo)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.r(8),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                  Center(
                    child: Icon(
                      teaching.hasVideo
                          ? Icons.play_circle_filled
                          : teaching.hasAudio
                          ? Icons.play_circle_filled
                          : Icons.text_fields,
                      color: Colors.white,
                      size: ResponsiveHelper.w(24),
                    ),
                  ),
                  if (teaching.hasVideo)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: EdgeInsets.all(ResponsiveHelper.w(1)),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          Icons.videocam,
                          color: Colors.white,
                          size: ResponsiveHelper.w(8),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(width: ResponsiveHelper.w(12)),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          teaching.title,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: ResponsiveHelper.sp(14),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (teaching.series != null) ...[
                        SizedBox(width: ResponsiveHelper.w(8)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.w(6),
                            vertical: ResponsiveHelper.h(2),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.r(8),
                            ),
                          ),
                          child: Text(
                            teaching.series!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.blue,
                              fontSize: ResponsiveHelper.sp(9),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  SizedBox(height: ResponsiveHelper.h(4)),

                  Text(
                    teaching.speaker,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: ResponsiveHelper.sp(12),
                    ),
                  ),

                  SizedBox(height: ResponsiveHelper.h(2)),

                  Row(
                    children: [
                      Text(
                        teaching.durationText,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: ResponsiveHelper.sp(11),
                        ),
                      ),
                      Text(
                        ' • ${teaching.formattedDate}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: ResponsiveHelper.sp(11),
                        ),
                      ),
                    ],
                  ),

                  if (teaching.scripture != null) ...[
                    SizedBox(height: ResponsiveHelper.h(2)),
                    Text(
                      teaching.scripture!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: const Color(0xFFFFD700),
                        fontSize: ResponsiveHelper.sp(10),
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            IconButton(
              onPressed: () => _showTeachingOptions(teaching),
              icon: Icon(
                Icons.more_vert,
                color: Colors.white.withOpacity(0.5),
                size: ResponsiveHelper.w(20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Action Methods
  void _playTeaching(Teaching teaching) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeachingDetailScreen(teaching: teaching),
      ),
    );
  }

  void _shareTeaching(Teaching teaching) {
    // TODO: Implement sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing: ${teaching.title}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showTeachingOptions(Teaching teaching) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2a2a2a),
      builder: (context) => Container(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.play_arrow, color: Colors.white),
              title: Text(
                teaching.hasAudio ? 'Play Audio' : 'Read Teaching',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _playTeaching(teaching);
              },
            ),
            ListTile(
              leading: Icon(Icons.share, color: Colors.white),
              title: Text(
                'Share Teaching',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _shareTeaching(teaching);
              },
            ),
            ListTile(
              leading: Icon(Icons.download, color: Colors.white),
              title: Text(
                'Download for Offline',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement download
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Download feature coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
