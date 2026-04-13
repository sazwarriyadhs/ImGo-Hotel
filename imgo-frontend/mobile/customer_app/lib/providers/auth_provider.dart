import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  bool _isAuthenticated = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();
    _currentUser = await ApiService.getCurrentUser();
    _isAuthenticated = _currentUser != null;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    final result = await ApiService.login(email, password);
    if (result['success'] == true) {
      _currentUser = await ApiService.getCurrentUser();
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    }
    
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();
    
    // Simulasi registrasi
    await Future.delayed(const Duration(seconds: 1));
    
    // Cek apakah email sudah terdaftar
    final existingEmails = ['sarah.wilson@example.com', 'john.doe@example.com', 'jane.smith@example.com'];
    if (existingEmails.contains(email.toLowerCase())) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
    
    // Registrasi berhasil
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'email': email,
      'phone': phone,
      'points': 0,
      'total_earned': 0,
      'total_redeemed': 0,
      'points_to_next': 1000,
      'tier': 'Silver',
      'photo': null,
      'membership_type': 'Silver',
      'membership_status': 'active',
    }));
    
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    await ApiService.logout();
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
