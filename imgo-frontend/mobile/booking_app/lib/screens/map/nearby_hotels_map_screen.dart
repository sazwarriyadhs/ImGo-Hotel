import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/api_service.dart';
import '../../services/location_service.dart';
import '../../models/hotel.dart';
import '../hotel/hotel_detail_screen.dart';

class NearbyHotelsMapScreen extends StatefulWidget {
  const NearbyHotelsMapScreen({super.key});

  @override
  State<NearbyHotelsMapScreen> createState() => _NearbyHotelsMapScreenState();
}

class _NearbyHotelsMapScreenState extends State<NearbyHotelsMapScreen> {
  List<Hotel> _hotels = [];
  List<Hotel> _nearbyHotels = [];
  bool _isLoading = true;
  bool _isLoadingLocation = true;
  Position? _currentPosition;
  LatLng? _currentLatLng;
  String _currentAddress = 'Mengambil lokasi...';
  double _radius = 10; // Radius dalam km
  String _sortBy = 'distance'; // distance, price, rating

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _getCurrentLocation();
    await _loadHotels();
    _calculateNearbyHotels();
    setState(() => _isLoading = false);
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    
    final position = await LocationService.getCurrentLocation();
    if (position != null) {
      setState(() {
        _currentPosition = position;
        _currentLatLng = LatLng(position.latitude, position.longitude);
        _isLoadingLocation = false;
      });
      
      // Get address
      final address = await LocationService.getAddressFromLatLng(
        position.latitude, 
        position.longitude
      );
      setState(() => _currentAddress = address);
    } else {
      setState(() {
        _isLoadingLocation = false;
        _currentAddress = 'Lokasi tidak tersedia';
        // Default ke Jakarta
        _currentLatLng = const LatLng(-6.2088, 106.8456);
      });
    }
  }

  Future<void> _loadHotels() async {
    final hotels = await ApiService.getHotels();
    setState(() => _hotels = hotels);
  }

  void _calculateNearbyHotels() {
    if (_currentPosition == null) {
      setState(() => _nearbyHotels = _hotels);
      return;
    }
    
    // Hitung jarak untuk setiap hotel
    final hotelsWithDistance = _hotels.map((hotel) {
      final distance = LocationService.calculateDistance(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        hotel.lat,
        hotel.lng,
      );
      return {'hotel': hotel, 'distance': distance};
    }).toList();
    
    // Filter berdasarkan radius
    var filtered = hotelsWithDistance
        .where((item) => item['distance'] <= _radius)
        .toList();
    
    // Sort
    switch (_sortBy) {
      case 'distance':
        filtered.sort((a, b) => a['distance'].compareTo(b['distance']));
        break;
      case 'price':
        filtered.sort((a, b) => a['hotel'].price.compareTo(b['hotel'].price));
        break;
      case 'rating':
        filtered.sort((a, b) => b['hotel'].rating.compareTo(a['hotel'].rating));
        break;
    }
    
    setState(() {
      _nearbyHotels = filtered.map((item) => item['hotel'] as Hotel).toList();
    });
  }

  void _refreshLocation() async {
    setState(() => _isLoading = true);
    await _getCurrentLocation();
    _calculateNearbyHotels();
    setState(() => _isLoading = false);
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
        title: Text('Hotel Terdekat', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF0B1E3C),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _refreshLocation,
            tooltip: 'Refresh lokasi',
          ),
        ],
      ),
      body: Column(
        children: [
          // Location Info Bar
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              children: [
                Icon(
                  _isLoadingLocation ? Icons.location_searching : Icons.location_on,
                  size: 20,
                  color: const Color(0xFFF59E0B),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _currentAddress,
                    style: GoogleFonts.poppins(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_isLoadingLocation)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
          // Map
          SizedBox(
            height: 300,
            child: _currentLatLng == null
                ? const Center(child: Text('Memuat peta...'))
                : FlutterMap(
                    options: MapOptions(
                      initialCenter: _currentLatLng!,
                      initialZoom: 12,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                        userAgentPackageName: 'com.imgo.booking',
                      ),
                      // Current location marker
                      MarkerLayer(
                        markers: [
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
                          ..._nearbyHotels.map((hotel) {
                            return Marker(
                              width: 40,
                              height: 40,
                              point: LatLng(hotel.lat, hotel.lng),
                              child: GestureDetector(
                                onTap: () {
                                  _showHotelDetail(hotel);
                                },
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
          // Filter & Sort Bar
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<double>(
                    value: _radius,
                    decoration: const InputDecoration(
                      labelText: 'Radius',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: [5, 10, 20, 30, 50].map((value) {
                      return DropdownMenuItem(value: value.toDouble(), child: Text('$value km'));
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _radius = value ?? 10);
                      _calculateNearbyHotels();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _sortBy,
                    decoration: const InputDecoration(
                      labelText: 'Urutkan',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'distance', child: Text('Terdekat')),
                      DropdownMenuItem(value: 'price', child: Text('Termurah')),
                      DropdownMenuItem(value: 'rating', child: Text('Rating Tertinggi')),
                    ],
                    onChanged: (value) {
                      setState(() => _sortBy = value ?? 'distance');
                      _calculateNearbyHotels();
                    },
                  ),
                ),
              ],
            ),
          ),
          // Hotel List
          Expanded(
            child: _nearbyHotels.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.hotel, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada hotel dalam radius $_radius km',
                          style: GoogleFonts.poppins(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() => _radius = 20);
                            _calculateNearbyHotels();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF59E0B),
                          ),
                          child: const Text('Perbesar Radius'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _nearbyHotels.length,
                    itemBuilder: (context, index) {
                      final hotel = _nearbyHotels[index];
                      final distance = LocationService.calculateDistance(
                        _currentPosition?.latitude ?? hotel.lat,
                        _currentPosition?.longitude ?? hotel.lng,
                        hotel.lat,
                        hotel.lng,
                      );
                      return _buildHotelCard(hotel, distance);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelCard(Hotel hotel, double distance) {
    return GestureDetector(
      onTap: () => _showHotelDetail(hotel),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    hotel.images.isNotEmpty ? hotel.images[0] : '🏨',
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotel.name,
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 12, color: Colors.grey),
                        const SizedBox(width: 2),
                        Text(
                          '${distance.toStringAsFixed(1)} km',
                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 12, color: Colors.amber),
                            Text(
                              ' ${hotel.rating}',
                              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hotel.city,
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp ${hotel.price.toInt().toString()} / malam',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showHotelDetail(Hotel hotel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelDetailScreen(hotel: hotel),
      ),
    );
  }
}
