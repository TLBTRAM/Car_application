import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/models/booking.dart';
import 'package:car_booking_app/services/booking_service.dart';
import 'package:car_booking_app/providers/auth_provider.dart';
import 'package:animate_do/animate_do.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  late Future<List<Booking>> _ridesFuture;

  @override
  void initState() {
    super.initState();
    _refreshRides();
  }

  void _refreshRides() {
    final bookingService = context.read<BookingService>();
    setState(() {
      _ridesFuture = bookingService.getDriverRides();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          _buildHeader(context),
          _buildStatsRow(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Chuyến xe của bạn",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: _refreshRides,
                        icon: const Icon(Icons.refresh, color: Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: FutureBuilder<List<Booking>>(
                      future: _ridesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Lỗi: ${snapshot.error}'));
                        }
                        final rides = snapshot.data ?? [];
                        if (rides.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.directions_car_outlined, size: 80, color: Colors.grey.shade300),
                                const SizedBox(height: 10),
                                Text("Chưa có chuyến xe nào", style: TextStyle(color: Colors.grey.shade500)),
                              ],
                            ),
                          );
                        }
                        return ListView.separated(
                          padding: const EdgeInsets.only(bottom: 30),
                          itemCount: rides.length,
                          separatorBuilder: (context, _) => const SizedBox(height: 15),
                          itemBuilder: (context, index) {
                            final ride = rides[index];
                            return FadeInUp(
                              delay: Duration(milliseconds: index * 100),
                              child: _buildRideCard(ride),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final auth = context.read<AuthProvider>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
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
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 500),
                child: const Text(
                  "DRIVER PANEL",
                  style: TextStyle(
                    color: Colors.white70, 
                    fontSize: 12, 
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              FadeInLeft(
                duration: const Duration(milliseconds: 800),
                child: Text(
                  "Chào, ${auth.user?.name ?? 'Tài xế'}",
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 28, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          FadeInRight(
            duration: const Duration(milliseconds: 800),
            child: GestureDetector(
              onTap: () {
                context.read<AuthProvider>().logout();
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: const Icon(Icons.logout_rounded, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Transform.translate(
      offset: const Offset(0, -25),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            _buildStatCard("Chuyến xe", "12", Icons.history, Colors.orange),
            const SizedBox(width: 15),
            _buildStatCard("Thu nhập", "₫2.4M", Icons.account_balance_wallet, Colors.green),
            const SizedBox(width: 15),
            _buildStatCard("Đánh giá", "4.9", Icons.star, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), 
              blurRadius: 10, 
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildRideCard(Booking ride) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03), 
            blurRadius: 10, 
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.location_on, color: Colors.blue.shade800),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ride.pickup,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Icon(Icons.arrow_downward, size: 16, color: Colors.grey),
                    Text(
                      ride.destination,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₫${ride.totalPrice}",
                    style: TextStyle(
                      color: Colors.blue.shade900, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 18,
                    ),
                  ),
                  _buildStatusBadge(ride.status),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 5),
                  Text("Ngay bây giờ", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                ],
              ),
              _buildActionButton(ride),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BookingStatus status) {
    Color color;
    String text;
    switch (status) {
      case BookingStatus.pending:
        color = Colors.orange;
        text = "ĐANG CHỜ";
        break;
      case BookingStatus.accepted:
        color = Colors.blue;
        text = "ĐÃ NHẬN";
        break;
      case BookingStatus.completed:
        color = Colors.green;
        text = "HOÀN THÀNH";
        break;
      case BookingStatus.cancelled:
        color = Colors.red;
        text = "ĐÃ HỦY";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildActionButton(Booking ride) {
    if (ride.status == BookingStatus.pending) {
      return ElevatedButton(
        onPressed: () => _updateStatus(ride.id, 'accepted'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        child: const Text("Nhận chuyến", style: TextStyle(fontWeight: FontWeight.bold)),
      );
    } else if (ride.status == BookingStatus.accepted) {
      return ElevatedButton(
        onPressed: () => _updateStatus(ride.id, 'completed'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        child: const Text("Hoàn thành", style: TextStyle(fontWeight: FontWeight.bold)),
      );
    }
    return const SizedBox.shrink();
  }

  void _updateStatus(String id, String status) async {
    final bookingService = context.read<BookingService>();
    final success = await bookingService.updateRideStatus(id, status);
    if (success) _refreshRides();
  }
}
