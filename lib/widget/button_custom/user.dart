// user.dart

import 'dart:convert';

class User {
  final String name;
  final String email;
  final String password;
  final String username;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.username,
  });

  String toJson() {
    return jsonEncode({
      'name': name,
      'email': email,
      'password': password,
      'username': username,
    });
  }
}
