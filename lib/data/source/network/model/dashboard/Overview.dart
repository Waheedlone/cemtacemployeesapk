class Overview {
  Overview({
    required this.presentDays,
    required this.totalPaidLeaves,
    required this.totalHolidays,
    required this.totalPendingLeaves,
    required this.totalLeaveTaken,
    required this.total_assigned_projects,
    required this.total_pending_tasks,
    required this.total_gate_pass,
    required this.total_internal_requisitions,
    required this.total_substitutions,
    required this.total_shift_handovers,
    required this.total_overtimes,
  });

  factory Overview.fromJson(dynamic json) {
    return Overview(
        presentDays: json['present_days'] ?? 0,
        totalPaidLeaves: json['total_paid_leaves'] ?? 0,
        totalHolidays: json['total_holidays'] ?? 0,
        totalPendingLeaves: json['total_pending_leaves'] ?? 0,
        totalLeaveTaken: json['total_leave_taken'] ?? 0,
        total_assigned_projects: json['total_assigned_projects'] ?? 0,
        total_pending_tasks: json['total_pending_tasks'] ?? 0,
        total_gate_pass: json['total_gate_pass'] ?? 0,
        total_internal_requisitions: json['total_internal_requisitions'] ?? 0,
        total_substitutions: json['total_substitutions'] ?? 0,
        total_shift_handovers: json['total_shift_handovers'] ?? 0,
        total_overtimes: json['total_overtimes'] ?? 0);
  }

  int presentDays;
  int totalPaidLeaves;
  int totalHolidays;
  int totalPendingLeaves;
  int totalLeaveTaken;
  int total_assigned_projects;
  int total_pending_tasks;
  int total_gate_pass;
  int total_internal_requisitions;
  int total_substitutions;
  int total_shift_handovers;
  int total_overtimes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['present_days'] = presentDays;
    map['total_paid_leaves'] = totalPaidLeaves;
    map['total_holidays'] = totalHolidays;
    map['total_pending_leaves'] = totalPendingLeaves;
    map['total_leave_taken'] = totalLeaveTaken;
    map['total_gate_pass'] = total_gate_pass;
    map['total_internal_requisitions'] = total_internal_requisitions;
    map['total_substitutions'] = total_substitutions;
    map['total_shift_handovers'] = total_shift_handovers;
    map['total_overtimes'] = total_overtimes;
    return map;
  }
}
