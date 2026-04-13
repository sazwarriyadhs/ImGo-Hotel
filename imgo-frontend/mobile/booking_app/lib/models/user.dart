class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? photo;
  final int points;
  final List<String> favorites;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photo,
    required this.points,
    required this.favorites,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      photo: json['photo'],
      points: json['points'] ?? 0,
      favorites: json['favorites'] != null ? List<String>.from(json['favorites']) : [],
    );
  }
}
