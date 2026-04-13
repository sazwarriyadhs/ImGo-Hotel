import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.restaurant, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Restaurant Features Coming Soon',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
