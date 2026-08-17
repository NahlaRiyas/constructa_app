import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/house_plan_model.dart';

/// ============================================================================
/// FILE: house_plan_service.dart
/// MODULE: Core Services (House Plan Data Service Layer)
/// PROJECT: Constructa App - College Project
/// DESCRIPTION:
///   Provides Firestore database CRUD operations for 2D/3D house plans.
///   Supports streaming all public house plans, querying plans by constructor
///   company ID, adding/updating plans, and deleting plan listings.
/// ============================================================================

/// Service class handling Firestore operations for house architectural plans (`house_plans` collection).
class HousePlanService {
  /// Instance of Cloud Firestore database service.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Returns a real-time [Stream] of all public house plans from Firestore.
  Stream<List<HousePlanModel>> getHousePlans() {
    return _firestore.collection('house_plans').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => HousePlanModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  /// Returns a real-time [Stream] of house plans created by a specific company [companyId].
  ///
  /// If [companyId] is empty, falls back to returning all house plans.
  Stream<List<HousePlanModel>> getCompanyHousePlans(String companyId) {
    if (companyId.isEmpty) return getHousePlans();
    return _firestore
        .collection('house_plans')
        .where('companyId', isEqualTo: companyId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => HousePlanModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  /// Adds a new house plan or updates an existing plan in Firestore.
  ///
  /// Parameters:
  /// - [plan]: The [HousePlanModel] object to create or update.
  ///
  /// Returns:
  ///   The saved [HousePlanModel] with updated Firestore document ID.
  Future<HousePlanModel> addOrUpdateHousePlan(HousePlanModel plan) async {
    if (plan.id.isEmpty) {
      DocumentReference docRef = await _firestore.collection('house_plans').add(plan.toMap());
      await docRef.update({'id': docRef.id});
      final updatedMap = {...plan.toMap(), 'id': docRef.id};
      return HousePlanModel.fromMap(updatedMap, docRef.id);
    } else {
      await _firestore.collection('house_plans').doc(plan.id).set(plan.toMap(), SetOptions(merge: true));
      return plan;
    }
  }

  /// Deletes a house plan document from Firestore matching [planId].
  Future<void> deleteHousePlan(String planId) async {
    await _firestore.collection('house_plans').doc(planId).delete();
  }
}

