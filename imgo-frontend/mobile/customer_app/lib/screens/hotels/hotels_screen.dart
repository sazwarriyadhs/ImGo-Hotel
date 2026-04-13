import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HotelsScreen extends StatelessWidget {
  const HotelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text('Our Hotels', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: const Color(0xFFF8FAFC),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHotelCard(context, 'IMGO Hotel Jakarta', 'Jakarta', 4.8, 'Rp 1.200.000', '🏨'),
          _buildHotelCard(context, 'IMGO Hotel Surabaya', 'Surabaya', 4.6, 'Rp 950.000', '🏨'),
          _buildHotelCard(context, 'IMGO Hotel Bandung', 'Bandung', 4.7, 'Rp 850.000', '🏨'),
          _buildHotelCard(context, 'IMGO Hotel Bali', 'Bali', 4.9, 'Rp 1.500.000', '🏖️'),
          _buildHotelCard(context, 'IMGO Hotel Yogyakarta', 'Yogyakarta', 4.8, 'Rp 890.000', '🏨'),
        ],
      ),
    );
  }

  Widget _buildHotelCard(BuildContext context, String name, String city, double rating, String price, String emoji) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF0F172A)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 50))),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text('📍 ', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFD4AF37), size: 16),
                    const SizedBox(width: 4),
                    Text('', style: GoogleFonts.poppins(color: Colors.white)),
                    const Spacer(),
                    Text(price, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFFD4AF37))),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Booking feature coming soon!'), backgroundColor: Color(0xFFD4AF37)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: const Color(0xFF0F172A),
                    ),
                    child: const Text('Book Now'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
