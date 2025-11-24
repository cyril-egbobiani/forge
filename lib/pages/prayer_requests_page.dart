import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/lucide.dart';
import '../utils/app_dimensions.dart';
import '../utils/app_colors.dart';
import '../services/prayer_service.dart';
import '../models/prayer_request.dart';
import '../screens/prayer_detail_screen.dart';
import '../screens/new_prayer_screen.dart';
import '../widgets/prayer_app_bar.dart';
import '../widgets/category_selector.dart';
import '../widgets/prayer_card.dart';
import '../widgets/loading_state_widget.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/empty_state_widget.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

class PrayerRequestsPage extends StatefulWidget {
  const PrayerRequestsPage({super.key});

  @override
  State<PrayerRequestsPage> createState() => _PrayerRequestsPageState();
}

class _PrayerRequestsPageState extends State<PrayerRequestsPage> {
  void _onEditPrayerRequest(PrayerRequest request) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewPrayerScreen(prayerRequest: request),
      ),
    ).then((_) {
      _loadPrayerRequests();
    });
  }

  final PrayerService _prayerService = PrayerService();
  List<PrayerRequest> _prayerRequests = [];
  bool _isLoading = true;
  String? _error;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadPrayerRequests();
  }

  Future<void> _loadPrayerRequests() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
          _error = null;
        });
      }

      final requests = await _prayerService.getPrayerRequests();

      if (mounted) {
        setState(() {
          _prayerRequests = requests;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onPrayerCardTap(PrayerRequest request) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrayerDetailScreen(prayer: request),
      ),
    );
  }

  void _openNewPrayerScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewPrayerScreen()),
    ).then((_) {
      _loadPrayerRequests();
    });
  }

  List<PrayerRequest> _getFilteredRequests() {
    return _prayerService.filterByCategory(_prayerRequests, _selectedCategory);
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const LoadingStateWidget();
    }

    if (_error != null) {
      return ErrorStateWidget(error: _error!, onRetry: _loadPrayerRequests);
    }

    final filteredRequests = _getFilteredRequests();
    if (filteredRequests.isEmpty) {
      return const EmptyStateWidget();
    }

    final currentUser = Provider.of<User?>(context, listen: false);
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final request = filteredRequests[index];
        final isOwnRequest =
            !request.isAnonymous &&
            currentUser != null &&
            request.authorId != null &&
            request.authorId == currentUser.id;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PrayerCard(
              request: request,
              onTap: () => _onPrayerCardTap(request),
              onEdit: isOwnRequest ? () => _onEditPrayerRequest(request) : null,
            ),
            // Debug: Show raw JSON for inspection
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ExpansionTile(
                  title: Text('Show Raw JSON', style: TextStyle(fontSize: 12)),
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        request.toJson().toString(),
                        style: TextStyle(fontSize: 11, color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }, childCount: filteredRequests.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          const PrayerAppBar(),
          SliverPadding(
            padding: EdgeInsets.only(
              top: AppSpacing.md,
              left: AppSpacing.md,
              right: AppSpacing.md,
            ),
            sliver: SliverToBoxAdapter(
              child: CategorySelector(
                categories: PrayerService.categories,
                selectedCategory: _selectedCategory,
                onCategorySelected: _onCategorySelected,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(AppSpacing.md),
            sliver: _buildContent(),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: _openNewPrayerScreen,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        icon: const Iconify(Lucide.plus, size: 20),
        label: const Text(
          'Create Prayer',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
