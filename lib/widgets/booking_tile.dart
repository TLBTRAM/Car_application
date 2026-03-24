import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/models/booking.dart';
import 'package:car_booking_app/services/app_localization.dart';

class BookingTile extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onTap;

  const BookingTile({
    super.key,
    required this.booking,
    this.onTap,
  });

  String _formatDate(DateTime dt) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dt.toLocal());
  }

  Widget _paymentChip(BuildContext context, AppLocalization localization) {
    final status = booking.paymentStatus;
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case PaymentStatus.pending:
        color = Colors.orange;
        label = localization.translate('cash');
        icon = Icons.money;
        break;
      case PaymentStatus.paidCard:
        color = Colors.blue;
        label = 'Card';
        icon = Icons.credit_card;
        break;
      case PaymentStatus.paidMomo:
        color = Colors.pink;
        label = 'Momo';
        icon = Icons.account_balance_wallet;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = context.watch<AppLocalization>();
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.directions_car, color: Colors.blue.shade800),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localization.translate(booking.car.id),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  '${booking.pickup} → ${booking.destination}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(booking.createdAt),
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currencyFormat.format(booking.totalPrice),
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900),
              ),
              const SizedBox(height: 8),
              _paymentChip(context, localization),
            ],
          ),
        ],
      ),
    );
  }
}

