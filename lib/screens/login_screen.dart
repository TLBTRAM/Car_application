import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/services/app_localization.dart';
import 'package:car_booking_app/providers/auth_provider.dart';
import 'package:car_booking_app/models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoginMode = true;
  UserRole _selectedRole = UserRole.customer;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final authProvider = context.read<AuthProvider>();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty || (!_isLoginMode && name.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields"), backgroundColor: Colors.redAccent),
      );
      return;
    }

    bool success;
    if (_isLoginMode) {
      success = await authProvider.login(email, password);
    } else {
      success = await authProvider.register(
        name, 
        email, 
        password, 
        _selectedRole.toString().split('.').last
      );
    }

    if (success) {
      if (mounted) {
        if (_isLoginMode) {
          _navigateBasedOnRole(authProvider.user?.role);
        } else {
          setState(() => _isLoginMode = true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration successful! Please login."), backgroundColor: Colors.green),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Action failed. Please check your credentials."), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  void _navigateBasedOnRole(UserRole? role) {
    if (role == UserRole.admin) {
      Navigator.pushReplacementNamed(context, '/admin');
    } else if (role == UserRole.driver) {
      Navigator.pushReplacementNamed(context, '/driver');
    } else {
      Navigator.pushReplacementNamed(context, '/customer');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = context.watch<AppLocalization>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade800,
              Colors.blue.shade400,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    child: Text(
                      _isLoginMode 
                        ? localization.translate('login') 
                        : localization.translate('register'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1300),
                    child: Text(
                      localization.translate('welcome'),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 40),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1400),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade100.withOpacity(0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              if (!_isLoginMode)
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      hintText: localization.translate('full_name'),
                                      hintStyle: const TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      prefixIcon: const Icon(Icons.person_outline, size: 20),
                                    ),
                                  ),
                                ),
                              if (!_isLoginMode)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.badge_outlined, size: 20, color: Colors.grey),
                                      const SizedBox(width: 10),
                                      const Text("Role:", style: TextStyle(color: Colors.grey)),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: DropdownButton<UserRole>(
                                          value: _selectedRole,
                                          isExpanded: true,
                                          underline: const SizedBox(),
                                          items: UserRole.values.map((role) {
                                            return DropdownMenuItem(
                                              value: role,
                                              child: Text(role.toString().split('.').last.toUpperCase()),
                                            );
                                          }).toList(),
                                          onChanged: (val) {
                                            if (val != null) setState(() => _selectedRole = val);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),
                                child: TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    hintText: localization.translate('email_hint'),
                                    hintStyle: const TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    prefixIcon: const Icon(Icons.email_outlined, size: 20),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: localization.translate('password_hint'),
                                    hintStyle: const TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    prefixIcon: const Icon(Icons.lock_outline, size: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      if (_isLoginMode)
                        FadeInUp(
                          duration: const Duration(milliseconds: 1500),
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              localization.translate('forgot_password'),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1600),
                        child: MaterialButton(
                          onPressed: _handleSubmit,
                          height: 55,
                          minWidth: double.infinity,
                          color: Colors.blue.shade800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              _isLoginMode 
                                ? localization.translate('login') 
                                : localization.translate('register'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1650),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _isLoginMode = !_isLoginMode;
                            });
                          },
                          child: Text(
                            _isLoginMode 
                              ? localization.translate('No account?') 
                              : localization.translate('Already have an account'),
                            style: TextStyle(color: Colors.blue.shade800),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1700),
                        child: Text(
                          localization.translate('social_continue'),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: FadeInUp(
                              duration: const Duration(milliseconds: 1800),
                              child: MaterialButton(
                                onPressed: () {},
                                height: 50,
                                color: Colors.blue.shade600,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Facebook",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: FadeInUp(
                              duration: const Duration(milliseconds: 1900),
                              child: MaterialButton(
                                onPressed: () {},
                                height: 50,
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Github",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
