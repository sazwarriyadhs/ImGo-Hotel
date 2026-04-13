import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  // Cek dan minta permission
  static Future<bool> checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    
    return true;
  }
  
  // Dapatkan lokasi saat ini
  static Future<Position?> getCurrentLocation() async {
    bool hasPermission = await checkAndRequestPermission();
    if (!hasPermission) return null;
    
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }
  
  // Hitung jarak antara dua titik (dalam km)
  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Radius bumi dalam km
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = 
        _sin(dLat / 2) * _sin(dLat / 2) +
        _cos(_toRadians(lat1)) * _cos(_toRadians(lat2)) * 
        _sin(dLon / 2) * _sin(dLon / 2);
    double c = 2 * _atan2(_sqrt(a), _sqrt(1 - a));
    return R * c;
  }
  
  static double _toRadians(double degree) {
    return degree * 3.141592653589793 / 180;
  }
  
  static double _sin(double x) {
    return x - x * x * x / 6 + x * x * x * x * x / 120;
  }
  
  static double _cos(double x) {
    return 1 - x * x / 2 + x * x * x * x / 24;
  }
  
  static double _sqrt(double x) {
    return x > 0 ? x.sqrt() : 0;
  }
  
  static double _atan2(double y, double x) {
    return y.atan2(x);
  }
  
  // Konversi koordinat ke alamat
  static Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return '${place.street}, ${place.locality}, ${place.administrativeArea}';
      }
    } catch (e) {
      print('Error getting address: $e');
    }
    return 'Unknown location';
  }
}
