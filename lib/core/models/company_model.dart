class CompanyModel {
  final String id;
  final String uid;
  final String name;
  final String specialty;
  final String location;
  final double rating;
  final int reviewCount;
  final String logoUrl;
  final String bannerUrl;
  final String description;
  final String phone;
  final String email;
  final List<String> services;
  final bool isVerified;

  CompanyModel({
    required this.id,
    required this.uid,
    required this.name,
    required this.specialty,
    required this.location,
    this.rating = 5.0,
    this.reviewCount = 0,
    this.logoUrl = '',
    this.bannerUrl = '',
    this.description = '',
    this.phone = '',
    this.email = '',
    this.services = const [],
    this.isVerified = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'specialty': specialty,
      'location': location,
      'rating': rating,
      'reviewCount': reviewCount,
      'logoUrl': logoUrl,
      'bannerUrl': bannerUrl,
      'description': description,
      'phone': phone,
      'email': email,
      'services': services,
      'isVerified': isVerified,
    };
  }

  factory CompanyModel.fromMap(Map<String, dynamic> map, String docId) {
    return CompanyModel(
      id: docId,
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      specialty: map['specialty'] ?? 'General Construction',
      location: map['location'] ?? 'Kochi, Kerala',
      rating: (map['rating'] ?? 5.0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      logoUrl: map['logoUrl'] ?? '',
      bannerUrl: map['bannerUrl'] ?? '',
      description: map['description'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      services: List<String>.from(map['services'] ?? []),
      isVerified: map['isVerified'] ?? true,
    );
  }
}
