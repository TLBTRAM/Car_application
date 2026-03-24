import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/services/app_localization.dart';

class AccountBottomSheet extends StatelessWidget {
  const AccountBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = context.watch<AppLocalization>();
    final theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 24),

          // Profile Header
          Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.blue.shade50,
                child: Text(
                  'JD',
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'john@example.com',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Stats Cards
          Row(
            children: [
              _buildStatCard(
                localization.translate('total_rides'),
                '47',
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                localization.translate('this_month'),
                '8',
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                localization.translate('spent'),
                '\$342',
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Menu List
          _buildMenuItem(
            icon: Icons.credit_card_outlined,
            title: localization.translate('payment_methods'),
            subtitle: localization.translate('manage_cards'),
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.shield_outlined,
            title: localization.translate('safety'),
            subtitle: localization.translate('emergency'),
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: localization.translate('help_support'),
            subtitle: localization.translate('faq'),
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.logout,
            title: localization.translate('sign_out'),
            subtitle: localization.translate('log_out'),
            isLast: true,
            titleColor: Colors.red,
            iconColor: Colors.red,
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLast = false,
    Color? titleColor,
    Color? iconColor,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: iconColor ?? Colors.black54),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: titleColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: onTap,
    );
  }
}
