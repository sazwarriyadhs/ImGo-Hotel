import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../hotel/hotel_search_screen.dart';
import '../map/nearby_hotels_map_screen.dart';
import '../restaurant/restaurant_screen.dart';
import '../spa/spa_screen.dart';
import '../pilates/pilates_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HotelSearchScreen(),
    const NearbyHotelsMapScreen(),
    const RestaurantScreen(),
    const SpaScreen(),
    const PilatesScreen(),
    const ProfileScreen(),
  ];

  final List<String> _titles = ['Cari Hotel', 'Peta Terdekat', 'Restoran', 'Spa', 'Pilates', 'Profil'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex], style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF0B1E3C),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFF59E0B),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Peta'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Restoran'),
          BottomNavigationBarItem(icon: Icon(Icons.spa), label: 'Spa'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Pilates'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
