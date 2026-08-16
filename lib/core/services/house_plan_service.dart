import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/house_plan_model.dart';

class HousePlanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream all house plans strictly from Firestore
  Stream<List<HousePlanModel>> getHousePlans() {
    return _firestore.collection('house_plans').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => HousePlanModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  // Stream house plans for a specific company strictly from Firestore
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

  // Add or edit house plan (Constructor API action)
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

  // Delete house plan
  Future<void> deleteHousePlan(String planId) async {
    await _firestore.collection('house_plans').doc(planId).delete();
  }
}
