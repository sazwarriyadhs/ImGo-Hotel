import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../models/booking.dart';

// Import screens
import '../hotels/hotels_screen.dart';
import '../restaurant/restaurant_screen.dart';
import '../spa/spa_screen.dart';
import '../pilates/pilates_screen.dart';
import '../bookings/bookings_screen.dart';
import '../wishlist/wishlist_screen.dart';
import '../profile/profile_screen.dart';
import '../notifications/notifications_screen.dart';
import '../wallet/wallet_screen.dart';
import '../membership/membership_screen.dart';
import '../services/room_service_screen.dart';
import '../services/luggage_service_screen.dart';
import '../services/concierge_chat_screen.dart';
import '../services/airport_transfer_screen.dart';
import '../services/local_tours_screen.dart';
import '../services/fitness_center_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  List<Booking> _bookings = [];
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    _bookings = await ApiService.getUserBookings();
    setState(() => _isLoading = false);
  }

  void _navigateToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _navigateToService(String service) {
    switch (service) {
      case 'Order Room Service':
        _navigateToScreen(const RoomServiceScreen());
        break;
      case 'Spa':
        _navigateToScreen(const SpaScreen());
        break;
      case 'Restaurant':
        _navigateToScreen(const RestaurantScreen());
        break;
      case 'Luggage Service':
        _navigateToScreen(const LuggageServiceScreen());
        break;
      case 'Concierge Chat':
        _navigateToScreen(const ConciergeChatScreen());
        break;
      case 'Airport Transfer':
        _navigateToScreen(const AirportTransferScreen());
        break;
      case 'Local Tours':
        _navigateToScreen(const LocalToursScreen());
        break;
      case 'Fitness Center':
        _navigateToScreen(const FitnessCenterScreen());
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$service coming soon!'),
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFFD4AF37),
          ),
        );
    }
  }

  void _navigateToMenuItem(String item) {
    switch (item) {
      case 'Notifications':
        _navigateToScreen(const NotificationsScreen());
        break;
      case 'My Wallet':
        _navigateToScreen(const WalletScreen());
        break;
      case 'Membership':
        _navigateToScreen(const MembershipScreen());
        break;
      case 'Profile':
        _navigateToScreen(const ProfileScreen());
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$item coming soon!'),
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFFD4AF37),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    int points = user?.points ?? 2850;
    int totalEarned = user?.totalEarned ?? 3250;
    int redeemedPoints = (user?.totalEarned ?? 3250) - (user?.points ?? 2850);
    int pointsToNext = user?.pointsToNextTier ?? 150;
    String tier = user?.tier ?? 'Platinum Gold';

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              width: 100,
                              height: 100,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFD4AF37), Color(0xFFF5D06F)],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text('IMG', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Customer Portal',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFF8FAFC),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.notifications_none, color: Color(0xFFCBD5E1)),
                              onPressed: () => _navigateToScreen(const NotificationsScreen()),
                            ),
                            GestureDetector(
                              onTap: () => _navigateToScreen(const ProfileScreen()),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
                                  color: const Color(0xFF1E293B),
                                ),
                                child: const Center(
                                  child: Icon(Icons.person, size: 16, color: Color(0xFFD4AF37)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome back,',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.name ?? 'Sarah Wilson',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFF8FAFC),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Your Bookings Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Bookings',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFF8FAFC),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _navigateToScreen(const BookingsScreen()),
                      child: Text(
                        'View All',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFD4AF37),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Bookings List
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _bookings.length > 0 ? _bookings.length : 3,
                        itemBuilder: (context, index) {
                          final booking = _bookings.isNotEmpty ? _bookings[index] : null;
                          return GestureDetector(
                            onTap: () => _navigateToScreen(const BookingsScreen()),
                            child: Container(
                              width: 280,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFD4AF37).withOpacity(0.3),
                                  width: 0.5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD4AF37).withOpacity(0.1),
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        booking?.hotelName.contains('Bali') == true ? '🏖️' : '🏨',
                                        style: const TextStyle(fontSize: 40),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          booking?.hotelName ?? 'IMGO Hotel Jakarta',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFFF8FAFC),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          booking?.dates ?? 'May 15 - May 20, 2026',
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: const Color(0xFF94A3B8),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          booking?.roomType ?? 'Deluxe Suite',
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: const Color(0xFFCBD5E1),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () => _navigateToScreen(const BookingsScreen()),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFFD4AF37),
                                              foregroundColor: const Color(0xFF0F172A),
                                              minimumSize: const Size(double.infinity, 30),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text(
                                              'Manage Stay',
                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              const SizedBox(height: 24),
              // Guest Profile / Points Card
              GestureDetector(
                onTap: () => _navigateToScreen(const MembershipScreen()),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withOpacity(0.3),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFD4AF37), Color(0xFFF5D06F)],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                tier,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$points Points',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFF8FAFC),
                                      ),
                                    ),
                                    Text(
                                      '$totalEarned Points Total',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 24),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$redeemedPoints Points',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFF8FAFC),
                                      ),
                                    ),
                                    Text(
                                      '$pointsToNext Points to Next Tier',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFD4AF37), Color(0xFFF5D06F)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.stars, color: Color(0xFF0F172A), size: 28),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Hotel Services
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Hotel Services',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFF8FAFC),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Row 1
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildServiceCard('Order Room Service', '🍽️', 'Order Now'),
                    _buildServiceCard('Spa', '💆', 'Book Now'),
                    _buildServiceCard('Restaurant', '🍽️', 'Book Now'),
                    _buildServiceCard('Luggage Service', '🧳', 'Request'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Row 2
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildServiceCard('Concierge Chat', '💬', 'Chat'),
                    _buildServiceCard('Airport Transfer', '✈️', 'Book Now'),
                    _buildServiceCard('Local Tours', '🏛️', 'Book Now'),
                    _buildServiceCard('Fitness Center', '💪', 'View'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Menu Items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildMenuItem(Icons.notifications, 'Notifications'),
                    _buildMenuItem(Icons.wallet, 'My Wallet'),
                    _buildMenuItem(Icons.card_membership, 'Membership'),
                    _buildMenuItem(Icons.person, 'Profile'),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFFD4AF37),
          unselectedItemColor: const Color(0xFF94A3B8),
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() => _currentIndex = index);
            switch (index) {
              case 0:
                // Already on home
                break;
              case 1:
                _navigateToScreen(const BookingsScreen());
                break;
              case 2:
                _navigateToScreen(const WishlistScreen());
                break;
              case 3:
                _navigateToScreen(const ProfileScreen());
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Bookings'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Wishlist'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(String title, String icon, String actionText) {
    return GestureDetector(
      onTap: () => _navigateToService(title),
      child: SizedBox(
        width: 75,
        child: Column(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFD4AF37).withOpacity(0.3),
                  width: 0.5,
                ),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFCBD5E1),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              actionText,
              style: GoogleFonts.poppins(
                fontSize: 9,
                color: const Color(0xFFD4AF37),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return GestureDetector(
      onTap: () => _navigateToMenuItem(title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFD4AF37).withOpacity(0.2),
            width: 0.5,
          ),
        ),
        child: ListTile(
          leading: Icon(icon, color: const Color(0xFFD4AF37)),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              color: const Color(0xFFF8FAFC),
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 20),
        ),
      ),
    );
  }
}