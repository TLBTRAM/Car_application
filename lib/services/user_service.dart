import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:car_booking_app/models/user.dart';

class UserService {
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

  Future<List<User>> getAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admin/users'),
        headers: await _getHeaders(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> addUser(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/admin/users'),
        headers: await _getHeaders(),
        body: jsonEncode(userData),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/admin/users/$userId'),
        headers: await _getHeaders(),
        body: jsonEncode(userData),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/admin/users/$userId'),
        headers: await _getHeaders(),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
