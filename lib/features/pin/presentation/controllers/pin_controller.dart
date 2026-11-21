import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/ejary_storage_service.dart';
import '../../../../routes/app_routes.dart';

class PinController extends GetxController {
  final EjaryStorageService _storageService = Get.find<EjaryStorageService>();
  final TextEditingController pinTextController = TextEditingController();

  final RxBool isSetupMode = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    isSetupMode.value = _storageService.getPin() == null;
  }

  void submitPin() {
    final code = pinTextController.text.trim();
    errorMessage.value = '';

    if (code.length != 4 || int.tryParse(code) == null) {
      errorMessage.value = 'pin_error_length'.tr;
      return;
    }

    if (isSetupMode.value) {
      _storageService.savePin(code).then((_) {
        pinTextController.clear();
        Get.offAllNamed(AppRoutes.home);
      });
    } else {
      final savedPin = _storageService.getPin();
      if (code == savedPin) {
        _storageService.setAuthenticated(true).then((_) {
          pinTextController.clear();
          Get.offAllNamed(AppRoutes.home);
        });
      } else {
        errorMessage.value = 'pin_error_wrong'.tr;
      }
    }
  }

  void resetPin() {
    _storageService.clearPin().then((_) {
      pinTextController.clear();
      errorMessage.value = '';
      isSetupMode.value = true;
    });
  }

  @override
  void onClose() {
    pinTextController.dispose();
    super.onClose();
  }
}
