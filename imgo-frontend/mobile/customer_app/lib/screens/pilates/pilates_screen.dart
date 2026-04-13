import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PilatesScreen extends StatelessWidget {
  const PilatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text('Pilates', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
          _buildClassCard(context, 'Beginner Pilates', '09:00 AM', 'Maria Gonzalez', '60 min', 'Perfect for beginners'),
          _buildClassCard(context, 'Intermediate Mat', '10:30 AM', 'Sarah Johnson', '60 min', 'For experienced practitioners'),
          _buildClassCard(context, 'Advanced Reformer', '01:00 PM', 'David Chen', '75 min', 'Advanced reformer class'),
          _buildClassCard(context, 'Yoga Fusion', '08:30 AM', 'Anita Sharma', '90 min', 'Combine yoga and pilates'),
        ],
      ),
    );
  }

  Widget _buildClassCard(BuildContext context, String name, String time, String instructor, String duration, String description) {
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
            leading: const Icon(Icons.fitness_center, color: Color(0xFFD4AF37), size: 30),
            title: Text(name, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(description, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 4),
                Text(' •  • ', style: GoogleFonts.poppins(color: const Color(0xFFD4AF37), fontSize: 11)),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Class joined!'), backgroundColor: Color(0xFFD4AF37)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.black,
              ),
              child: const Text('Join'),
            ),
          ),
        ],
      ),
    );
  }
}
