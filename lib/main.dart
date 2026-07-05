import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // 🆕 สร้างโดย flutterfire configure
import 'providers/auth_provider.dart';
import 'providers/asset_provider.dart';
import 'providers/temp_photo_provider.dart';
import 'providers/audit_provider.dart';
import 'screens/survey_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/search_screen.dart';
import 'configs/routes.dart';

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
        ChangeNotifierProvider(create: (_) => AuditProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'Asset Survey',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.blue,
              brightness: Brightness.light,
            ),
            initialRoute: AppRoutes.survey,
            routes: {
              AppRoutes.survey: (_) => const SurveyScreen(),
              AppRoutes.dashboard: (_) => const DashboardScreen(),
              AppRoutes.search: (_) => const SearchScreen(),
            },
          );
        },
      ),
    );
  }
}
