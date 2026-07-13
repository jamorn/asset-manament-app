// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/asset_provider.dart';
import 'providers/temp_photo_provider.dart';
import 'providers/audit_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/search_screen.dart';
import 'screens/temp_photo_screen.dart';
import 'screens/audit_screen.dart';
import 'screens/not_found_screen.dart';
import 'configs/routes.dart';
import 'config/theme.dart';
import 'models/audit_data.dart';
import 'models/sync_status.dart';
import 'models/asset_model.dart';  // ✅ เพิ่ม import
import 'services/offline_sync_service.dart';

// ✅ Global Error Handler
void _handleFlutterError(FlutterErrorDetails details) {
  debugPrint('🔥 Flutter Error: ${details.exception}');
  debugPrint('📍 Stack: ${details.stack}');
}

// ✅ Connectivity Listener
void _startConnectivityListener() {
  Connectivity().onConnectivityChanged.listen((result) {
    if (!result.contains(ConnectivityResult.none)) {
      debugPrint('📶 Internet connected → Auto Sync started');
      final syncService = OfflineSyncService();
      syncService.syncPendingAudits(showProgress: true);
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Hive.initFlutter();
    Hive.registerAdapter(AuditDataAdapter());
    Hive.registerAdapter(SyncStatusAdapter());
    await Hive.openBox<AuditData>('pending_audits');
    await Hive.openBox<SyncStatus>('sync_status');
    debugPrint('✅ Hive initialized successfully');
  } catch (e) {
    debugPrint('⚠️ Hive init failed: $e');
  }

  _startConnectivityListener();
  FlutterError.onError = _handleFlutterError;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully');
    runApp(const AssetApp());
  } catch (e) {
    debugPrint('❌ Firebase init failed: $e');
    runApp(ErrorApp(error: e.toString()));
  }
}

// ============================================================================
// 🚨 ErrorApp
// ============================================================================
class ErrorApp extends StatelessWidget {
  final String error;
  const ErrorApp({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asset Survey',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 72,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Application Initialization Failed',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please check your internet connection and try again.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Error: $error',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontFamily: 'monospace',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => main(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 🏠 AssetApp
// ============================================================================
class AssetApp extends StatelessWidget {
  const AssetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
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
        builder: (context, auth, themeProvider, _) {
          return MaterialApp(
            title: 'Asset Survey DEV',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeMode,
            initialRoute: AppRoutes.survey,
            routes: {
              AppRoutes.survey: (_) => const HomeScreen(),
              AppRoutes.dashboard: (_) => const DashboardScreen(),
              AppRoutes.search: (_) => const SearchScreen(),
              AppRoutes.tempPhotos: (_) => const TempPhotoScreen(),
            },
            onGenerateRoute: (settings) {
              // 📝 Audit Route (รับ AssetModel)
              if (settings.name == AppRoutes.audit) {
                final asset = settings.arguments as AssetModel?;  // ✅ AssetModel
                if (asset == null) {
                  return MaterialPageRoute(
                    builder: (_) => const HomeScreen(),
                  );
                }
                return MaterialPageRoute(
                  builder: (_) => AuditScreen(asset: asset),  // ✅ ส่ง AssetModel
                );
              }
              
              // 📄 Asset Detail Route (future)
              if (settings.name == AppRoutes.assetDetail) {
                final assetNo = settings.arguments as String?;
                if (assetNo == null || assetNo.isEmpty) {
                  return MaterialPageRoute(
                    builder: (_) => const HomeScreen(),
                  );
                }
                return MaterialPageRoute(
                  builder: (_) => Scaffold(
                    appBar: AppBar(title: Text('Asset Detail: $assetNo')),
                    body: const Center(
                      child: Text('Asset Detail Screen (Coming Soon)'),
                    ),
                  ),
                );
              }
              
              // ❌ Unknown Route
              return MaterialPageRoute(
                builder: (_) => const NotFoundScreen(),
              );
            },
            // ✅ ลบ onUnknownRoute ออก (onGenerateRoute จัดการหมดแล้ว)
          );
        },
      ),
    );
  }
}