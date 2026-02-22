class GatePass {
  final int id;
  final String reason;
  final String time;
  final String status;
  final String? gpNumber;
  final String? statusLabel;
  final String? remarks;
  final String? approvedAt;
  final String? approvedByName;
  final String? departmentName;

  GatePass({
    required this.id,
    required this.reason,
    required this.time,
    required this.status,
    this.gpNumber,
    this.statusLabel,
    this.remarks,
    this.approvedAt,
    this.approvedByName,
    this.departmentName,
  });

  factory GatePass.fromJson(Map<String, dynamic> json) {
    return GatePass(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? "0") ?? 0,
      reason: (json['purpose'] ?? json['reason'] ?? "").toString(),
      time: (json['time_out'] ?? json['time'] ?? "").toString(),
      status: (json['status'] ?? "").toString(),
      gpNumber: json['gp_number']?.toString(),
      statusLabel: json['status_label']?.toString(),
      remarks: json['remarks']?.toString(),
      approvedAt: json['approved_at']?.toString(),
      approvedByName: json['approved_by_name']?.toString(),
      departmentName: json['department_name']?.toString(),
    );
  }
}
