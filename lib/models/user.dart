import 'package:flutter/material.dart';

class User {
  final int id;
  final String name;
  final String username;
  final String email;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
    };
  }
}

class Contact {
  final int id;
  final String name;
  final String username;
  final String initials;
  final Color color;

  const Contact({
    required this.id,
    required this.name,
    required this.username,
    required this.initials,
    required this.color,
  });
}