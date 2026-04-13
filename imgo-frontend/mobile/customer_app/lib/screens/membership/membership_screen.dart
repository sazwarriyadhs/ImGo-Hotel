import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MembershipScreen extends StatelessWidget {
  const MembershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text('Membership', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFF5D06F)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text('Platinum Gold', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(height: 8),
                Text('Member since 2024', style: GoogleFonts.poppins(color: Colors.black54)),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: 0.75,
                  backgroundColor: Colors.black26,
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 8),
                Text('150 points to next tier', style: GoogleFonts.poppins(color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildBenefitItem('✨', 'Exclusive Discounts', 'Up to 20% off on all bookings'),
          _buildBenefitItem('🎁', 'Birthday Bonus', 'Extra 500 points on your birthday'),
          _buildBenefitItem('🏨', 'Room Upgrades', 'Priority room upgrades when available'),
          _buildBenefitItem('🍽️', 'Restaurant Priority', 'Skip the queue at our restaurants'),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF0F172A)]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
      ),
      child: ListTile(
        leading: Text(icon, style: const TextStyle(fontSize: 24)),
        title: Text(title, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: Text(description, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
      ),
    );
  }
}
