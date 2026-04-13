import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hotel_detail_screen.dart';

class HotelListScreen extends StatelessWidget {
  const HotelListScreen({super.key});

  final List<Map<String, dynamic>> _hotels = const [
    {
      'id': '1',
      'name': 'IMGO Hotel Jakarta',
      'city': 'Jakarta',
      'price': 850000,
      'rating': 4.8,
      'image': '🏨',
    },
    {
      'id': '2',
      'name': 'IMGO Hotel Surabaya',
      'city': 'Surabaya',
      'price': 750000,
      'rating': 4.6,
      'image': '🏨',
    },
    {
      'id': '3',
      'name': 'IMGO Hotel Bandung',
      'city': 'Bandung',
      'price': 650000,
      'rating': 4.7,
      'image': '🏨',
    },
    {
      'id': '4',
      'name': 'IMGO Hotel Denpasar',
      'city': 'Bali',
      'price': 950000,
      'rating': 4.9,
      'image': '🏖️',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _hotels.length,
      itemBuilder: (context, index) {
        final hotel = _hotels[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HotelDetailScreen(hotelId: hotel['id'] as String),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Center(
                    child: Text(hotel['image'] as String, style: const TextStyle(fontSize: 60)),
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
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
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
                                Text(
                                  hotel['rating'].toString(),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hotel['city'] as String,
                        style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12),
                      ),
                      const SizedBox(height: 8),
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
                            onPressed: () {},
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
    );
  }
}
