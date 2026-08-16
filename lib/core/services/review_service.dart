import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream reviews for a company strictly from Firestore
  Stream<List<ReviewModel>> getCompanyReviews(String companyId) {
    if (companyId.isEmpty) {
      return _firestore.collection('reviews').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => ReviewModel.fromMap(doc.data(), doc.id)).toList();
      });
    }
    return _firestore
        .collection('reviews')
        .where('companyId', isEqualTo: companyId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ReviewModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  // Add review (Customer API action)
  Future<ReviewModel> addReview(ReviewModel review) async {
    DocumentReference docRef = await _firestore.collection('reviews').add(review.toMap());
    await docRef.update({'id': docRef.id});
    return ReviewModel.fromMap({...review.toMap(), 'id': docRef.id}, docRef.id);
  }

  // Add constructor response to review (Constructor API action)
  Future<void> respondToReview(String reviewId, String responseText) async {
    await _firestore.collection('reviews').doc(reviewId).update({
      'response': responseText,
      'responseDate': DateTime.now().toString().split(' ')[0],
    });
  }
}
