class HousePlanModel {
  final String id;
  final String companyId;
  final String companyName;
  final String title;
  final String bhk; // e.g. "3BHK"
  final int sqft; // e.g. 2400
  final double contractPrice; // e.g. 4500000
  final String description;
  final List<String> imageUrls;
  final String tag; // 'Bestseller', 'Trending', 'New'
  final List<String> features;

  HousePlanModel({
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.title,
    required this.bhk,
    required this.sqft,
    required this.contractPrice,
    this.description = '',
    this.imageUrls = const [],
    this.tag = '',
    this.features = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companyId': companyId,
      'companyName': companyName,
      'title': title,
      'bhk': bhk,
      'sqft': sqft,
      'contractPrice': contractPrice,
      'description': description,
      'imageUrls': imageUrls,
      'tag': tag,
      'features': features,
    };
  }

  factory HousePlanModel.fromMap(Map<String, dynamic> map, String docId) {
    return HousePlanModel(
      id: docId,
      companyId: map['companyId'] ?? '',
      companyName: map['companyName'] ?? '',
      title: map['title'] ?? '',
      bhk: map['bhk'] ?? '3BHK',
      sqft: map['sqft'] ?? 2000,
      contractPrice: (map['contractPrice'] ?? 0.0).toDouble(),
      description: map['description'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      tag: map['tag'] ?? '',
      features: List<String>.from(map['features'] ?? []),
    );
  }
}
