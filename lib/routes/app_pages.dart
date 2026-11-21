import 'package:get/get.dart';
import '../core/middleware/auth_pin_middleware.dart';
import '../features/home/presentation/bindings/home_binding.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/pin/presentation/bindings/pin_binding.dart';
import '../features/pin/presentation/screens/pin_screen.dart';
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
    GetPage(
      name: AppRoutes.pin,
      page: () => const PinScreen(),
      binding: PinBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      middlewares: [AuthPinMiddleware()],
    ),
  ];
}
