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
