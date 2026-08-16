class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String role; // 'customer' or 'company'
  final String profileImageUrl;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.role,
    this.profileImageUrl = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'role': role,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      role: map['role'] ?? 'customer',
      profileImageUrl: map['profileImageUrl'] ?? '',
    );
  }
}
