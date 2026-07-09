// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // 🆕 สร้างโดย flutterfire configure
import 'providers/auth_provider.dart';
import 'providers/asset_provider.dart';
import 'providers/temp_photo_provider.dart';
import 'providers/audit_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/search_screen.dart';
import 'configs/routes.dart';
import 'config/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AssetApp());
}

class AssetApp extends StatelessWidget {
  const AssetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
            create: (_) => ThemeProvider()), // 🟢 เพิ่ม ThemeProvider
        ChangeNotifierProxyProvider<AuthProvider, AssetProvider>(
          create: (_) => AssetProvider(),
          update: (_, auth, prev) =>
              prev!..updateRbacContext(auth.role, auth.allowedCostCenters),
        ),
        ChangeNotifierProxyProvider<AuthProvider, TempPhotoProvider>(
          create: (_) => TempPhotoProvider(),
          update: (_, auth, prev) =>
              prev!..updateRbacContext(auth.role, auth.allowedCostCenters),
        ),
        ChangeNotifierProxyProvider<AuthProvider, AuditProvider>(
          create: (_) => AuditProvider(),
          update: (_, auth, prev) =>
              prev!..updateRbacContext(auth.role, auth.allowedCostCenters),
        ),
      ],
      child: Consumer2<AuthProvider, ThemeProvider>(
        // 🟢 เปลี่ยนเป็น Consumer2 เพื่อฟังค่าจาก ThemeProvider ด้วย
        builder: (context, auth, themeProvider, _) {
          return MaterialApp(
            title: 'Asset Survey',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode:
                themeProvider.themeMode, // 🟢 ผูกตัวแปรควบคุมโหมดสีของระบบ
            initialRoute: AppRoutes.survey,
            routes: {
              AppRoutes.survey: (_) => const HomeScreen(),
              AppRoutes.dashboard: (_) => const DashboardScreen(),
              AppRoutes.search: (_) => const SearchScreen(),
            },
          );
        },
      ),
    );
  }
}
