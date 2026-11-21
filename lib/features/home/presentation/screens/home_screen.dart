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
