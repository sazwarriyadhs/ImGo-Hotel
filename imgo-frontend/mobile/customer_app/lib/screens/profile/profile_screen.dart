import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text('Profile', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
          Center(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                    color: const Color(0xFF1E293B),
                  ),
                  child: const Center(
                    child: Icon(Icons.person, size: 50, color: Color(0xFFD4AF37)),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Sarah Wilson', 
                  style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('sarah.wilson@example.com', 
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFF5D06F)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Platinum Member', 
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildProfileMenuItem(context, Icons.person_outline, 'Personal Information'),
          _buildProfileMenuItem(context, Icons.credit_card, 'Payment Methods'),
          _buildProfileMenuItem(context, Icons.notifications_none, 'Notification Settings'),
          _buildProfileMenuItem(context, Icons.security, 'Privacy & Security'),
          _buildProfileMenuItem(context, Icons.help_outline, 'Help Center'),
          _buildProfileMenuItem(context, Icons.logout, 'Logout', isLogout: true),
        ],
      ),
    );
  }

  Widget _buildProfileMenuItem(BuildContext context, IconData icon, String title, {bool isLogout = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF0F172A)]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
      ),
      child: ListTile(
        leading: Icon(icon, color: isLogout ? Colors.red : const Color(0xFFD4AF37)),
        title: Text(title, 
          style: GoogleFonts.poppins(color: isLogout ? Colors.red : Colors.white)),
        trailing: Icon(Icons.chevron_right, color: isLogout ? Colors.red : Colors.grey, size: 20),
        onTap: () {
          if (isLogout) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logout feature coming soon!'), backgroundColor: Color(0xFFD4AF37)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(' feature coming soon!'), backgroundColor: const Color(0xFFD4AF37)),
            );
          }
        },
      ),
    );
  }
}
