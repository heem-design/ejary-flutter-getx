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
