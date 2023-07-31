class User {
  final int? id; // Make it nullable
  final String name;
  final String username;
  final String email;
  final String phone;
  final String password;
  final String role;

  User({
    this.id, // Tidak diperlukan kini
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    String? role,
  }) : role = role?.isNotEmpty == true ? role! : 'user';

  Map<String, dynamic> toMap() {
    return {
      'id': id, // It will be null for new users
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'], // It will not be null for existing users
      name: map['name'],
      username: map['username'],
      email: map['email'],
      phone: map['phone'],
      password: map['password'],
      role: map['role'],
    );
  }
}
