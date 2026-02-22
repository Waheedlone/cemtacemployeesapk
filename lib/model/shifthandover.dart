class ShiftHandover {
  final int id;
  final String handoverDate;
  final String summary;
  final String? pendingTasks;
  final String? criticalIssues;
  final String? remarks;
  final int? handoverToUserId;
  final String? handoverToName;
  final String createdAt;

  ShiftHandover({
    required this.id,
    required this.handoverDate,
    required this.summary,
    this.pendingTasks,
    this.criticalIssues,
    this.remarks,
    this.handoverToUserId,
    this.handoverToName,
    required this.createdAt,
  });

  factory ShiftHandover.fromJson(Map<String, dynamic> json) {
    return ShiftHandover(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      handoverDate: json['handover_date'] ?? "",
      summary: json['summary'] ?? "",
      pendingTasks: json['pending_tasks'],
      criticalIssues: json['critical_issues'],
      remarks: json['remarks'],
      handoverToUserId: json['handover_to_user_id'] is int
          ? json['handover_to_user_id']
          : int.tryParse(json['handover_to_user_id']?.toString() ?? ""),
      handoverToName: json['handover_to_name'],
      createdAt: json['created_at'] ?? "",
    );
  }
}

class HandoverEmployee {
  final int id;
  final String name;

  HandoverEmployee({required this.id, required this.name});

  factory HandoverEmployee.fromJson(Map<String, dynamic> json) {
    return HandoverEmployee(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? "",
    );
  }
}
