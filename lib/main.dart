import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/bindings/initial_binding.dart';
import 'core/constants/app_constants.dart';
import 'core/locale/app_translations.dart';
import 'core/services/ejary_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init(AppConstants.storageName);

  final storageService = EjaryStorageService();
  await storageService.init();
  Get.put<EjaryStorageService>(storageService, permanent: true);

  runApp(const EjaryApp());
}

class EjaryApp extends StatelessWidget {
  const EjaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<EjaryStorageService>();

    return Obx(
      () => GetMaterialApp(
        title: 'app_title'.tr,
        debugShowCheckedModeBanner: false,
        initialBinding: InitialBinding(),
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: storage.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        translations: AppTranslations(),
        locale: Locale(storage.langCode.value),
        fallbackLocale: const Locale('ar'),
        initialRoute: AppRoutes.splash,
        getPages: AppPages.pages,
      ),
    );
  }
}