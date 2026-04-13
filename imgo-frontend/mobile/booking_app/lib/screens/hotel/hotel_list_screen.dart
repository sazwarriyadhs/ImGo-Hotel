import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hotel_detail_screen.dart';

class HotelListScreen extends StatefulWidget {
  const HotelListScreen({super.key});

  @override
  State<HotelListScreen> createState() => _HotelListScreenState();
}

class _HotelListScreenState extends State<HotelListScreen> {
  String _selectedCity = 'All';
  String _sortBy = 'Price';
  double _maxPrice = 2000000;
  
  final List<String> _cities = ['All', 'Jakarta', 'Surabaya', 'Bandung', 'Bali', 'Medan', 'Yogyakarta'];
  final List<String> _sortOptions = ['Price', 'Rating', 'Popularity'];
  
  final List<Map<String, dynamic>> _allHotels = [
    {'id': '1', 'name': 'IMGO Hotel Jakarta', 'city': 'Jakarta', 'price': 850000, 'rating': 4.8, 'image': '🏨', 'facilities': ['Pool', 'Spa', 'Restaurant']},
    {'id': '2', 'name': 'IMGO Hotel Surabaya', 'city': 'Surabaya', 'price': 750000, 'rating': 4.6, 'image': '🏨', 'facilities': ['Restaurant', 'Gym']},
    {'id': '3', 'name': 'IMGO Hotel Bandung', 'city': 'Bandung', 'price': 650000, 'rating': 4.7, 'image': '🏨', 'facilities': ['Spa', 'Restaurant']},
    {'id': '4', 'name': 'IMGO Hotel Denpasar', 'city': 'Bali', 'price': 950000, 'rating': 4.9, 'image': '🏖️', 'facilities': ['Pool', 'Spa', 'Restaurant', 'Beach']},
    {'id': '5', 'name': 'IMGO Hotel Medan', 'city': 'Medan', 'price': 550000, 'rating': 4.5, 'image': '🏨', 'facilities': ['Restaurant']},
    {'id': '6', 'name': 'IMGO Hotel Yogyakarta', 'city': 'Yogyakarta', 'price': 600000, 'rating': 4.6, 'image': '🏨', 'facilities': ['Restaurant', 'Tour Desk']},
  ];

  List<Map<String, dynamic>> get _filteredHotels {
    var filtered = _allHotels.where((hotel) {
      if (_selectedCity != 'All' && hotel['city'] != _selectedCity) return false;
      if (hotel['price'] > _maxPrice) return false;
      return true;
    }).toList();
    
    if (_sortBy == 'Price') {
      filtered.sort((a, b) => a['price'].compareTo(b['price']));
    } else if (_sortBy == 'Rating') {
      filtered.sort((a, b) => b['rating'].compareTo(a['rating']));
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search hotels...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // City Filter
                      ..._cities.map((city) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(city),
                          selected: _selectedCity == city,
                          onSelected: (selected) => setState(() => _selectedCity = city),
                          selectedColor: const Color(0xFFF59E0B),
                          labelStyle: TextStyle(color: _selectedCity == city ? Colors.white : Colors.black),
                        ),
                      )),
                      const SizedBox(width: 8),
                      // Sort Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButton<String>(
                          value: _sortBy,
                          items: _sortOptions.map((sort) {
                            return DropdownMenuItem(value: sort, child: Text('Sort by: $sort'));
                          }).toList(),
                          onChanged: (value) => setState(() => _sortBy = value!),
                          underline: const SizedBox(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Hotel List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredHotels.length,
              itemBuilder: (context, index) {
                final hotel = _filteredHotels[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HotelDetailScreen(hotelId: hotel['id'] as String),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Container(
                            height: 180,
                            color: Colors.grey[200],
                            child: Center(
                              child: Text(hotel['image'] as String, style: const TextStyle(fontSize: 60)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      hotel['name'] as String,
                                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.star, size: 14, color: Colors.white),
                                        const SizedBox(width: 4),
                                        Text(hotel['rating'].toString(), style: const TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(hotel['city'] as String, style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: (hotel['facilities'] as List<dynamic>).map((facility) {
                                  return Chip(
                                    label: Text(facility, style: const TextStyle(fontSize: 11)),
                                    backgroundColor: Colors.grey[100],
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Starting from', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                      Text(
                                        'Rp ${(hotel['price'] as int).toString()}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFF59E0B),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HotelDetailScreen(hotelId: hotel['id'] as String),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF59E0B),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: const Text('Book Now'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
