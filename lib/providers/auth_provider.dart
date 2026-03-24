import 'package:flutter/material.dart';
import 'package:car_booking_app/models/user.dart';
import 'package:car_booking_app/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    _isLoading = true;
    notifyListeners();
    _user = await _authService.getUser();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    final user = await _authService.login(email, password);
    if (user != null) {
      _user = user;
      _isLoading = false;
      notifyListeners();
      return true;
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String name, String email, String password, String role) async {
    _isLoading = true;
    notifyListeners();
    final success = await _authService.register(name, email, password, role);
    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
}
