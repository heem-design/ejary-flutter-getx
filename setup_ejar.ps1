
# ==========================================
# EJAR - Flutter Clean Architecture Setup
# GetX + GetStorage
# ==========================================

Write-Host "Starting Ejar project setup..." -ForegroundColor Cyan

# 1. Install packages
flutter pub add get
flutter pub add get_storage
flutter pub add shared_preferences

# 2. Create directories
$dirs = @(
    "lib/core/constants",
    "lib/core/theme",
    "lib/core/locale",
    "lib/core/utils",
    "lib/routes",

    "lib/features/splash/data/datasources",
    "lib/features/splash/data/models",
    "lib/features/splash/data/repositories",
    "lib/features/splash/domain/entities",
    "lib/features/splash/domain/repositories",
    "lib/features/splash/domain/usecases",
    "lib/features/splash/presentation/controllers",
    "lib/features/splash/presentation/bindings",
    "lib/features/splash/presentation/screens",

    "lib/features/pin/data/datasources",
    "lib/features/pin/data/models",
    "lib/features/pin/data/repositories",
    "lib/features/pin/domain/entities",
    "lib/features/pin/domain/repositories",
    "lib/features/pin/domain/usecases",
    "lib/features/pin/presentation/controllers",
    "lib/features/pin/presentation/bindings",
    "lib/features/pin/presentation/screens",

    "lib/features/home/data/datasources",
    "lib/features/home/data/models",
    "lib/features/home/data/repositories",
    "lib/features/home/domain/entities",
    "lib/features/home/domain/repositories",
    "lib/features/home/domain/usecases",
    "lib/features/home/presentation/controllers",
    "lib/features/home/presentation/bindings",
    "lib/features/home/presentation/screens"
)

$dirs | ForEach-Object {
    New-Item -ItemType Directory -Path $_ -Force | Out-Null
}

# 3. App Constants
@'
class AppConstants {
  AppConstants._();

  static const String appName = 'Ejar';
  static const String appVersion = '1.0.0';
  static const String storageName = 'ejar_storage';
}
'@ | Set-Content "lib/core/constants/app_constants.dart" -Encoding utf8

# 4. App Theme
@'
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFF1565C0);
  static const Color backgroundColor = Color(0xFFF8F9FA);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
  );
}
'@ | Set-Content "lib/core/theme/app_theme.dart" -Encoding utf8

# 5. App Routes
@'
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String pin = '/pin';
  static const String home = '/home';
}
'@ | Set-Content "lib/routes/app_routes.dart" -Encoding utf8

# 6. Splash Controller
@'
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }
}
'@ | Set-Content "lib/features/splash/presentation/controllers/splash_controller.dart" -Encoding utf8

# 7. Splash Binding
@'
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
'@ | Set-Content "lib/features/splash/presentation/bindings/splash_binding.dart" -Encoding utf8

# 8. Splash Screen
@'
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.home_work_rounded,
              size: 90,
              color: Color(0xFF1565C0),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ejar',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Welcome to Ejar',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
'@ | Set-Content "lib/features/splash/presentation/screens/splash_screen.dart" -Encoding utf8

# 9. App Pages
@'
import 'package:get/get.dart';
import '../features/splash/presentation/bindings/splash_binding.dart';
import '../features/splash/presentation/screens/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
  ];
}
'@ | Set-Content "lib/routes/app_pages.dart" -Encoding utf8

# 10. Main
@'
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init(AppConstants.storageName);

  runApp(const EjarApp());
}

class EjarApp extends StatelessWidget {
  const EjarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
'@ | Set-Content "lib/main.dart" -Encoding utf8

# 11. Update pubspec project information
(Get-Content "pubspec.yaml" -Raw) `
    -replace '(?m)^name:.*$', 'name: ejar' `
    | Set-Content "pubspec.yaml" -Encoding utf8

# 12. Get dependencies
flutter pub get

Write-Host ""
Write-Host "====================================" -ForegroundColor Green
Write-Host " EJAR PROJECT CREATED SUCCESSFULLY " -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""

# 13. Analyze project
flutter analyze

# 14. Run project
Write-Host "Run your project using: flutter run" -ForegroundColor Cyan
