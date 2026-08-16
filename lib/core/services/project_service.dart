import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project_model.dart';

class ProjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream projects for a specific company or all strictly from Firestore
  Stream<List<ProjectModel>> getProjects({String? companyId}) {
    Query query = _firestore.collection('projects');
    if (companyId != null && companyId.isNotEmpty) {
      query = query.where('companyId', isEqualTo: companyId);
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ProjectModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  // Add or edit project (Constructor API action)
  Future<ProjectModel> addOrUpdateProject(ProjectModel project) async {
    if (project.id.isEmpty) {
      DocumentReference docRef = await _firestore.collection('projects').add(project.toMap());
      await docRef.update({'id': docRef.id});
      return ProjectModel.fromMap({...project.toMap(), 'id': docRef.id}, docRef.id);
    } else {
      await _firestore.collection('projects').doc(project.id).set(project.toMap(), SetOptions(merge: true));
      return project;
    }
  }

  // Delete project
  Future<void> deleteProject(String projectId) async {
    await _firestore.collection('projects').doc(projectId).delete();
  }
}
