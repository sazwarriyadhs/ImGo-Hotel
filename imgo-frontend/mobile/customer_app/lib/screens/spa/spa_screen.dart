import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpaScreen extends StatelessWidget {
  const SpaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text('Spa & Wellness', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
          _buildServiceCard(context, 'Traditional Massage', 'Rp 250.000', '60 min', '💆', 'Relaxing traditional Indonesian massage'),
          _buildServiceCard(context, 'Aromatherapy', 'Rp 350.000', '90 min', '🌿', 'Soothing massage with essential oils'),
          _buildServiceCard(context, 'Hot Stone Massage', 'Rp 400.000', '75 min', '🪨', 'Therapeutic massage with heated stones'),
          _buildServiceCard(context, 'Facial Treatment', 'Rp 280.000', '45 min', '✨', 'Luxurious facial for glowing skin'),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, String name, String price, String duration, String emoji, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF0F172A)]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Text(emoji, style: const TextStyle(fontSize: 30)),
            title: Text(name, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(description, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 4),
                Text(' • ', style: GoogleFonts.poppins(color: const Color(0xFFD4AF37))),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking confirmed!'), backgroundColor: Color(0xFFD4AF37)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.black,
              ),
              child: const Text('Book'),
            ),
          ),
        ],
      ),
    );
  }
}
