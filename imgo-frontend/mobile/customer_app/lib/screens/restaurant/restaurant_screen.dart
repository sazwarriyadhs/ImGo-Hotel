import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text('Restaurant', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
          _buildMenuItem(context, 'Nasi Goreng Special', 'Rp 85.000', '🍚', 'Nasi goreng with chicken, shrimp, and egg'),
          _buildMenuItem(context, 'Sate Ayam', 'Rp 65.000', '🍢', 'Chicken satay with peanut sauce'),
          _buildMenuItem(context, 'Gado-gado', 'Rp 55.000', '🥗', 'Indonesian salad with peanut sauce'),
          _buildMenuItem(context, 'Bebek Goreng', 'Rp 95.000', '🦆', 'Crispy fried duck with sambal'),
          _buildMenuItem(context, 'Es Campur', 'Rp 35.000', '🍧', 'Mixed ice dessert with fruits and jelly'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String name, String price, String emoji, String description) {
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
                Text(price, style: GoogleFonts.poppins(color: const Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order placed!'), backgroundColor: Color(0xFFD4AF37)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.black,
              ),
              child: const Text('Order'),
            ),
          ),
        ],
      ),
    );
  }
}
