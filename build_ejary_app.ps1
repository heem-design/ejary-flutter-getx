Write-Host "Building Ejary Complete App..." -ForegroundColor Cyan

$extraDirs = @(
    "lib/core/services",
    "lib/core/middleware",
    "lib/core/error",
    "lib/features/home/presentation/widgets"
)

$extraDirs | ForEach-Object {
    New-Item -ItemType Directory -Path $_ -Force | Out-Null
}

# 1. Constants
@'
class AppConstants {
  AppConstants._();

  static const String appName = 'Ejary';
  static const String appVersion = '1.0.0';
  static const String storageName = 'ejary_storage';

  // Storage Keys
  static const String keyPinCode = 'ejary_pin_code';
  static const String keyIsAuthenticated = 'ejary_is_authenticated';
  static const String keyIsDarkMode = 'ejary_is_dark_mode';
  static const String keyLangCode = 'ejary_lang_code';
}
'@ | Set-Content "lib/core/constants/app_constants.dart" -Encoding utf8

# 2. Theme (Light & Dark)
@'
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFF1565C0);
  static const Color secondaryColor = Color(0xFF00897B);
  static const Color lightBg = Color(0xFFF8F9FA);
  static const Color darkBg = Color(0xFF121212);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      secondary: secondaryColor,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      secondary: secondaryColor,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
  );
}
'@ | Set-Content "lib/core/theme/app_theme.dart" -Encoding utf8

# 3. Translations (AR / EN)
@'
import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ar': {
          'app_title': 'إيجاري - Ejary',
          'welcome': 'مرحباً بك في منصة إيجاري لإدارة الإيجارات',
          'pin_setup_title': 'إعداد رمز PIN جديد',
          'pin_verify_title': 'أدخل رمز PIN للدخول',
          'pin_setup_desc': 'أنشئ رمزاً مكوّناً من 4 أرقام لحماية حسابك',
          'pin_verify_desc': 'أدخل رمز PIN المكوّن من 4 أرقام للمتابعة',
          'pin_hint': 'رمز PIN (4 أرقام)',
          'pin_confirm': 'تأكيد وحفظ الرمز',
          'pin_login': 'دخول',
          'pin_reset': 'إعادة ضبط الرمز',
          'pin_error_length': 'يجب أن يتكوّن الرمز من 4 أرقام',
          'pin_error_wrong': 'رمز PIN غير صحيح، حاول مرة أخرى',
          'home_title': 'الوحدات الإيجارية',
          'all_units': 'الكل',
          'available_only': 'المتاحة فقط',
          'rent_action': 'استئجار الآن',
          'cancel_rent': 'إلغاء الحجز',
          'status_available': 'متاحة',
          'status_rented': 'مؤجرة',
          'monthly_rent': 'شهرياً',
          'rooms': 'غرف',
          'empty_units': 'لا توجد وحدات مطابقة حالياً',
          'retry': 'إعادة المحاولة',
          'theme_toggle': 'تغيير المظهر',
          'lang_toggle': 'AR / EN',
          'logout_pin': 'قفل التطبيق',
          'rented_success': 'تم تأكيد استئجار الوحدة بنجاح',
          'cancelled_success': 'تم إلغاء حجز الوحدة',
        },
        'en': {
          'app_title': 'Ejary Platform',
          'welcome': 'Welcome to Ejary Rental Management Platform',
          'pin_setup_title': 'Set Up Your PIN',
          'pin_verify_title': 'Enter PIN to Unlock',
          'pin_setup_desc': 'Create a 4-digit PIN to protect your session',
          'pin_verify_desc': 'Enter your 4-digit PIN to continue',
          'pin_hint': '4-Digit PIN',
          'pin_confirm': 'Save PIN',
          'pin_login': 'Unlock',
          'pin_reset': 'Reset PIN',
          'pin_error_length': 'PIN must be exactly 4 digits',
          'pin_error_wrong': 'Incorrect PIN, please try again',
          'home_title': 'Rental Units',
          'all_units': 'All',
          'available_only': 'Available',
          'rent_action': 'Rent Unit',
          'cancel_rent': 'Cancel Lease',
          'status_available': 'Available',
          'status_rented': 'Rented',
          'monthly_rent': '/ month',
          'rooms': 'Rooms',
          'empty_units': 'No matching units found',
          'retry': 'Retry',
          'theme_toggle': 'Toggle Theme',
          'lang_toggle': 'AR / EN',
          'logout_pin': 'Lock App',
          'rented_success': 'Unit rented successfully',
          'cancelled_success': 'Unit lease cancelled',
        },
      };
}
'@ | Set-Content "lib/core/locale/app_translations.dart" -Encoding utf8

