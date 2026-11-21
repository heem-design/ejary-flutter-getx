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
