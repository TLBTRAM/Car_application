import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:car_booking_app/models/booking.dart';

class BookingService {
  static String get baseUrl {
    return Platform.isAndroid ? 'http://10.0.2.2:3000/api' : 'http://localhost:3000/api';
  }

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<Booking>> getBookings(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bookings/user/$userId'),
        headers: await _getHeaders(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Booking.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<Booking>> getDriverRides() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/driver/rides'),
        headers: await _getHeaders(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Booking.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> updateRideStatus(String bookingId, String status) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/bookings/$bookingId/status'),
        headers: await _getHeaders(),
        body: jsonEncode({'status': status}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bookings'),
        headers: await _getHeaders(),
        body: jsonEncode(bookingData),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
