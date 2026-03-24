import 'package:flutter/material.dart';

import 'package:car_booking_app/models/car.dart';
import 'package:car_booking_app/widgets/primary_button.dart';

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:car_booking_app/services/app_localization.dart';

class CarCard extends StatelessWidget {
  final Car car;
  final bool isSelected;
  final VoidCallback onBook;

  const CarCard({
    super.key,
    required this.car,
    required this.isSelected,
    required this.onBook,
  });

  String _formatCurrency(int amount) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0).format(amount);
  }

  IconData _iconForCar(String iconName) {
    switch (iconName) {
      case 'sedan':
        return Icons.directions_car_filled;
      case 'family':
        return Icons.family_restroom;
      case 'eco':
        return Icons.eco;
      case 'sport':
        return Icons.speed;
      case 'car':
      default:
        return Icons.directions_car;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = context.watch<AppLocalization>();
    final borderColor = isSelected
        ? Colors.blue.shade800
        : Colors.blue.shade100.withOpacity(0.5);

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: borderColor,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.blue.shade50,
                  child: Icon(_iconForCar(car.iconName), color: Colors.blue.shade800),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localization.translate(car.id),
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.event_seat_rounded,
                            size: 16,
                            color: Colors.blue.shade800,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${car.seats} ${localization.translate('seats')}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _formatCurrency(car.basePrice),
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, color: Colors.blue.shade900),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            localization.translate('base_price'),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.blue.shade800,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${_formatCurrency(car.pricePerKm)} / km',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: isSelected ? localization.translate('selected') : localization.translate('select'),
              onPressed: isSelected ? null : onBook,
              icon: isSelected ? Icons.check_circle_rounded : Icons.event_available,
            ),
          ],
        ),
      ),
    );
  }
}

