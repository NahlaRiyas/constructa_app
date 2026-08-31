import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream reviews for a specific target strictly from Firestore
  Stream<List<ReviewModel>> getReviews({String? companyId, String? targetId, String? targetType}) {
    Query query = _firestore.collection('reviews');

    if (companyId != null && companyId.isNotEmpty) {
      query = query.where('companyId', isEqualTo: companyId);
    }
    if (targetId != null && targetId.isNotEmpty) {
      query = query.where('targetId', isEqualTo: targetId);
    }
    if (targetType != null && targetType.isNotEmpty) {
      query = query.where('targetType', isEqualTo: targetType);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ReviewModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  // Legacy support for getCompanyReviews - now returns ALL reviews for the company
  Stream<List<ReviewModel>> getCompanyReviews(String companyId) {
    return getReviews(companyId: companyId);
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