# 4. Persistent Storage & App Service (GetxService)
@'
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
'@ | Set-Content "lib/core/services/ejary_storage_service.dart" -Encoding utf8

# 5. Failure class
@'
class Failure {
  final String message;
  const Failure(this.message);
}
'@ | Set-Content "lib/core/error/failure.dart" -Encoding utf8

# 6. Routes & Middleware
@'
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String pin = '/pin';
  static const String home = '/home';
}
'@ | Set-Content "lib/routes/app_routes.dart" -Encoding utf8

@'
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/services/ejary_storage_service.dart';
import 'app_routes.dart';

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
'@ | Set-Content "lib/core/middleware/auth_pin_middleware.dart" -Encoding utf8

# 7. Initial Binding
@'
import 'package:get/get.dart';
import '../core/services/ejary_storage_service.dart';
import '../features/home/data/datasources/unit_local_datasource.dart';
import '../features/home/data/repositories/unit_repository_impl.dart';
import '../features/home/domain/repositories/unit_repository.dart';
import '../features/home/domain/usecases/get_units_usecase.dart';
import '../features/home/domain/usecases/toggle_unit_rent_usecase.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<EjaryStorageService>()) {
      Get.put<EjaryStorageService>(EjaryStorageService(), permanent: true);
    }

    Get.lazyPut<UnitLocalDataSource>(() => UnitLocalDataSourceImpl(), fenix: true);
    Get.lazyPut<UnitRepository>(
      () => UnitRepositoryImpl(Get.find<UnitLocalDataSource>()),
      fenix: true,
    );
    Get.lazyPut<GetUnitsUseCase>(
      () => GetUnitsUseCase(Get.find<UnitRepository>()),
      fenix: true,
    );
    Get.lazyPut<ToggleUnitRentUseCase>(
      () => ToggleUnitRentUseCase(Get.find<UnitRepository>()),
      fenix: true,
    );
  }
}
'@ | Set-Content "lib/core/bindings/initial_binding.dart" -Encoding utf8

# 8. Splash Feature
@'
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
'@ | Set-Content "lib/features/splash/presentation/controllers/splash_controller.dart" -Encoding utf8

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

@'
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_work_rounded,
              size: 92,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 18),
            Text(
              'app_title'.tr,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'welcome'.tr,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 28),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
'@ | Set-Content "lib/features/splash/presentation/screens/splash_screen.dart" -Encoding utf8

# 9. PIN Feature
@'
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
'@ | Set-Content "lib/features/pin/presentation/controllers/pin_controller.dart" -Encoding utf8

@'
import 'package:get/get.dart';
import '../controllers/pin_controller.dart';

class PinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PinController>(() => PinController());
  }
}
'@ | Set-Content "lib/features/pin/presentation/bindings/pin_binding.dart" -Encoding utf8

@'
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/ejary_storage_service.dart';
import '../controllers/pin_controller.dart';

