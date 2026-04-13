import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/location_service.dart';
import '../../services/api_service.dart';
import '../../models/hotel.dart';

class NearbyHotelsMapScreen extends StatefulWidget {
  const NearbyHotelsMapScreen({super.key});

  @override
  State<NearbyHotelsMapScreen> createState() => _NearbyHotelsMapScreenState();
}

class _NearbyHotelsMapScreenState extends State<NearbyHotelsMapScreen> {
  List<Hotel> _hotels = [];
  bool _isLoading = true;
  Position? _currentPosition;
  LatLng? _currentLatLng;
  String _currentAddress = 'Getting location...';
  double _radius = 10;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _getCurrentLocation();
    await _loadHotels();
    setState(() => _isLoading = false);
  }

  Future<void> _getCurrentLocation() async {
    final position = await LocationService.getCurrentLocation();
    if (position != null) {
      setState(() {
        _currentPosition = position;
        _currentLatLng = LatLng(position.latitude, position.longitude);
      });
      
      final address = await LocationService.getAddressFromLatLng(
        position.latitude, 
        position.longitude
      );
      setState(() => _currentAddress = address);
    } else {
      setState(() {
        _currentAddress = 'Location unavailable';
        _currentLatLng = const LatLng(-6.2088, 106.8456);
      });
    }
  }

  Future<void> _loadHotels() async {
    if (_currentPosition != null) {
      final hotels = await ApiService.getNearbyHotels(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        _radius,
      );
      setState(() => _hotels = hotels);
    } else {
      final hotels = await ApiService.getAllHotels();
      setState(() => _hotels = hotels);
    }
  }

  void _refreshLocation() async {
    setState(() => _isLoading = true);
    await _getCurrentLocation();
    await _loadHotels();
    setState(() => _isLoading = false);
  }

  void _updateRadius(double value) async {
    setState(() => _radius = value);
    if (_currentPosition != null) {
      final hotels = await ApiService.getNearbyHotels(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        _radius,
      );
      setState(() => _hotels = hotels);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Hotels'),
        backgroundColor: const Color(0xFF0B1E3C),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _refreshLocation,
            tooltip: 'Refresh location',
          ),
        ],
      ),
      body: Column(
        children: [
          // Location Info
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Color(0xFFF59E0B)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _currentAddress,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Radius Slider
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                const Icon(Icons.radio_button_checked, size: 16, color: Color(0xFFF59E0B)),
                const SizedBox(width: 8),
                const Text('Radius: '),
                Expanded(
                  child: Slider(
                    value: _radius,
                    min: 1,
                    max: 50,
                    divisions: 49,
                    label: '${_radius.toInt()} km',
                    onChanged: _updateRadius,
                    activeColor: const Color(0xFFF59E0B),
                  ),
                ),
                Text('${_radius.toInt()} km', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // Map
          SizedBox(
            height: 350,
            child: _currentLatLng == null
                ? const Center(child: Text('Loading map...'))
                : FlutterMap(
                    options: MapOptions(
                      initialCenter: _currentLatLng!,
                      initialZoom: 12,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                        userAgentPackageName: 'com.imgo.customer',
                      ),
                      MarkerLayer(
                        markers: [
                          // Current location marker
                          Marker(
                            width: 40,
                            height: 40,
                            point: _currentLatLng!,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.5),
                                    blurRadius: 10,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.my_location, color: Colors.white, size: 20),
                            ),
                          ),
                          // Hotel markers
                          ..._hotels.map((hotel) {
                            return Marker(
                              width: 40,
                              height: 40,
                              point: LatLng(hotel.latitude, hotel.longitude),
                              child: GestureDetector(
                                onTap: () => _showHotelInfo(hotel),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF59E0B),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.hotel, size: 18, color: Colors.white),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
          ),
          // Hotel List
          Expanded(
            child: _hotels.isEmpty
                ? const Center(child: Text('No hotels found in this radius'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _hotels.length,
                    itemBuilder: (context, index) {
                      final hotel = _hotels[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.hotel, color: Color(0xFFF59E0B)),
                          title: Text(hotel.name),
                          subtitle: Text('⭐ ${hotel.rating} • Rp ${hotel.price.toInt()}/night'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _showHotelInfo(hotel),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showHotelInfo(Hotel hotel) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.hotel, size: 30, color: Color(0xFFF59E0B)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    hotel.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text('${hotel.rating}'),
                const SizedBox(width: 16),
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 4),
                Expanded(child: Text(hotel.city, style: const TextStyle(fontSize: 12))),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              hotel.address,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Text(
              'Price: Rp ${hotel.price.toInt()}/night',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Book Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
