class Substitution {
  final int id;
  final int employeeId;
  final String employeeName;
  final int substituteId;
  final String substituteName;
  final String dateFrom;
  final String dateTo;
  final String reason;
  final String status;
  final String? remarks;
  final String? approvedAt;
  final String? approvedByName;
  final String createdAt;

  Substitution({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.substituteId,
    required this.substituteName,
    required this.dateFrom,
    required this.dateTo,
    required this.reason,
    required this.status,
    this.remarks,
    this.approvedAt,
    this.approvedByName,
    required this.createdAt,
  });

  factory Substitution.fromJson(Map<String, dynamic> json) {
    return Substitution(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      employeeId: json['employee_id'] is int ? json['employee_id'] : int.tryParse(json['employee_id']?.toString() ?? "") ?? 0,
      employeeName: json['employee_name'] ?? "",
      substituteId: json['substitute_id'] is int ? json['substitute_id'] : int.tryParse(json['substitute_id']?.toString() ?? "") ?? 0,
      substituteName: json['substitute_name'] ?? "",
      dateFrom: json['date_from'] ?? "",
      dateTo: json['date_to'] ?? "",
      reason: json['reason'] ?? "",
      status: json['status'] ?? "pending",
      remarks: json['remarks'],
      approvedAt: json['approved_at'],
      approvedByName: json['approved_by_name'],
      createdAt: json['created_at'] ?? "",
    );
  }
}

class SubstitutionEmployee {
  final int id;
  final String name;

  SubstitutionEmployee({required this.id, required this.name});

  factory SubstitutionEmployee.fromJson(Map<String, dynamic> json) {
    return SubstitutionEmployee(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? "",
    );
  }
}
