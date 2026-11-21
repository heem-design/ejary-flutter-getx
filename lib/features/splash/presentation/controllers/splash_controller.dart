import 'package:get/get.dart';
import '../../../../core/services/ejary_storage_service.dart';
import '../../../../routes/app_routes.dart';

class SplashController extends GetxController {
  final EjaryStorageService _storageService = Get.find<EjaryStorageService>();

  @override
  void onReady() {
    super.onReady();
    _decideNextRoute();
  }

  Future<void> _decideNextRoute() async {
    await Future.delayed(const Duration(milliseconds: 1400));
    final hasPin = _storageService.getPin() != null;
    if (!hasPin || !_storageService.isAuthenticated.value) {
      Get.offAllNamed(AppRoutes.pin);
    } else {
      Get.offAllNamed(AppRoutes.home);
    }
  }
}
