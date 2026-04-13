import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import '../home/home_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  const PaymentScreen({super.key, required this.bookingData});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPayment = 'QRIS';
  String _promoCode = '';
  double _discount = 0;
  bool _isProcessing = false;
  bool _promoApplied = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'QRIS', 'icon': '📱', 'color': const Color(0xFF6B4EFF), 'description': 'Scan QR code menggunakan aplikasi e-wallet'},
    {'name': 'GoPay', 'icon': '💚', 'color': const Color(0xFF00AA13), 'description': 'Bayar dengan GoPay'},
    {'name': 'OVO', 'icon': '💜', 'color': const Color(0xFF4A154B), 'description': 'Bayar dengan OVO'},
    {'name': 'DANA', 'icon': '🟢', 'color': const Color(0xFF00A3E0), 'description': 'Bayar dengan DANA'},
    {'name': 'Bank Transfer', 'icon': '🏦', 'color': const Color(0xFF0B1E3C), 'description': 'Transfer ke rekening bank'},
    {'name': 'Credit Card', 'icon': '💳', 'color': const Color(0xFFF59E0B), 'description': 'Bayar dengan kartu kredit'},
  ];

  double get _totalPrice => widget.bookingData['totalPrice'] - _discount;

  void _applyPromo() {
    if (_promoCode == 'DISKON10') {
      setState(() {
        _discount = widget.bookingData['totalPrice'] * 0.1;
        _promoApplied = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Promo berhasil ditambahkan! Diskon 10%')),
      );
    } else if (_promoCode == 'DISKON20' && _totalPrice > 1000000) {
      setState(() {
        _discount = widget.bookingData['totalPrice'] * 0.2;
        _promoApplied = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Promo berhasil ditambahkan! Diskon 20%')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode promo tidak valid')),
      );
    }
  }

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate payment processing
    try {
      // await ApiService.createBooking(widget.bookingData);
      
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Column(
              children: [
                Icon(Icons.check_circle, size: 60, color: Colors.green),
                SizedBox(height: 16),
                Text('Pembayaran Berhasil!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Terima kasih ${widget.bookingData['guestName']}'),
                const SizedBox(height: 8),
                Text('Pemesanan Anda telah dikonfirmasi.'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow('Hotel', widget.bookingData['hotel'].name),
                      _buildDetailRow('Kamar', widget.bookingData['roomType'].name),
                      _buildDetailRow('Check In', DateFormat('dd MMM yyyy').format(widget.bookingData['checkIn'])),
                      _buildDetailRow('Check Out', DateFormat('dd MMM yyyy').format(widget.bookingData['checkOut'])),
                      const Divider(),
                      _buildDetailRow('Total Bayar', 'Rp ${_totalPrice.toInt().toString()}', isBold: true),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pembayaran gagal: $e')),
      );
    }
    setState(() => _isProcessing = false);
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF0B1E3C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ringkasan Booking
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.bookingData['hotel'].name, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildDetailRow('Kamar', widget.bookingData['roomType'].name),
                  _buildDetailRow('Check In', DateFormat('dd MMM yyyy').format(widget.bookingData['checkIn'])),
                  _buildDetailRow('Check Out', DateFormat('dd MMM yyyy').format(widget.bookingData['checkOut'])),
                  _buildDetailRow('Tamu', '${widget.bookingData['guests']} dewasa'),
                  _buildDetailRow('Kamar', '${widget.bookingData['rooms']} kamar'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Promo Code
            Text('Kode Promo', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => _promoCode = value,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan kode promo',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _promoApplied ? null : _applyPromo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Terapkan'),
                ),
              ],
            ),
            if (_promoApplied)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Diskon ${(_discount / widget.bookingData['totalPrice'] * 100).toInt()}% berhasil diterapkan',
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            const SizedBox(height: 24),
            // Metode Pembayaran
            Text('Metode Pembayaran', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._paymentMethods.map((method) => RadioListTile<String>(
              title: Text(method['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
              subtitle: Text(method['description'], style: const TextStyle(fontSize: 12)),
              value: method['name'],
              groupValue: _selectedPayment,
              onChanged: (value) => setState(() => _selectedPayment = value!),
              activeColor: method['color'],
              contentPadding: EdgeInsets.zero,
            )),
            const SizedBox(height: 24),
            // Ringkasan Harga
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Subtotal', 'Rp ${widget.bookingData['totalPrice'].toInt().toString()}'),
                  if (_discount > 0) _buildDetailRow('Diskon', '- Rp ${_discount.toInt().toString()}'),
                  const Divider(),
                  _buildDetailRow('Total Pembayaran', 'Rp ${_totalPrice.toInt().toString()}', isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Informasi QRIS (jika dipilih)
            if (_selectedPayment == 'QRIS')
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: [
                    const Text('Scan QR Code berikut untuk membayar:'),
                    const SizedBox(height: 16),
                    Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(child: Icon(Icons.qr_code_scanner, size: 100)),
                    ),
                    const SizedBox(height: 16),
                    const Text('Atau klik tombol bayar untuk simulasi'),
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
            onPressed: _isProcessing ? null : _processPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isProcessing
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                : Text('Bayar Rp ${_totalPrice.toInt().toString()}', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }
}
