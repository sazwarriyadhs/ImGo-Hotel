import 'package:flutter/material.dart';

class BookingProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _bookings = [];
  
  List<Map<String, dynamic>> get bookings => _bookings;
  
  void addBooking(Map<String, dynamic> booking) {
    _bookings.add(booking);
    notifyListeners();
  }
  
  void cancelBooking(String id) {
    _bookings.removeWhere((booking) => booking['id'] == id);
    notifyListeners();
  }
}
