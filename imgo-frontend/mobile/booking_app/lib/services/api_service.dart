import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/hotel.dart';
import '../models/booking.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8092';
  static const String hotelUrl = 'http://localhost:8094';
  static const String authUrl = 'http://localhost:8093';

  static Future<Map<String, dynamic>> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return {'success': true, 'user': {'id': '1', 'name': email.split('@')[0], 'email': email}};
  }

  static Future<Map<String, dynamic>> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      return jsonDecode(userJson);
    }
    return {};
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<List<Hotel>> getHotels() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Hotel(
        id: '1',
        name: 'IMGO Hotel Jakarta',
        city: 'Jakarta',
        address: 'Jl. Sudirman No. 123, SCBD',
        lat: -6.2088,
        lng: 106.8456,
        price: 850000,
        rating: 4.8,
        images: ['🏨', '🏊', '💆', '🍽️'],
        facilities: ['WiFi', 'Swimming Pool', 'Spa', 'Restaurant', 'Gym', 'Parking'],
        description: 'Luxury hotel in the heart of Jakarta\'s business district',
        roomTypes: [
          RoomType(id: '1', name: 'Standard Room', description: 'Comfortable room', price: 850000, capacity: 2, available: 5, amenities: ['AC', 'TV', 'WiFi']),
          RoomType(id: '2', name: 'Deluxe Room', description: 'Spacious room', price: 1200000, capacity: 2, available: 3, amenities: ['AC', 'TV', 'WiFi', 'Mini Bar']),
          RoomType(id: '3', name: 'Executive Suite', description: 'Luxury suite', price: 2000000, capacity: 3, available: 2, amenities: ['AC', 'TV', 'WiFi', 'Mini Bar', 'Bathtub']),
        ],
        reviews: [
          Review(id: '1', userId: '1', userName: 'John Doe', rating: 5, comment: 'Great hotel!', createdAt: DateTime.now()),
        ],
        phone: '+62 21 555-1234',
        email: 'jakarta@imgo.com',
      ),
    ];
  }

  static Future<List<Booking>> getUserBookings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Booking(
        id: '1',
        hotelId: '1',
        hotelName: 'IMGO Hotel Jakarta',
        roomType: 'Deluxe Room',
        checkIn: DateTime.now().add(const Duration(days: 5)),
        checkOut: DateTime.now().add(const Duration(days: 7)),
        guests: 2,
        rooms: 1,
        totalPrice: 2550000,
        status: 'confirmed',
        addBreakfast: true,
        addExtraBed: false,
        createdAt: DateTime.now(),
      ),
    ];
  }

  static Future<List<Hotel>> getFavorites() async {
    return [];
  }
}
