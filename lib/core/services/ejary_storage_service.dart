import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/app_constants.dart';

class EjaryStorageService extends GetxService {
  late final GetStorage _box;

  final RxBool isDarkMode = false.obs;
  final RxString langCode = 'ar'.obs;
  final RxBool isAuthenticated = false.obs;

  Future<EjaryStorageService> init() async {
    _box = GetStorage(AppConstants.storageName);
    isDarkMode.value = _box.read<bool>(AppConstants.keyIsDarkMode) ?? false;
    langCode.value = _box.read<String>(AppConstants.keyLangCode) ?? 'ar';
    isAuthenticated.value =
        _box.read<bool>(AppConstants.keyIsAuthenticated) ?? false;

    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    Get.updateLocale(Locale(langCode.value));
    return this;
  }

  String? getPin() => _box.read<String>(AppConstants.keyPinCode);

  Future<void> savePin(String pin) async {
    await _box.write(AppConstants.keyPinCode, pin);
    await setAuthenticated(true);
  }

  Future<void> clearPin() async {
    await _box.remove(AppConstants.keyPinCode);
    await setAuthenticated(false);
  }

  Future<void> setAuthenticated(bool value) async {
    isAuthenticated.value = value;
    await _box.write(AppConstants.keyIsAuthenticated, value);
  }

  Future<void> toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    await _box.write(AppConstants.keyIsDarkMode, isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleLanguage() async {
    langCode.value = langCode.value == 'ar' ? 'en' : 'ar';
    await _box.write(AppConstants.keyLangCode, langCode.value);
    Get.updateLocale(Locale(langCode.value));
  }
}
