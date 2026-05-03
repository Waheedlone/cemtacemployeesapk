class PurchaseRequisition {
  final int id;
  final String prNumber;
  final String requisitionDate;
  final String status;
  final String currentLevel;
  final int requestedById;
  final String requestedBy;
  final String? warehouse;
  final String? department;
  final String? purpose;
  final String? remarks;
  final List<PRItem> items;
  final List<PRHistory> history;
  final bool canApprove;

  PurchaseRequisition({
    required this.id,
    required this.prNumber,
    required this.requisitionDate,
    required this.status,
    required this.currentLevel,
    required this.requestedById,
    required this.requestedBy,
    this.warehouse,
    this.department,
    this.purpose,
    this.remarks,
    this.items = const [],
    this.history = const [],
    this.canApprove = false,
  });

  factory PurchaseRequisition.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List?;
    List<PRItem> items = itemsList != null
        ? itemsList.map((i) => PRItem.fromJson(i)).toList()
        : [];

    var historyList = json['history'] as List?;
    List<PRHistory> history = historyList != null
        ? historyList.map((i) => PRHistory.fromJson(i)).toList()
        : [];

    return PurchaseRequisition(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      prNumber: json['pr_number']?.toString() ?? '',
      requisitionDate: json['requisition_date']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      currentLevel: json['current_level']?.toString() ?? '',
      requestedById: json['requested_by_id'] is int ? json['requested_by_id'] : int.tryParse(json['requested_by_id']?.toString() ?? '0') ?? 0,
      requestedBy: json['requested_by']?.toString() ?? '',
      warehouse: json['warehouse']?.toString(),
      department: json['department']?.toString(),
      purpose: json['purpose']?.toString(),
      remarks: json['remarks']?.toString(),
      items: items,
      history: history,
      canApprove: json['can_approve'] == true || json['can_approve'] == 1,
    );
  }
}

class PRItem {
  final int id;
  final String materialName;
  final String materialCode;
  final double quantity;
  final String unit;
  final String? remarks;

  PRItem({
    required this.id,
    required this.materialName,
    required this.materialCode,
    required this.quantity,
    required this.unit,
    this.remarks,
  });

  factory PRItem.fromJson(Map<String, dynamic> json) {
    return PRItem(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      materialName: json['material_name'] ?? '',
      materialCode: json['material_code'] ?? '',
      quantity: json['quantity'] is num ? (json['quantity'] as num).toDouble() : (double.tryParse(json['quantity']?.toString() ?? '0') ?? 0.0),
      unit: json['unit'] ?? '',
      remarks: json['remarks'],
    );
  }
}

class PRHistory {
  final String actionBy;
  final String level;
  final String action;
  final String? remarks;
  final String date;

  PRHistory({
    required this.actionBy,
    required this.level,
    required this.action,
    this.remarks,
    required this.date,
  });

  factory PRHistory.fromJson(Map<String, dynamic> json) {
    return PRHistory(
      actionBy: json['action_by'] ?? '',
      level: json['level'] ?? '',
      action: json['action'] ?? '',
      remarks: json['remarks'],
      date: json['date'] ?? '',
    );
  }
}
