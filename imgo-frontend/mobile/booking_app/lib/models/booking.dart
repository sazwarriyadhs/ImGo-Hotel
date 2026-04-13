class Booking {
  final String id;
  final String hotelId;
  final String hotelName;
  final String roomType;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final int rooms;
  final double totalPrice;
  final String status;
  final bool addBreakfast;
  final bool addExtraBed;
  final String? guestName;
  final String? guestEmail;
  final String? guestPhone;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.hotelId,
    required this.hotelName,
    required this.roomType,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.rooms,
    required this.totalPrice,
    required this.status,
    required this.addBreakfast,
    required this.addExtraBed,
    this.guestName,
    this.guestEmail,
    this.guestPhone,
    required this.createdAt,
  });

  bool get isUpcoming => checkIn.isAfter(DateTime.now()) && status == 'confirmed';
  bool get isCompleted => checkOut.isBefore(DateTime.now()) && status == 'confirmed';
  bool get isCancelled => status == 'cancelled';
  int get nights => checkOut.difference(checkIn).inDays;

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id']?.toString() ?? '',
      hotelId: json['hotel_id']?.toString() ?? '',
      hotelName: json['hotel_name'] ?? '',
      roomType: json['room_type'] ?? '',
      checkIn: json['check_in'] != null ? DateTime.parse(json['check_in']) : DateTime.now(),
      checkOut: json['check_out'] != null ? DateTime.parse(json['check_out']) : DateTime.now(),
      guests: json['guests'] ?? 1,
      rooms: json['rooms'] ?? 1,
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      addBreakfast: json['add_breakfast'] ?? false,
      addExtraBed: json['add_extra_bed'] ?? false,
      guestName: json['guest_name'],
      guestEmail: json['guest_email'],
      guestPhone: json['guest_phone'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }
}
