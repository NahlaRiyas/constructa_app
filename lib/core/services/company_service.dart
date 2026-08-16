import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/company_model.dart';

class CompanyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream all verified construction companies strictly from Firestore
  Stream<List<CompanyModel>> getCompanies() {
    return _firestore.collection('companies').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CompanyModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  // Get single company by ID
  Future<CompanyModel?> getCompanyById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('companies').doc(id).get();
      if (doc.exists && doc.data() != null) {
        return CompanyModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      print("Error fetching company: $e");
    }
    return null;
  }

  // Save or update company profile (Constructor API action)
  Future<CompanyModel> saveCompanyProfile(CompanyModel company) async {
    final docId = company.id.isEmpty ? company.uid : company.id;
    await _firestore.collection('companies').doc(docId).set(
      company.toMap(),
      SetOptions(merge: true),
    );
    return company;
  }
}
