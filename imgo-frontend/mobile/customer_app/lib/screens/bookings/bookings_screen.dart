import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text('My Bookings', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
          _buildBookingCard(context, 'IMGO Hotel Jakarta', 'May 15 - May 20, 2026', 'Deluxe Suite', 'Confirmed', Colors.green),
          _buildBookingCard(context, 'IMGO Hotel Bali', 'June 10 - June 15, 2026', 'Ocean View', 'Pending', Colors.orange),
          _buildBookingCard(context, 'IMGO Hotel Yogyakarta', 'July 5 - July 8, 2026', 'Executive Room', 'Completed', Colors.grey),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, String hotel, String dates, String room, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF0F172A)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(hotel, 
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(status, 
                    style: GoogleFonts.poppins(fontSize: 10, color: statusColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 8),
              Text(dates, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
            ]),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.bed, size: 14, color: Colors.grey),
              const SizedBox(width: 8),
              Text(room, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
            ]),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Manage booking feature coming soon!'), backgroundColor: Color(0xFFD4AF37)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Manage Booking'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
