class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? photo;
  final int points;
  final int totalEarned;
  final int totalRedeemed;
  final int pointsToNextTier;
  final String tier;
  final String? membershipType;
  final String? membershipStatus;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photo,
    required this.points,
    required this.totalEarned,
    required this.totalRedeemed,
    required this.pointsToNextTier,
    required this.tier,
    this.membershipType,
    this.membershipStatus,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    int points = json['points'] ?? 0;
    int totalEarned = json['total_earned'] ?? points;
    int totalRedeemed = json['total_redeemed'] ?? 0;
    int pointsToNextTier = json['points_to_next'] ?? (points >= 3000 ? 0 : 3000 - points);
    String tier = json['tier'] ?? (points >= 3000 ? 'Platinum' : points >= 1000 ? 'Gold' : 'Silver');
    
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      photo: json['photo'],
      points: points,
      totalEarned: totalEarned,
      totalRedeemed: totalRedeemed,
      pointsToNextTier: pointsToNextTier,
      tier: tier,
      membershipType: json['membership_type'],
      membershipStatus: json['membership_status'],
    );
  }
  
  int get redeemedPoints => totalEarned - points;
}
