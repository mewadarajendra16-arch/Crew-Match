import 'package:flutter/foundation.dart';
import 'api_service.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? phone;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'organiser',
      phone: json['phone'],
    );
  }
}

class AuthService {
  static final ValueNotifier<UserProfile?> currentUser = ValueNotifier<UserProfile?>(null);

  static Future<bool> login(String email, String password) async {
    final res = await ApiService.post('/auth/login', {
      'email': email,
      'password': password,
    });

    if (res != null && res['success'] == true) {
      ApiService.authToken = res['token'];
      currentUser.value = UserProfile.fromJson(res['user']);
      return true;
    }
    return false;
  }

  static Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? phone,
  }) async {
    final res = await ApiService.post('/auth/register', {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'phone': phone ?? '',
    });

    if (res != null && res['success'] == true) {
      ApiService.authToken = res['token'];
      currentUser.value = UserProfile.fromJson(res['user']);
      return true;
    }
    return false;
  }

  static void logout() {
    ApiService.authToken = null;
    currentUser.value = null;
  }
}
