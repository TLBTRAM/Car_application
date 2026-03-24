import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/models/user.dart';
import 'package:car_booking_app/services/user_service.dart';
import 'package:car_booking_app/providers/auth_provider.dart';
import 'package:animate_do/animate_do.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _refreshUsers();
  }

  void _refreshUsers() {
    final userService = context.read<UserService>();
    setState(() {
      _usersFuture = userService.getAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          // Header with Gradient
          _buildHeader(context),
          
          // Statistics Row
          _buildStatsRow(),

          // User List Section
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
                        "Quản lý người dùng",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: _refreshUsers,
                        icon: const Icon(Icons.refresh, color: Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: FutureBuilder<List<User>>(
                      future: _usersFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Lỗi: ${snapshot.error}'));
                        }
                        final users = snapshot.data ?? [];
                        return ListView.separated(
                          padding: const EdgeInsets.only(bottom: 100),
                          itemCount: users.length,
                          separatorBuilder: (context, _) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return FadeInLeft(
                              delay: Duration(milliseconds: index * 100),
                              child: _buildUserCard(user),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUserDialog(null),
        backgroundColor: Colors.blue.shade800,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Thêm User", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 500),
                    child: const Text(
                      "ADMIN DASHBOARD",
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
                      "Chào, ${auth.user?.name ?? 'Admin'}",
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
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            _buildStatCard("Người dùng", "1,240", Icons.people, Colors.orange),
            const SizedBox(width: 15),
            _buildStatCard("Chuyến đi", "856", Icons.directions_car, Colors.green),
            const SizedBox(width: 15),
            _buildStatCard("Doanh thu", "₫45M", Icons.monetization_on, Colors.blue),
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
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(User user) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: _getRoleColor(user.role).withOpacity(0.1),
            child: Icon(Icons.person, color: _getRoleColor(user.role)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(user.email, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _getRoleColor(user.role).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              user.role.toString().split('.').last.toUpperCase(),
              style: TextStyle(color: _getRoleColor(user.role), fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          _buildActionMenu(user),
        ],
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin: return Colors.purple;
      case UserRole.driver: return Colors.blue;
      default: return Colors.orange;
    }
  }

  Widget _buildActionMenu(User user) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert, color: Colors.grey),
      onSelected: (value) {
        if (value == 'edit') _showUserDialog(user);
        if (value == 'delete') _deleteUser(user.id);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'edit', child: Text("Sửa")),
        const PopupMenuItem(value: 'delete', child: Text("Xóa", style: TextStyle(color: Colors.red))),
      ],
    );
  }

  void _showUserDialog(User? user) {
    final nameController = TextEditingController(text: user?.name);
    final emailController = TextEditingController(text: user?.email);
    final passwordController = TextEditingController();
    UserRole selectedRole = user?.role ?? UserRole.customer;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: Text(user == null ? 'Thêm Người dùng' : 'Sửa Người dùng'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController, 
                  decoration: InputDecoration(
                    labelText: 'Họ tên',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: emailController, 
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                if (user == null) ...[
                  const SizedBox(height: 15),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ],
                const SizedBox(height: 15),
                DropdownButtonFormField<UserRole>(
                  value: selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Vai trò',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  items: UserRole.values.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role.toString().split('.').last.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setDialogState(() => selectedRole = val);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
            ElevatedButton(
              onPressed: () async {
                final userService = context.read<UserService>();
                final data = {
                  'name': nameController.text,
                  'email': emailController.text,
                  'role': selectedRole.toString().split('.').last,
                };
                if (user == null) {
                  data['password'] = passwordController.text.isNotEmpty ? passwordController.text : '123';
                }
                
                bool success;
                if (user == null) {
                  success = await userService.addUser(data);
                } else {
                  success = await userService.updateUser(user.id, data);
                }
                if (success) {
                  Navigator.pop(context);
                  _refreshUsers();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade800),
              child: const Text('Lưu', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteUser(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa người dùng này?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true), 
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final userService = context.read<UserService>();
      final success = await userService.deleteUser(id);
      if (success) _refreshUsers();
    }
  }
}
