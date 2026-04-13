class Hotel {
  final String id;
  final String name;
  final String city;
  final String address;
  final double lat;
  final double lng;
  final double price;
  final double rating;
  final List<String> images;
  final List<String> facilities;
  final String description;
  final List<RoomType> roomTypes;
  final List<Review> reviews;
  final String phone;
  final String email;

  Hotel({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.lat,
    required this.lng,
    required this.price,
    required this.rating,
    required this.images,
    required this.facilities,
    required this.description,
    required this.roomTypes,
    required this.reviews,
    required this.phone,
    required this.email,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      lat: (json['lat'] ?? -6.2088).toDouble(),
      lng: (json['lng'] ?? 106.8456).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      images: json['images'] != null ? List<String>.from(json['images']) : ['🏨'],
      facilities: json['facilities'] != null ? List<String>.from(json['facilities']) : [],
      description: json['description'] ?? '',
      roomTypes: json['rooms'] != null 
          ? (json['rooms'] as List).map((r) => RoomType.fromJson(r)).toList() 
          : [],
      reviews: json['reviews'] != null 
          ? (json['reviews'] as List).map((r) => Review.fromJson(r)).toList() 
          : [],
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class RoomType {
  final String id;
  final String name;
  final String description;
  final double price;
  final int capacity;
  final int available;
  final List<String> amenities;

  RoomType({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.capacity,
    required this.available,
    required this.amenities,
  });

  factory RoomType.fromJson(Map<String, dynamic> json) {
    return RoomType(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      capacity: json['capacity'] ?? 2,
      available: json['available'] ?? 0,
      amenities: json['amenities'] != null ? List<String>.from(json['amenities']) : [],
    );
  }
}

class Review {
  final String id;
  final String userId;
  final String userName;
  final String? userPhoto;
  final double rating;
  final String comment;
  final List<String>? images;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhoto,
    required this.rating,
    required this.comment,
    this.images,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      userName: json['user_name'] ?? '',
      userPhoto: json['user_photo'],
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }
}
