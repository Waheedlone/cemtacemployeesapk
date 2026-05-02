class MaterialItem {
  final int id;
  final String name;
  final String code;
  final String unit;
  final int? categoryId;
  final String? categoryName;

  MaterialItem({
    required this.id,
    required this.name,
    required this.code,
    required this.unit,
    this.categoryId,
    this.categoryName,
  });

  factory MaterialItem.fromJson(Map<String, dynamic> json) {
    return MaterialItem(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      unit: json['unit'] ?? '',
      categoryId: json['category_id'] is int ? json['category_id'] : int.tryParse(json['category_id']?.toString() ?? ''),
      categoryName: json['category'] != null ? json['category']['name'] : null,
    );
  }
}
