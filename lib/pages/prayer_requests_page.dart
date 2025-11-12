import 'package:flutter/material.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_dimensions.dart';
import '../utils/app_colors.dart';
import '../utils/responsive_helper.dart';
import '../services/api_service.dart';
import '../models/prayer_request.dart';
import '../screens/prayer_detail_screen.dart';
import '../screens/new_prayer_screen.dart';

class PrayerRequestsPage extends StatefulWidget {
  const PrayerRequestsPage({super.key});

  @override
  State<PrayerRequestsPage> createState() => _PrayerRequestsPageState();
}

class _PrayerRequestsPageState extends State<PrayerRequestsPage>
    with TickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  List<PrayerRequest> _prayerRequests = [];
  bool _isLoading = true;
  String? _error;
  String _selectedCategory = 'All';
  late TabController _tabController;

  final List<String> _categories = [
    'All',
    'Personal',
    'Family',
    'Health',
    'Church',
    'Community',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadPrayerRequests();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadPrayerRequests() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
          _error = null;
        });
      }

      // First, establish connection
      final healthResult = await _apiService.healthCheck();
      if (healthResult == null) {
        throw Exception('Unable to connect to server');
      }

      // Now get prayer requests
      final prayerRequests = await _apiService.getPrayerRequests();

      if (mounted) {
        setState(() {
          _prayerRequests = prayerRequests;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load prayer requests: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context, designWidth: 375, designHeight: 812);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildActiveRequests(),
                  _buildAnsweredPrayers(),
                  _buildMyRequests(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNewPrayerScreen(),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: Icon(Icons.add),
        label: Text('New Prayer'),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.favorite,
                color: Colors.red,
                size: ResponsiveHelper.w(28),
              ),
              SizedBox(width: ResponsiveHelper.w(12)),
              Text(
                'Prayer Requests',
                style: AppTextStyles.h3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: _loadPrayerRequests,
                icon: Icon(Icons.refresh, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(8)),
          Text(
            'Join our community in prayer',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.dark900,
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
      ),
      child: TabBar(
        controller: _tabController,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.6),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        tabs: [
          Tab(text: 'Active'),
          Tab(text: 'Answered'),
          Tab(text: 'My Prayers'),
        ],
      ),
    );
  }

  Widget _buildActiveRequests() {
    return Column(
      children: [
        _buildCategoryFilter(),
        Expanded(
          child: _buildPrayerList(
            _prayerRequests
                .where(
                  (prayer) =>
                      prayer.status != 'answered' &&
                      (_selectedCategory == 'All' ||
                          prayer.category == _selectedCategory),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAnsweredPrayers() {
    return _buildPrayerList(
      _prayerRequests.where((prayer) => prayer.status == 'answered').toList(),
    );
  }

  Widget _buildMyRequests() {
    // TODO: Filter by current user once authentication is added
    return _buildPrayerList(_prayerRequests);
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: ResponsiveHelper.h(50),
      margin: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;

          return Container(
            margin: EdgeInsets.only(right: ResponsiveHelper.w(8)),
            child: FilterChip(
              label: Text(
                category,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              backgroundColor: AppColors.dark900,
              selectedColor: AppColors.primary,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected ? AppColors.primary : Colors.grey,
                width: 1,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPrayerList(List<PrayerRequest> prayers) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (prayers.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadPrayerRequests,
      color: AppColors.primary,
      child: ListView.builder(
        padding: EdgeInsets.all(AppSpacing.md),
        itemCount: prayers.length,
        itemBuilder: (context, index) {
          final prayer = prayers[index];
          return _buildPrayerCard(prayer);
        },
      ),
    );
  }

  Widget _buildPrayerCard(PrayerRequest prayer) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(16)),
      decoration: BoxDecoration(
        color: AppColors.dark900,
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(16)),
        border: Border.all(
          color: prayer.status == 'answered'
              ? Colors.green.withOpacity(0.3)
              : AppColors.dark800,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _openPrayerDetail(prayer),
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(16)),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status and category
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.w(8),
                      vertical: ResponsiveHelper.h(4),
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(
                        prayer.category,
                      ).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.r(12),
                      ),
                    ),
                    child: Text(
                      prayer.category.toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        color: _getCategoryColor(prayer.category),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Spacer(),
                  if (prayer.status == 'answered')
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.w(8),
                        vertical: ResponsiveHelper.h(4),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.r(12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: ResponsiveHelper.w(12),
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
                  SizedBox(width: ResponsiveHelper.w(8)),
                  Text(
                    prayer.timeAgo,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),

              SizedBox(height: ResponsiveHelper.h(12)),

              // Prayer title
              Text(
                prayer.title,
                style: AppTextStyles.h6.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: ResponsiveHelper.h(8)),

              // Prayer description
              Text(
                prayer.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: ResponsiveHelper.h(16)),

              // Footer with author and prayer count
              Row(
                children: [
                  CircleAvatar(
                    radius: ResponsiveHelper.w(12),
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                    child: Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: ResponsiveHelper.w(14),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.w(8)),
                  Expanded(
                    child: Text(
                      'Anonymous', // TODO: Use prayer.author when authentication is added
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _addPrayer(prayer),
                    icon: Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                      size: ResponsiveHelper.w(20),
                    ),
                  ),
                  Text(
                    '12', // TODO: Add prayer count to model
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: ResponsiveHelper.h(16)),
          Text(
            'Loading prayers...',
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
            onPressed: _loadPrayerRequests,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            color: Colors.white.withOpacity(0.3),
            size: ResponsiveHelper.w(64),
          ),
          SizedBox(height: ResponsiveHelper.h(16)),
          Text(
            'No prayer requests yet',
            style: AppTextStyles.h6.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(8)),
          Text(
            'Be the first to share a prayer request',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(24)),
          ElevatedButton.icon(
            onPressed: () => _openNewPrayerScreen(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(24),
                vertical: ResponsiveHelper.h(12),
              ),
            ),
            icon: Icon(Icons.add),
            label: Text('Add Prayer Request'),
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

  void _openPrayerDetail(PrayerRequest prayer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrayerDetailScreen(prayer: prayer),
      ),
    );
  }

  void _openNewPrayerScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPrayerScreen()),
    );

    if (result == true) {
      _loadPrayerRequests(); // Refresh the list
    }
  }

  void _addPrayer(PrayerRequest prayer) {
    // TODO: Implement prayer support functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Praying for: ${prayer.title}'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
