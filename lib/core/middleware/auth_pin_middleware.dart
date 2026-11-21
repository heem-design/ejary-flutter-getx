import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/ejary_storage_service.dart';
import '../../routes/app_routes.dart';

class AuthPinMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final storageService = Get.find<EjaryStorageService>();
    if (!storageService.isAuthenticated.value) {
      return const RouteSettings(name: AppRoutes.pin);
    }
    return null;
  }
}
