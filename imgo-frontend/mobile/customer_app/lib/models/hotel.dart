class Hotel {
  final String id;
  final String name;
  final String city;
  final String address;
  final double latitude;
  final double longitude;
  final double price;
  final double rating;
  final String description;
  final String phone;
  final String email;

  Hotel({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.price,
    required this.rating,
    required this.description,
    required this.phone,
    required this.email,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? json['lat'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? json['lng'] ?? 0).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
