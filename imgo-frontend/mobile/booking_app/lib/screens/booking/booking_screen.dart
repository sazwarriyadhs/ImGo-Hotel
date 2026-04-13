import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/hotel.dart';
import '../../models/hotel.dart' as model;
import '../payment/payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final Hotel hotel;
  final RoomType roomType;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final int rooms;
  final double totalPrice;

  const BookingScreen({
    super.key,
    required this.hotel,
    required this.roomType,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.rooms,
    required this.totalPrice,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
  bool _addBreakfast = false;
  bool _addExtraBed = false;
  bool _isLoading = false;

  int get _nights => widget.checkOut.difference(widget.checkIn).inDays;
  
  double get _breakfastCost => _addBreakfast ? 150000.0 * widget.rooms * _nights : 0;
  double get _extraBedCost => _addExtraBed ? 200000.0 * widget.rooms * _nights : 0;
  double get _finalPrice => widget.totalPrice + _breakfastCost + _extraBedCost;

  Future<void> _proceedToPayment() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi semua data tamu')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            bookingData: {
              'hotel': widget.hotel,
              'roomType': widget.roomType,
              'checkIn': widget.checkIn,
              'checkOut': widget.checkOut,
              'guests': widget.guests,
              'rooms': widget.rooms,
              'totalPrice': _finalPrice,
              'addBreakfast': _addBreakfast,
              'addExtraBed': _addExtraBed,
              'guestName': _nameController.text,
              'guestEmail': _emailController.text,
              'guestPhone': _phoneController.text,
              'notes': _notesController.text,
            },
          ),
        ),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pemesanan', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF0B1E3C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.hotel.name, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Tipe Kamar', widget.roomType.name),
                  _buildSummaryRow('Check In', DateFormat('dd MMM yyyy').format(widget.checkIn)),
                  _buildSummaryRow('Check Out', DateFormat('dd MMM yyyy').format(widget.checkOut)),
                  _buildSummaryRow('Durasi', '$_nights malam'),
                  _buildSummaryRow('Jumlah Tamu', '${widget.guests} dewasa'),
                  _buildSummaryRow('Jumlah Kamar', '${widget.rooms} kamar'),
                  const Divider(),
                  _buildSummaryRow('Harga Kamar', 'Rp ${widget.totalPrice.toInt().toString()}', isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Layanan Tambahan', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  CheckboxListTile(
                    title: const Text('Breakfast (Rp 150.000/hari)'),
                    subtitle: Text('Untuk ${widget.guests} orang x $_nights malam'),
                    value: _addBreakfast,
                    onChanged: (v) => setState(() => _addBreakfast = v ?? false),
                    secondary: Text(
                      '+ Rp ${_breakfastCost.toInt().toString()}',
                      style: const TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(height: 1),
                  CheckboxListTile(
                    title: const Text('Extra Bed (Rp 200.000/hari)'),
                    subtitle: Text('Untuk ${widget.rooms} kamar x $_nights malam'),
                    value: _addExtraBed,
                    onChanged: (v) => setState(() => _addExtraBed = v ?? false),
                    secondary: Text(
                      '+ Rp ${_extraBedCost.toInt().toString()}',
                      style: const TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Data Tamu', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'No. Telepon',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Permintaan Khusus (Opsional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildSummaryRow('Harga Kamar', 'Rp ${widget.totalPrice.toInt().toString()}'),
                  if (_addBreakfast) _buildSummaryRow('Breakfast', '+ Rp ${_breakfastCost.toInt().toString()}'),
                  if (_addExtraBed) _buildSummaryRow('Extra Bed', '+ Rp ${_extraBedCost.toInt().toString()}'),
                  const Divider(),
                  _buildSummaryRow('Total Pembayaran', 'Rp ${_finalPrice.toInt().toString()}', isBold: true, fontSize: 18),
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
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _proceedToPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                : Text('Lanjut ke Pembayaran', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, double fontSize = 14}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: fontSize, color: isBold ? Colors.black : Colors.grey[600])),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? const Color(0xFFF59E0B) : null,
            ),
          ),
        ],
      ),
    );
  }
}
