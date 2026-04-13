import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    _isLoading = true;
    notifyListeners();

    final userData = await ApiService.getCurrentUser();
    if (userData['id'] != null) {
      _currentUser = User(
        id: userData['id'],
        name: userData['name'] ?? '',
        email: userData['email'] ?? '',
        phone: userData['phone'] ?? '',
        photo: userData['photo'],
        points: userData['points'] ?? 0,
        favorites: userData['favorites'] != null ? List<String>.from(userData['favorites']) : [],
      );
      _isAuthenticated = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await ApiService.login(email, password);
      if (data.containsKey('user')) {
        final userData = data['user'];
        _currentUser = User(
          id: userData['id']?.toString() ?? '1',
          name: userData['name'] ?? email.split('@')[0],
          email: email,
          phone: userData['phone'] ?? '',
          photo: userData['photo'],
          points: userData['points'] ?? 0,
          favorites: userData['favorites'] != null ? List<String>.from(userData['favorites']) : [],
        );
        _isAuthenticated = true;
        return true;
      }
      return false;
    } catch (e) {
      // Demo mode
      _currentUser = User(
        id: '1',
        name: email.split('@')[0],
        email: email,
        phone: '08123456789',
        points: 1000,
        favorites: [],
      );
      _isAuthenticated = true;
      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    
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

  void addToFavorites(String hotelId) {
    if (_currentUser != null && !_currentUser!.favorites.contains(hotelId)) {
      _currentUser!.favorites.add(hotelId);
      notifyListeners();
    }
  }

  void removeFromFavorites(String hotelId) {
    if (_currentUser != null) {
      _currentUser!.favorites.remove(hotelId);
      notifyListeners();
    }
  }

  bool isFavorite(String hotelId) {
    return _currentUser?.favorites.contains(hotelId) ?? false;
  }
}
