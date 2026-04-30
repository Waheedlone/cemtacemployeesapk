class LeaveType {
  LeaveType({
    required this.leaveTypeId,
    required this.leaveTypeName,
    required this.leaveTypeSlug,
    required this.leaveTypeStatus,
    required this.earlyExit,
    required this.totalLeaveAllocated,
    required this.leaveTaken,
  });

  factory LeaveType.fromJson(dynamic json) {
    return LeaveType(
        leaveTypeId: json['leave_type_id']?.toString() ?? "0",
        leaveTypeName: json['leave_type_name']?.toString() ?? "",
        leaveTypeSlug: json['leave_type_slug ']?.toString() ?? json['leave_type_slug']?.toString() ?? "",
        leaveTypeStatus: (json['leave_type_status'] is bool)
            ? json['leave_type_status']
            : (json['leave_type_status'] == 1 || json['leave_type_status'] == '1' || json['leave_type_status'] == true || json['leave_type_status'] == 'true'),
        earlyExit: (json['early_exit'] is bool)
            ? json['early_exit']
            : (json['early_exit'] == 1 || json['early_exit'] == '1' || json['early_exit'] == true || json['early_exit'] == 'true'),
        totalLeaveAllocated: json['total_leave_allocated']?.toString() ?? "0",
        leaveTaken: (double.tryParse(json['leave_taken']?.toString() ?? "0") ?? 0.0).toInt());
  }

  List<LeaveType> getList(List<dynamic> leaveList){
    List<LeaveType> list = List.empty();

    for(var item in leaveList){
      list.add(LeaveType.fromJson(item));
    }

    return list;
  }

  String leaveTypeId;
  String leaveTypeName;
  String leaveTypeSlug;
  bool leaveTypeStatus;
  bool earlyExit;
  String totalLeaveAllocated;
  int leaveTaken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['leave_type_id'] = leaveTypeId;
    map['leave_type_name'] = leaveTypeName;
    map['leave_type_slug '] = leaveTypeSlug;
    map['leave_type_status'] = leaveTypeStatus;
    map['early_exit'] = earlyExit;
    map['total_leave_allocated'] = totalLeaveAllocated;
    map['leave_taken'] = leaveTaken;
    return map;
  }
}
