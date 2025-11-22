import 'package:flutter/material.dart';
import 'package:forge/pages/games_page.dart';
import 'package:forge/pages/home_page.dart';
import 'package:forge/pages/teachings_page.dart';

import 'package:forge/utils/app_colors.dart';
import '../utils/responsive_helper.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/mini_player.dart';

import '../pages/events_page.dart';
import '../pages/profile_page.dart';
import 'package:forge/pages/chats_page.dart';
import 'api_test_screen.dart'; // Add this import

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
      const GamesPage(),
      const ChatsPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Color(0xFF000000)), // Pure black
        child: SafeArea(
          child: IndexedStack(index: _currentIndex, children: pages),
        ),
      ),
      bottomSheet: MiniPlayer(),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      // Add floating action button for API testing
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ApiTestScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.api, color: Colors.black),
      ),
    );
  }
}
