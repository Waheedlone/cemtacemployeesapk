class Overtime {
  final int id;
  final int employeeId;
  final String employeeName;
  final int month;
  final int year;
  final double otHours;
  final double otRate;
  final double otAmount;
  final String status;
  final String? remarks;
  final String? approvedAt;
  final String createdAt;

  Overtime({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.month,
    required this.year,
    required this.otHours,
    required this.otRate,
    required this.otAmount,
    required this.status,
    this.remarks,
    this.approvedAt,
    required this.createdAt,
  });

  factory Overtime.fromJson(Map<String, dynamic> json) {
    return Overtime(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      employeeId: json['employee_id'] is int ? json['employee_id'] : int.tryParse(json['employee_id'].toString()) ?? 0,
      employeeName: json['employee_name'] ?? "",
      month: json['month'] is int ? json['month'] : int.tryParse(json['month'].toString()) ?? 0,
      year: json['year'] is int ? json['year'] : int.tryParse(json['year'].toString()) ?? 0,
      otHours: json['ot_hours'] is num ? (json['ot_hours'] as num).toDouble() : double.tryParse(json['ot_hours'].toString()) ?? 0.0,
      otRate: json['ot_rate'] is num ? (json['ot_rate'] as num).toDouble() : double.tryParse(json['ot_rate'].toString()) ?? 0.0,
      otAmount: json['ot_amount'] is num ? (json['ot_amount'] as num).toDouble() : double.tryParse(json['ot_amount'].toString()) ?? 0.0,
      status: json['status'] ?? "",
      remarks: json['remarks'],
      approvedAt: json['approved_at'],
      createdAt: json['created_at'] ?? "",
    );
  }
}
