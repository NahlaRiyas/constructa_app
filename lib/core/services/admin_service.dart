import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/company_model.dart';
import '../models/booking_model.dart';
import '../models/review_model.dart';
import '../models/house_plan_model.dart';
import '../models/project_model.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ---------------------------------------------------------------------------
  // STREAM ALL COLLECTIONS
  // ---------------------------------------------------------------------------

  Stream<List<UserModel>> getAllUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
    });
  }

  Stream<List<CompanyModel>> getAllCompanies() {
    return _firestore.collection('companies').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CompanyModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  Stream<List<BookingModel>> getAllBookings() {
    return _firestore.collection('bookings').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => BookingModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  Stream<List<ReviewModel>> getAllReviews() {
    return _firestore.collection('reviews').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ReviewModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  Stream<List<HousePlanModel>> getAllHousePlans() {
    return _firestore.collection('house_plans').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => HousePlanModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  Stream<List<ProjectModel>> getAllProjects() {
    return _firestore.collection('projects').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ProjectModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  // ---------------------------------------------------------------------------
  // DELETE OPERATIONS (Firestore only)
  // ---------------------------------------------------------------------------

  Future<void> deleteUser(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }

  Future<void> deleteCompany(String companyId) async {
    await _firestore.collection('companies').doc(companyId).delete();
  }

  Future<void> deleteBooking(String bookingId) async {
    await _firestore.collection('bookings').doc(bookingId).delete();
  }

  Future<void> deleteReview(String reviewId) async {
    await _firestore.collection('reviews').doc(reviewId).delete();
  }

  Future<void> deleteHousePlan(String planId) async {
    await _firestore.collection('house_plans').doc(planId).delete();
  }

  Future<void> deleteProject(String projectId) async {
    await _firestore.collection('projects').doc(projectId).delete();
  }

  // ---------------------------------------------------------------------------
  // COMPANY VERIFICATION
  // ---------------------------------------------------------------------------

  Future<void> verifyCompany(String companyId, bool isVerified) async {
    await _firestore.collection('companies').doc(companyId).update({'isVerified': isVerified});
  }
}
