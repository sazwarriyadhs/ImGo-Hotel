import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../models/hotel.dart';
import '../auth/login_screen.dart';
import '../bookings/booking_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Hotel> _favorites = [];
  bool _isLoadingFavorites = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoadingFavorites = true);
    final favorites = await ApiService.getFavorites();
    setState(() {
      _favorites = favorites;
      _isLoadingFavorites = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0B1E3C), Color(0xFF1a2d4a)],
                ),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: user?.photo != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(user!.photo!, fit: BoxFit.cover),
                              )
                            : const Icon(Icons.person, size: 50, color: Color(0xFF0B1E3C)),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.name ?? 'Guest User',
                    style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'guest@imgo.com',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('Poin', user?.points.toString() ?? '0'),
                      _buildStatItem('Booking', '0'),
                      _buildStatItem('Favorit', _favorites.length.toString()),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            // Menu Items
            const SizedBox(height: 16),
            _buildMenuItem(Icons.history, 'Riwayat Pemesanan', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookingHistoryScreen()),
              );
            }),
            _buildMenuItem(Icons.favorite_border, 'Hotel Favorit', () {
              _showFavoritesDialog();
            }),
            _buildMenuItem(Icons.card_giftcard, 'Loyalty Program', () {
              _showLoyaltyDialog();
            }),
            _buildMenuItem(Icons.notifications_none, 'Notifikasi', () {}),
            _buildMenuItem(Icons.lock_outline, 'Ubah Password', () {}),
            _buildMenuItem(Icons.language, 'Bahasa', () {}),
            _buildMenuItem(Icons.help_outline, 'Pusat Bantuan', () {}),
            _buildMenuItem(Icons.logout, 'Keluar', () async {
              await authProvider.logout();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            }, isLogout: true),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : const Color(0xFF0B1E3C)),
      title: Text(title, style: GoogleFonts.poppins(color: isLogout ? Colors.red : null)),
      trailing: Icon(Icons.chevron_right, color: isLogout ? Colors.red : Colors.grey),
      onTap: onTap,
    );
  }

  void _showFavoritesDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
              ),
              child: Text(
                'Hotel Favorit',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: _isLoadingFavorites
                  ? const Center(child: CircularProgressIndicator())
                  : _favorites.isEmpty
                      ? const Center(child: Text('Belum ada hotel favorit'))
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: _favorites.length,
                          itemBuilder: (context, index) {
                            final hotel = _favorites[index];
                            return ListTile(
                              leading: const Icon(Icons.hotel),
                              title: Text(hotel.name),
                              subtitle: Text(hotel.city),
                              trailing: const Icon(Icons.favorite, color: Colors.red),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoyaltyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Loyalty Program'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.stars, size: 50, color: Color(0xFFF59E0B)),
            const SizedBox(height: 16),
            Text(
              '1,250 Poin',
              style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Setiap transaksi mendapatkan poin'),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0.25,
              backgroundColor: Colors.grey[200],
              color: const Color(0xFFF59E0B),
            ),
            const SizedBox(height: 8),
            const Text('2,500 poin untuk naik ke Gold Tier', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            const Text('Rewards:', style: TextStyle(fontWeight: FontWeight.bold)),
            const ListTile(
              leading: Icon(Icons.local_cafe),
              title: Text('Free Breakfast'),
              trailing: Text('300 poin'),
              dense: true,
            ),
            const ListTile(
              leading: Icon(Icons.spa),
              title: Text('Spa Discount 20%'),
              trailing: Text('500 poin'),
              dense: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
