import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/company_model.dart';

/// ============================================================================
/// FILE: company_service.dart
/// MODULE: Core Services (Company Data Service Layer)
/// PROJECT: Constructa App - College Project
/// DESCRIPTION:
///   Provides Firestore database operations for construction companies.
///   Supports profile creation during company registration, querying verified
///   companies, and fetching company details by unique document ID.
/// ============================================================================

/// Service class handling Firestore operations for construction companies (`companies` collection).
class CompanyService {
  /// Instance of Cloud Firestore database service.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Returns a real-time [Stream] of all registered construction companies from Firestore.
  Stream<List<CompanyModel>> getCompanies() {
    return _firestore.collection('companies').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CompanyModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  /// Fetches a single company profile by its document [id] from Firestore.
  ///
  /// Returns a [CompanyModel] if found, or `null` if the document does not exist.
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

  /// Saves or merges a construction company profile document into Firestore.
  ///
  /// Used during company user registration and profile updates.
  /// Merges existing fields using [SetOptions(merge: true)].
  Future<CompanyModel> saveCompanyProfile(CompanyModel company) async {
    final docId = company.id.isEmpty ? company.uid : company.id;
    await _firestore.collection('companies').doc(docId).set(
      company.toMap(),
      SetOptions(merge: true),
    );
    return company;
  }
}

