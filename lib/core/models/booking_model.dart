class BookingModel {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final String companyId;
  final String companyName;
  final String planId;
  final String planTitle;
  final String bookingDate;
  final String timeSlot;
  final String status; // 'Pending', 'Confirmed', 'Completed', 'Cancelled'
  final String notes;
  final double estimatedCost;
  final String createdAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.companyId,
    required this.companyName,
    required this.planId,
    required this.planTitle,
    required this.bookingDate,
    required this.timeSlot,
    this.status = 'Pending',
    this.notes = '',
    this.estimatedCost = 0.0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'companyId': companyId,
      'companyName': companyName,
      'planId': planId,
      'planTitle': planTitle,
      'bookingDate': bookingDate,
      'timeSlot': timeSlot,
      'status': status,
      'notes': notes,
      'estimatedCost': estimatedCost,
      'createdAt': createdAt,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map, String docId) {
    return BookingModel(
      id: docId,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userPhone: map['userPhone'] ?? '',
      companyId: map['companyId'] ?? '',
      companyName: map['companyName'] ?? '',
      planId: map['planId'] ?? '',
      planTitle: map['planTitle'] ?? '',
      bookingDate: map['bookingDate'] ?? '',
      timeSlot: map['timeSlot'] ?? '',
      status: map['status'] ?? 'Pending',
      notes: map['notes'] ?? '',
      estimatedCost: (map['estimatedCost'] ?? 0.0).toDouble(),
      createdAt: map['createdAt'] ?? '',
    );
  }
}
