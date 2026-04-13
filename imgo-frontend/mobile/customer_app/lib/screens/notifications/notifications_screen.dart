import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text('Notifications', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
          _buildNotificationItem('Welcome to IMGO Hotel!', 'Thank you for choosing IMGO Hotel. Enjoy your stay!', '10:30 AM'),
          _buildNotificationItem('Special Offer', 'Get 20% off on spa packages this weekend', 'Yesterday'),
          _buildNotificationItem('Booking Confirmed', 'Your booking at IMGO Hotel Jakarta has been confirmed', '2 days ago'),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String message, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF0F172A)]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
      ),
      child: ListTile(
        leading: const Icon(Icons.notifications, color: Color(0xFFD4AF37)),
        title: Text(title, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Text(time, style: GoogleFonts.poppins(color: Color(0xFFD4AF37), fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
