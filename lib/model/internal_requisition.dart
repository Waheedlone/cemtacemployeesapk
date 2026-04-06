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
  final String? specialRequestReason;
  final String? warehouseName;
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
    this.specialRequestReason,
    this.warehouseName,
    this.items = const [],
  });

  factory InternalRequisition.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List?;
    List<RequisitionItem> items = itemsList != null
        ? itemsList.map((i) => RequisitionItem.fromJson(i)).toList()
        : [];

    return InternalRequisition(
      id: json['id'] ?? 0,
      requestNo: json['ir_number'] ?? json['request_no'] ?? '',
      requestedById: json['requested_by_id'] ?? 0,
      requestedByName: json['section_head_name'] ?? json['requested_by_name'] ?? '',
      department: json['department_name'] ?? json['department'] ?? '',
      requestDate: json['requisition_date'] ?? json['request_date'] ?? '',
      priority: json['priority'] ?? json['type'] ?? '',
      status: json['status'] ?? '',
      remarks: json['remarks'],
      approvedByName: json['approved_by_name'],
      approvedAt: json['approved_at'],
      createdAt: json['created_at'] ?? '',
      specialRequestReason: json['special_request_reason'],
      warehouseName: json['warehouse_name'],
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
      itemId: json['id'] ?? json['item_id'] ?? 0,
      itemName: json['description'] ?? json['item_name'] ?? json['material_name'] ?? '',
      quantity: (json['quantity'] ?? 0).toInt(),
      unit: json['unit'] ?? '',
    );
  }
}
