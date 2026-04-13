import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text('My Wallet', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: const Color(0xFFF8FAFC),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFF5D06F)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text('Total Balance', style: GoogleFonts.poppins(color: Colors.black54, fontSize: 14)),
                const SizedBox(height: 8),
                Text('Rp 2.500.000', style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(height: 8),
                Text('Points: 2,850', style: GoogleFonts.poppins(color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildTransactionItem('Hotel Booking', 'IMGO Hotel Jakarta', '-Rp 1.200.000', 'May 15, 2026'),
                _buildTransactionItem('Spa Service', 'Traditional Massage', '-Rp 250.000', 'May 16, 2026'),
                _buildTransactionItem('Points Earned', 'Welcome Bonus', '+500 points', 'May 14, 2026'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(String title, String description, String amount, String date) {
    bool isNegative = amount.startsWith('-');
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF0F172A)]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
      ),
      child: ListTile(
        leading: Icon(isNegative ? Icons.remove_circle : Icons.add_circle, color: isNegative ? Colors.red : Colors.green),
        title: Text(title, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: Text(description, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(amount, style: GoogleFonts.poppins(color: isNegative ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
            Text(date, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
