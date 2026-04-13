import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpaScreen extends StatelessWidget {
  const SpaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.spa, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Spa Features Coming Soon',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
