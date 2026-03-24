enum UserRole {
  customer,
  driver,
  admin,
}

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: _parseRole(json['role']),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.toString().split('.').last,
      'token': token,
    };
  }

  static UserRole _parseRole(String? role) {
    switch (role?.toLowerCase()) {
      case 'driver':
        return UserRole.driver;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.customer;
    }
  }
}