class PinScreen extends GetView<PinController> {
  const PinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<EjaryStorageService>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.isSetupMode.value
                ? 'pin_setup_title'.tr
                : 'pin_verify_title'.tr,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'lang_toggle'.tr,
            onPressed: storage.toggleLanguage,
            icon: const Icon(Icons.language),
          ),
          Obx(
            () => IconButton(
              tooltip: 'theme_toggle'.tr,
              onPressed: storage.toggleTheme,
              icon: Icon(
                storage.isDarkMode.value ? Icons.light_mode : Icons.dark_mode,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 68,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Obx(
                  () => Text(
                    controller.isSetupMode.value
                        ? 'pin_setup_desc'.tr
                        : 'pin_verify_desc'.tr,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: controller.pinTextController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'pin_hint'.tr,
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => controller.submitPin(),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => controller.errorMessage.value.isEmpty
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            controller.errorMessage.value,
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: controller.submitPin,
                    child: Obx(
                      () => Text(
                        controller.isSetupMode.value
                            ? 'pin_confirm'.tr
                            : 'pin_login'.tr,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => controller.isSetupMode.value
                      ? const SizedBox.shrink()
                      : TextButton(
                          onPressed: controller.resetPin,
                          child: Text('pin_reset'.tr),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
'@ | Set-Content "lib/features/pin/presentation/screens/pin_screen.dart" -Encoding utf8

# 10. Home Feature (Domain, Data, Presentation)
@'
class RentalUnit {
  final String id;
  final String titleAr;
  final String titleEn;
  final String cityAr;
  final String cityEn;
  final int rooms;
  final double monthlyRent;
  final bool isRented;

  const RentalUnit({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.cityAr,
    required this.cityEn,
    required this.rooms,
    required this.monthlyRent,
    required this.isRented,
  });

  RentalUnit copyWith({
    String? id,
    String? titleAr,
    String? titleEn,
    String? cityAr,
    String? cityEn,
    int? rooms,
    double? monthlyRent,
    bool? isRented,
  }) {
    return RentalUnit(
      id: id ?? this.id,
      titleAr: titleAr ?? this.titleAr,
      titleEn: titleEn ?? this.titleEn,
      cityAr: cityAr ?? this.cityAr,
      cityEn: cityEn ?? this.cityEn,
      rooms: rooms ?? this.rooms,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      isRented: isRented ?? this.isRented,
    );
  }
}
'@ | Set-Content "lib/features/home/domain/entities/rental_unit.dart" -Encoding utf8

@'
import '../../../../core/error/failure.dart';
import '../entities/rental_unit.dart';

abstract class UnitRepository {
  Future<({List<RentalUnit>? data, Failure? failure})> getUnits();
  Future<({List<RentalUnit>? data, Failure? failure})> toggleUnitRent(
    String unitId,
  );
}
'@ | Set-Content "lib/features/home/domain/repositories/unit_repository.dart" -Encoding utf8

@'
import '../../../../core/error/failure.dart';
import '../entities/rental_unit.dart';
import '../repositories/unit_repository.dart';

class GetUnitsUseCase {
  final UnitRepository _repository;
  GetUnitsUseCase(this._repository);

  Future<({List<RentalUnit>? data, Failure? failure})> call() {
    return _repository.getUnits();
  }
}
'@ | Set-Content "lib/features/home/domain/usecases/get_units_usecase.dart" -Encoding utf8

@'
import '../../../../core/error/failure.dart';
import '../entities/rental_unit.dart';
import '../repositories/unit_repository.dart';

class ToggleUnitRentUseCase {
  final UnitRepository _repository;
  ToggleUnitRentUseCase(this._repository);

  Future<({List<RentalUnit>? data, Failure? failure})> call(String unitId) {
    return _repository.toggleUnitRent(unitId);
  }
}
'@ | Set-Content "lib/features/home/domain/usecases/toggle_unit_rent_usecase.dart" -Encoding utf8

@'
import '../../domain/entities/rental_unit.dart';

class RentalUnitModel extends RentalUnit {
  const RentalUnitModel({
    required super.id,
    required super.titleAr,
    required super.titleEn,
    required super.cityAr,
    required super.cityEn,
    required super.rooms,
    required super.monthlyRent,
    required super.isRented,
  });

  factory RentalUnitModel.fromEntity(RentalUnit entity) {
    return RentalUnitModel(
      id: entity.id,
      titleAr: entity.titleAr,
      titleEn: entity.titleEn,
      cityAr: entity.cityAr,
      cityEn: entity.cityEn,
      rooms: entity.rooms,
      monthlyRent: entity.monthlyRent,
      isRented: entity.isRented,
    );
  }
}
'@ | Set-Content "lib/features/home/data/models/rental_unit_model.dart" -Encoding utf8

@'
import '../models/rental_unit_model.dart';

abstract class UnitLocalDataSource {
  Future<List<RentalUnitModel>> fetchUnits();
  Future<List<RentalUnitModel>> toggleUnitRent(String unitId);
}

class UnitLocalDataSourceImpl implements UnitLocalDataSource {
  List<RentalUnitModel> _units = [
    const RentalUnitModel(
      id: 'U-101',
      titleAr: 'شقة عائلية حديثة',
      titleEn: 'Modern Family Apartment',
      cityAr: 'الرياض - حي النرجس',
      cityEn: 'Riyadh - Al Narjis',
      rooms: 3,
      monthlyRent: 3800,
      isRented: false,
    ),
    const RentalUnitModel(
      id: 'U-102',
      titleAr: 'استوديو بإطلالة مميزة',
      titleEn: 'Bright Studio Unit',
      cityAr: 'جدة - الشاطئ',
      cityEn: 'Jeddah - Al Shati',
      rooms: 1,
      monthlyRent: 2100,
      isRented: true,
    ),
    const RentalUnitModel(
      id: 'U-103',
      titleAr: 'دوبلكس بحديقة خاصة',
      titleEn: 'Duplex with Private Yard',
      cityAr: 'الخبر - العقربية',
      cityEn: 'Khobar - Al Aqrabiyah',
      rooms: 4,
      monthlyRent: 5400,
      isRented: false,
    ),
  ];

  @override
  Future<List<RentalUnitModel>> fetchUnits() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List<RentalUnitModel>.from(_units);
  }

  @override
  Future<List<RentalUnitModel>> toggleUnitRent(String unitId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    _units = _units.map((u) {
      if (u.id == unitId) {
        return RentalUnitModel.fromEntity(u.copyWith(isRented: !u.isRented));
      }
      return u;
    }).toList();
    return List<RentalUnitModel>.from(_units);
  }
}
'@ | Set-Content "lib/features/home/data/datasources/unit_local_datasource.dart" -Encoding utf8

@'
import '../../../../core/error/failure.dart';
import '../../domain/entities/rental_unit.dart';
import '../../domain/repositories/unit_repository.dart';
import '../datasources/unit_local_datasource.dart';

class UnitRepositoryImpl implements UnitRepository {
  final UnitLocalDataSource _localDataSource;
  UnitRepositoryImpl(this._localDataSource);

  @override
  Future<({List<RentalUnit>? data, Failure? failure})> getUnits() async {
    try {
      final list = await _localDataSource.fetchUnits();
      return (data: list, failure: null);
    } catch (_) {
      return (data: null, failure: const Failure('Failed to load units'));
    }
  }

  @override
  Future<({List<RentalUnit>? data, Failure? failure})> toggleUnitRent(
    String unitId,
  ) async {
    try {
      final list = await _localDataSource.toggleUnitRent(unitId);
      return (data: list, failure: null);
    } catch (_) {
      return (data: null, failure: const Failure('Failed to update unit'));
    }
  }
}
'@ | Set-Content "lib/features/home/data/repositories/unit_repository_impl.dart" -Encoding utf8

@'
import 'package:get/get.dart';
import '../../../../core/services/ejary_storage_service.dart';
import '../../../../routes/app_routes.dart';
import '../../domain/entities/rental_unit.dart';
import '../../domain/usecases/get_units_usecase.dart';
import '../../domain/usecases/toggle_unit_rent_usecase.dart';

class HomeController extends GetxController with StateMixin<List<RentalUnit>> {
  final GetUnitsUseCase _getUnitsUseCase = Get.find<GetUnitsUseCase>();
  final ToggleUnitRentUseCase _toggleUnitRentUseCase =
      Get.find<ToggleUnitRentUseCase>();
  final EjaryStorageService _storageService = Get.find<EjaryStorageService>();

  final RxBool onlyAvailable = false.obs;
  List<RentalUnit> _allUnits = [];

  @override
  void onInit() {
    super.onInit();
    loadUnits();
  }

  Future<void> loadUnits() async {
    change(null, status: RxStatus.loading());
    final result = await _getUnitsUseCase();
    if (result.failure != null) {
      change(null, status: RxStatus.error(result.failure!.message));
      return;
    }
    _allUnits = result.data ?? [];
    _applyFilter();
  }

  void setFilter(bool availableOnly) {
    onlyAvailable.value = availableOnly;
    _applyFilter();
    update(['filter_bar']);
  }

  void _applyFilter() {
    final filtered = onlyAvailable.value
        ? _allUnits.where((u) => !u.isRented).toList()
        : _allUnits;
    if (filtered.isEmpty) {
      change([], status: RxStatus.empty());
    } else {
      change(filtered, status: RxStatus.success());
    }
  }

  Future<void> toggleRent(RentalUnit unit) async {
    final result = await _toggleUnitRentUseCase(unit.id);
    if (result.data != null) {
      _allUnits = result.data!;
      _applyFilter();
      Get.snackbar(
        'app_title'.tr,
        (!unit.isRented ? 'rented_success' : 'cancelled_success').tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> lockApp() async {
    await _storageService.setAuthenticated(false);
    Get.offAllNamed(AppRoutes.pin);
  }
}
'@ | Set-Content "lib/features/home/presentation/controllers/home_controller.dart" -Encoding utf8

@'
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
'@ | Set-Content "lib/features/home/presentation/bindings/home_binding.dart" -Encoding utf8

@'
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/rental_unit.dart';

class RentalUnitCard extends StatelessWidget {
  final RentalUnit unit;
  final VoidCallback onToggleRent;

  const RentalUnitCard({
    super.key,
    required this.unit,
    required this.onToggleRent,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    isAr ? unit.titleAr : unit.titleEn,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    unit.isRented ? 'status_rented'.tr : 'status_available'.tr,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              isAr ? unit.cityAr : unit.cityEn,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${unit.rooms} ${'rooms'.tr}'),
                Text(
                  '${unit.monthlyRent.toStringAsFixed(0)} ${'monthly_rent'.tr}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: unit.isRented
                  ? OutlinedButton(
                      onPressed: onToggleRent,
                      child: Text('cancel_rent'.tr),
                    )
                  : FilledButton(
                      onPressed: onToggleRent,
                      child: Text('rent_action'.tr),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
'@ | Set-Content "lib/features/home/presentation/widgets/rental_unit_card.dart" -Encoding utf8

@'
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/ejary_storage_service.dart';
import '../controllers/home_controller.dart';
import '../widgets/rental_unit_card.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<EjaryStorageService>();

    return Scaffold(
      appBar: AppBar(
        title: Text('home_title'.tr),
        actions: [
          IconButton(
            tooltip: 'lang_toggle'.tr,
            onPressed: storage.toggleLanguage,
            icon: const Icon(Icons.translate),
          ),
          Obx(
            () => IconButton(
              tooltip: 'theme_toggle'.tr,
              onPressed: storage.toggleTheme,
              icon: Icon(
                storage.isDarkMode.value ? Icons.light_mode : Icons.dark_mode,
              ),
            ),
          ),
          IconButton(
            tooltip: 'logout_pin'.tr,
            onPressed: controller.lockApp,
            icon: const Icon(Icons.lock_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          GetBuilder<HomeController>(
            id: 'filter_bar',
            builder: (_) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  ChoiceChip(
                    label: Text('all_units'.tr),
                    selected: !controller.onlyAvailable.value,
                    onSelected: (_) => controller.setFilter(false),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: Text('available_only'.tr),
                    selected: controller.onlyAvailable.value,
                    onSelected: (_) => controller.setFilter(true),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: controller.obx(
              (units) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: units?.length ?? 0,
                itemBuilder: (context, index) {
                  final unit = units![index];
                  return RentalUnitCard(
                    unit: unit,
                    onToggleRent: () => controller.toggleRent(unit),
                  );
                },
              ),
              onLoading: const Center(child: CircularProgressIndicator()),
              onEmpty: Center(child: Text('empty_units'.tr)),
              onError: (err) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(err ?? 'Error'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: controller.loadUnits,
                      child: Text('retry'.tr),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
'@ | Set-Content "lib/features/home/presentation/screens/home_screen.dart" -Encoding utf8

# 11. AppPages & Main
@'
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
'@ | Set-Content "lib/routes/app_pages.dart" -Encoding utf8

@'
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/bindings/initial_binding.dart';
import 'core/locale/app_translations.dart';
import 'core/services/ejary_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = await EjaryStorageService().init();
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
'@ | Set-Content "lib/main.dart" -Encoding utf8

flutter pub get
flutter analyze
Write-Host "Ejary setup completed!" -ForegroundColor Green