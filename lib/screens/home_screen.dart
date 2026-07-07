import 'package:flutter/material.dart';
import 'survey_screen.dart';
import 'search_screen.dart';
import 'dashboard_screen.dart';
import 'temp_photo_screen.dart';

/// หน้า Home — มี BottomNavigationBar ครอบทุกหน้าหลัก
/// Tab 0: Survey, Tab 1: Search, Tab 2: Dashboard, Tab 3: Temp Photos
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      SurveyScreen(onTabSwitch: switchToTab),
      const SearchScreen(),
      const DashboardScreen(),
      const TempPhotoScreen(),
    ]);
  }

  void switchToTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        labelBehavior: isTablet
            ? NavigationDestinationLabelBehavior.onlyShowSelected
            : NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Survey',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.camera_alt_outlined),
            selectedIcon: Icon(Icons.camera_alt),
            label: 'Temp Photos',
          ),
        ],
      ),
    );
  }
}
