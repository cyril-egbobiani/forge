import 'package:flutter/material.dart';
import 'package:forge/utils/app_colors.dart';
import '../utils/responsive_helper.dart';
import '../widgets/bottom_navigation.dart';
import '../pages/home_page.dart';
import '../pages/teachings_page.dart';
import '../pages/events_page.dart';
import '../pages/profile_page.dart';
import '../pages/more_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context, designWidth: 375, designHeight: 812);

    // List of pages corresponding to bottom navigation items
    final List<Widget> pages = [
      const HomePage(),
      const TeachingsPage(),
      const EventsPage(),
      const ProfilePage(),
      const MorePage(),
    ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: AppColors.background),
        child: SafeArea(
          child: IndexedStack(index: _currentIndex, children: pages),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
