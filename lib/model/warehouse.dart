class Warehouse {
  final int id;
  final String name;
  final int? branchId;
  final String? branchName;

  Warehouse({
    required this.id,
    required this.name,
    this.branchId,
    this.branchName,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      branchId: json['branch_id'] is int ? json['branch_id'] : int.tryParse(json['branch_id']?.toString() ?? ''),
      branchName: json['branch'] != null ? json['branch']['name'] : null,
    );
  }
}
