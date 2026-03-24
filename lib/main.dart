import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/screens/login_screen.dart';
import 'package:car_booking_app/screens/customer/customer_home_screen.dart';
import 'package:car_booking_app/screens/driver/driver_home_screen.dart';
import 'package:car_booking_app/screens/admin/admin_dashboard_screen.dart';
import 'package:car_booking_app/screens/customer/booking_history_screen.dart';
import 'package:car_booking_app/services/booking_manager.dart';
import 'package:car_booking_app/services/app_localization.dart';
import 'package:car_booking_app/services/car_service.dart';
import 'package:car_booking_app/services/booking_service.dart';
import 'package:car_booking_app/services/user_service.dart';
import 'package:car_booking_app/providers/auth_provider.dart';

void main() {
  runApp(const CarBookingApp());
}

class CarBookingApp extends StatelessWidget {
  const CarBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppLocalization()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        Provider(create: (_) => CarService()),
        Provider(create: (_) => BookingService()),
        Provider(create: (_) => UserService()),
        ChangeNotifierProxyProvider<CarService, BookingManager>(
          create: (context) => BookingManager(context.read<CarService>()),
          update: (context, carService, previous) => previous!,
        ),
      ],
      child: Consumer<AppLocalization>(
        builder: (context, localization, _) {
          return MaterialApp(
            title: 'Car Booking App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
              fontFamily: 'Roboto',
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => const LoginScreen(),
              '/customer': (context) => const CustomerHomeScreen(),
              '/driver': (context) => const DriverHomeScreen(),
              '/admin': (context) => const AdminDashboardScreen(),
              '/history': (context) => const BookingHistoryScreen(),
            },
          );
        },
      ),
    );
  }
}
