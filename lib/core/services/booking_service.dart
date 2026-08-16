import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream bookings for a specific customer user strictly from Firestore
  Stream<List<BookingModel>> getUserBookings(String userId) {
    if (userId.isEmpty) return Stream.value([]);
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => BookingModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  // Stream bookings for a specific constructor company strictly from Firestore
  Stream<List<BookingModel>> getCompanyBookings(String companyId) {
    if (companyId.isEmpty) return Stream.value([]);
    return _firestore
        .collection('bookings')
        .where('companyId', isEqualTo: companyId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => BookingModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  // Create new booking (User API action)
  Future<BookingModel> createBooking(BookingModel booking) async {
    DocumentReference docRef = await _firestore.collection('bookings').add(booking.toMap());
    await docRef.update({'id': docRef.id});
    return BookingModel.fromMap({...booking.toMap(), 'id': docRef.id}, docRef.id);
  }

  // Update booking status (Constructor API action: Pending -> Confirmed / Completed / Cancelled)
  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _firestore.collection('bookings').doc(bookingId).update({'status': status});
  }
}
