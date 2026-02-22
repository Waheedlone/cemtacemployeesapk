class InternalRequisition {
  final int id;
  final String requestNo;
  final int requestedById;
  final String requestedByName;
  final String department;
  final String requestDate;
  final String priority;
  final String status;
  final String? remarks;
  final String? approvedByName;
  final String? approvedAt;
  final String createdAt;
  final List<RequisitionItem> items;

  InternalRequisition({
    required this.id,
    required this.requestNo,
    required this.requestedById,
    required this.requestedByName,
    required this.department,
    required this.requestDate,
    required this.priority,
    required this.status,
    this.remarks,
    this.approvedByName,
    this.approvedAt,
    required this.createdAt,
    this.items = const [],
  });

  factory InternalRequisition.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List?;
    List<RequisitionItem> items = itemsList != null
        ? itemsList.map((i) => RequisitionItem.fromJson(i)).toList()
        : [];

    return InternalRequisition(
      id: json['id'] ?? 0,
      requestNo: json['request_no'] ?? '',
      requestedById: json['requested_by_id'] ?? 0,
      requestedByName: json['requested_by_name'] ?? '',
      department: json['department'] ?? '',
      requestDate: json['request_date'] ?? '',
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      remarks: json['remarks'],
      approvedByName: json['approved_by_name'],
      approvedAt: json['approved_at'],
      createdAt: json['created_at'] ?? '',
      items: items,
    );
  }
}

class RequisitionItem {
  final int itemId;
  final String itemName;
  final int quantity;
  final String unit;

  RequisitionItem({
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.unit,
  });

  factory RequisitionItem.fromJson(Map<String, dynamic> json) {
    return RequisitionItem(
      itemId: json['item_id'] ?? 0,
      itemName: json['item_name'] ?? '',
      quantity: json['quantity'] ?? 0,
      unit: json['unit'] ?? '',
    );
  }
}
