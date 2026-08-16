class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String companyId;
  final String companyName;
  final double rating;
  final String comment;
  final String createdAt;
  final String response; // Constructor reply
  final String responseDate;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar = '',
    required this.companyId,
    required this.companyName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.response = '',
    this.responseDate = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'companyId': companyId,
      'companyName': companyName,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
      'response': response,
      'responseDate': responseDate,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map, String docId) {
    return ReviewModel(
      id: docId,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userAvatar: map['userAvatar'] ?? '',
      companyId: map['companyId'] ?? '',
      companyName: map['companyName'] ?? '',
      rating: (map['rating'] ?? 5.0).toDouble(),
      comment: map['comment'] ?? '',
      createdAt: map['createdAt'] ?? '',
      response: map['response'] ?? '',
      responseDate: map['responseDate'] ?? '',
    );
  }
}
