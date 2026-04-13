import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/hotel.dart';
import '../booking/booking_screen.dart';

class HotelDetailScreen extends StatefulWidget {
  final Hotel hotel;
  const HotelDetailScreen({super.key, required this.hotel});

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  int _selectedImageIndex = 0;
  DateTime _checkIn = DateTime.now();
  DateTime _checkOut = DateTime.now().add(const Duration(days: 2));
  int _guests = 2;
  int _rooms = 1;
  RoomType? _selectedRoom;

  @override
  void initState() {
    super.initState();
    if (widget.hotel.roomTypes.isNotEmpty) {
      _selectedRoom = widget.hotel.roomTypes.first;
    }
  }

  int get _nights => _checkOut.difference(_checkIn).inDays;
  double get _totalPrice => (_selectedRoom?.price ?? widget.hotel.price) * _nights * _rooms;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hotel.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF0B1E3C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Gallery
            SizedBox(
              height: 250,
              child: Stack(
                children: [
                  PageView.builder(
                    onPageChanged: (index) => setState(() => _selectedImageIndex = index),
                    itemCount: widget.hotel.images.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Text(
                            widget.hotel.images[index],
                            style: const TextStyle(fontSize: 80),
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.hotel.images.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _selectedImageIndex == index
                                ? const Color(0xFFF59E0B)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.hotel.name,
                          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              widget.hotel.rating.toString(),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.hotel.address,
                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Deskripsi',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.hotel.description,
                    style: GoogleFonts.poppins(fontSize: 14, height: 1.5, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Fasilitas',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.hotel.facilities.map((facility) {
                      return Chip(
                        label: Text(facility),
                        backgroundColor: Colors.grey[100],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pilih Kamar',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...widget.hotel.roomTypes.map((room) => _buildRoomCard(room)),
                  const SizedBox(height: 16),
                  Text(
                    'Pilih Tanggal',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _buildDateButton('Check In', _checkIn, _selectCheckIn)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildDateButton('Check Out', _checkOut, _selectCheckOut)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildCounter('Tamu', _guests, 1, 10, (v) => setState(() => _guests = v))),
                      const SizedBox(width: 12),
                      Expanded(child: _buildCounter('Kamar', _rooms, 1, 5, (v) => setState(() => _rooms = v))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ulasan',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...widget.hotel.reviews.take(3).map((review) => _buildReviewCard(review)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Harga', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text(
                  'Rp ${_totalPrice.toInt().toString()}',
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFFF59E0B)),
                ),
                Text('${_nights} malam, $_rooms kamar', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingScreen(
                      hotel: widget.hotel,
                      roomType: _selectedRoom!,
                      checkIn: _checkIn,
                      checkOut: _checkOut,
                      guests: _guests,
                      rooms: _rooms,
                      totalPrice: _totalPrice,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Pesan Sekarang'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomCard(RoomType room) {
    final isSelected = _selectedRoom?.id == room.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedRoom = room),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? const Color(0xFFF59E0B) : Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? const Color(0xFFF59E0B).withOpacity(0.05) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(room.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('${room.capacity} tamu • Tersedia ${room.available} kamar'),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rp ${room.price.toInt().toString()}',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFFF59E0B)),
                ),
                const Text('/malam', style: TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateButton(String label, DateTime date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            const SizedBox(height: 4),
            Text(DateFormat('dd MMM yyyy').format(date), style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildCounter(String label, int value, int min, int max, Function(int) onChanged) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => value > min ? onChanged(value - 1) : null,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.remove, size: 20),
                ),
              ),
              Text(value.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              InkWell(
                onTap: () => value < max ? onChanged(value + 1) : null,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: Text(review.userName[0]),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < review.rating.floor() ? Icons.star : Icons.star_border,
                          size: 14,
                          color: Colors.amber,
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Text(
                DateFormat('dd MMM yyyy').format(review.createdAt),
                style: TextStyle(fontSize: 10, color: Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(review.comment, style: GoogleFonts.poppins(fontSize: 13)),
        ],
      ),
    );
  }

  Future<void> _selectCheckIn() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _checkIn,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null && date != _checkIn) {
      setState(() => _checkIn = date);
      if (_checkOut.isBefore(_checkIn)) {
        setState(() => _checkOut = _checkIn.add(const Duration(days: 1)));
      }
    }
  }

  Future<void> _selectCheckOut() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _checkOut,
      firstDate: _checkIn,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) setState(() => _checkOut = date);
  }
}
