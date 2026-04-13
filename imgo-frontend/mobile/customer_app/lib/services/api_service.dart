import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/booking.dart';

class ApiService {
  static const String _host = '10.0.2.2';
  static const String apiGateway = 'http://$_host:8092';
  static const String hotelService = 'http://$_host:8094';
  static const String authService = 'http://$_host:8093';

  // Data real dari database untuk semua customer
  static final Map<String, Map<String, dynamic>> _users = {
    'sarah.wilson@example.com': {
      'id': 'a897eb3e-b265-45f5-9a1e-775be4f0288b',
      'name': 'Sarah Wilson',
      'email': 'sarah.wilson@example.com',
      'phone': '081234567804',
      'points': 2850,
      'total_earned': 3250,
      'total_redeemed': 400,
      'points_to_next': 150,
      'tier': 'Platinum Gold',
      'photo': null,
      'bookings': [
        {'hotel': 'IMGO Hotel Denpasar, Bali', 'room': 'Deluxe Room', 'dates': '27 Apr - 1 May 2026', 'status': 'confirmed'},
        {'hotel': 'IMGO Hotel Bandung', 'room': 'Standard Room', 'dates': '27 Feb - 2 Mar 2026', 'status': 'completed'},
        {'hotel': 'IMGO Hotel Jakarta', 'room': 'Executive Suite', 'dates': '12-15 Feb 2026', 'status': 'completed'},
      ],
    },
    'john.doe@example.com': {
      'id': '7df89144-bf86-4d23-b28d-2f9924d5ea01',
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'phone': '081234567801',
      'points': 1250,
      'total_earned': 1500,
      'total_redeemed': 250,
      'points_to_next': 250,
      'tier': 'Gold',
      'photo': null,
      'bookings': [
        {'hotel': 'IMGO Hotel Jakarta', 'room': 'Deluxe Room', 'dates': '20-25 Jan 2025', 'status': 'confirmed'},
      ],
    },
    'jane.smith@example.com': {
      'id': 'cd390f56-8e33-4553-a0ed-ff7a1d534da4',
      'name': 'Jane Smith',
      'email': 'jane.smith@example.com',
      'phone': '081234567802',
      'points': 2100,
      'total_earned': 2500,
      'total_redeemed': 400,
      'points_to_next': 400,
      'tier': 'Platinum',
      'photo': null,
      'bookings': [
        {'hotel': 'IMGO Hotel Surabaya', 'room': 'Standard Room', 'dates': '10-15 Mar 2025', 'status': 'confirmed'},
      ],
    },
  };

  static Future<Map<String, dynamic>> login(String email, String password) async {
    // Hanya login untuk user yang terdaftar
    if (_users.containsKey(email) && password == 'customer123') {
      final userData = _users[email]!;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(userData));
      return {'success': true, 'user': {'name': userData['name']}};
    }
    return {'success': false};
  }

  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null && userJson.isNotEmpty) {
      try {
        return User.fromJson(jsonDecode(userJson));
      } catch (e) {
        print('Error parsing user: $e');
        return null;
      }
    }
    return null;
  }

  static Future<List<Booking>> getUserBookings() async {
    final user = await getCurrentUser();
    if (user == null) return [];
    
    final userData = _users[user.email];
    if (userData == null) return [];
    
    final bookings = userData['bookings'] as List? ?? [];
    return bookings.map((b) => Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      hotelName: b['hotel'],
      roomType: b['room'],
      dates: b['dates'],
      status: b['status'],
    )).toList();
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }
}
