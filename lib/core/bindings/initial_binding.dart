import 'package:get/get.dart';
import '../services/ejary_storage_service.dart';
import '../../features/home/data/datasources/unit_local_datasource.dart';
import '../../features/home/data/repositories/unit_repository_impl.dart';
import '../../features/home/domain/repositories/unit_repository.dart';
import '../../features/home/domain/usecases/get_units_usecase.dart';
import '../../features/home/domain/usecases/toggle_unit_rent_usecase.dart';

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
