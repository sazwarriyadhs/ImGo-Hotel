class Booking {
  final String id;
  final String hotelName;
  final String roomType;
  final String dates;
  final String status;

  Booking({
    required this.id,
    required this.hotelName,
    required this.roomType,
    required this.dates,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id']?.toString() ?? '',
      hotelName: json['hotel_name'] ?? '',
      roomType: json['room_type'] ?? '',
      dates: json['dates'] ?? '',
      status: json['status'] ?? 'confirmed',
    );
  }
}
