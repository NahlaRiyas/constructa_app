class ProjectModel {
  final String id;
  final String companyId;
  final String companyName;
  final String title;
  final String category; // 'Construction', 'Renovation', 'Interior'
  final String location;
  final String description;
  final List<String> imageUrls;
  final String completionDate;

  ProjectModel({
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.title,
    required this.category,
    required this.location,
    this.description = '',
    this.imageUrls = const [],
    this.completionDate = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companyId': companyId,
      'companyName': companyName,
      'title': title,
      'category': category,
      'location': location,
      'description': description,
      'imageUrls': imageUrls,
      'completionDate': completionDate,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProjectModel(
      id: docId,
      companyId: map['companyId'] ?? '',
      companyName: map['companyName'] ?? '',
      title: map['title'] ?? '',
      category: map['category'] ?? 'Construction',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      completionDate: map['completionDate'] ?? '',
    );
  }
}
