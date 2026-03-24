import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:car_booking_app/models/booking.dart';
import 'package:car_booking_app/services/booking_service.dart';
import 'package:car_booking_app/providers/auth_provider.dart';
import 'package:car_booking_app/services/app_localization.dart';
import 'package:car_booking_app/widgets/booking_tile.dart';
import 'package:animate_do/animate_do.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  late Future<List<Booking>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _refreshHistory();
  }

  void _refreshHistory() {
    final authProvider = context.read<AuthProvider>();
    final bookingService = context.read<BookingService>();
    final userId = authProvider.user?.id ?? '';
    setState(() {
      _historyFuture = bookingService.getBookings(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = context.watch<AppLocalization>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          _buildHeader(context, localization),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _refreshHistory(),
              child: FutureBuilder<List<Booking>>(
                future: _historyFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  }

                  final history = snapshot.data ?? [];

                  if (history.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history_rounded, size: 80, color: Colors.grey.shade300),
                          const SizedBox(height: 20),
                          Text(
                            localization.translate('no_bookings'),
                            style: const TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: history.length,
                    separatorBuilder: (context, _) => const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      return FadeInUp(
                        delay: Duration(milliseconds: index * 100),
                        child: BookingTile(booking: history[index]),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalization localization) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade900,
            Colors.blue.shade800,
            Colors.blue.shade400,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 20),
          Text(
            localization.translate('booking_history'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

