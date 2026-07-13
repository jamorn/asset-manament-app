import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'survey_screen.dart';
import 'survey_dev_screen.dart';
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
      const SurveyScreen(),
      const SurveyDevScreen(),
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
    final auth = context.watch<AuthProvider>();
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    // ถ้าไม่ได้ login → Tab Survey (0) และ Temp Photos (3) ต้อง redirect ไป login
    final needsLogin = auth.user == null || !auth.authorized;

    // ถ้า user == null (logout จริง) → แสดงหน้า Login แทน
    if (auth.user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Asset App')),
        body: Center(
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('กรุณาเข้าสู่ระบบ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('ระบบจำเป็นต้องยืนยันตัวตนผ่านบัญชี Google'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.read<AuthProvider>().login(),
                    icon: const Icon(Icons.login),
                    label: const Text('Sign in with Google'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // 🔄 ขณะโหลดสิทธิ์จาก Firestore → แสดง spinner
    if (auth.isAppLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // ถ้าอยู่ใน tab private แต่ยังไม่มีสิทธิ์ → ดึงไป tab Search
    if (needsLogin && (_currentIndex == 0 || _currentIndex == 3)) {
      // ใช้ postFrameCallback เพื่อไม่ให้ setState ใน build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _currentIndex = 1); // ไป Search (public)
      });
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          // ถ้าไม่ login → ปิด Survey (0) และ Temp Photos (3)
          if (needsLogin && (index == 0 || index == 3)) {
            return; // กดไม่ติด
          }
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
            icon: Icon(Icons.developer_mode_outlined),
            selectedIcon: Icon(Icons.developer_mode),
            label: 'Dev',
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
