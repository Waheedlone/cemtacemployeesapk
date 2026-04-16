class OfficeTime {
  OfficeTime({
    required this.id,
    required this.startTime,
    required this.endTime,
    this.shiftName = "Schedule",
  });

  factory OfficeTime.fromJson(dynamic json) {
    if (json == null) return OfficeTime(id: 0, startTime: "", endTime: "");
    return OfficeTime(
        id: json['id'] ?? 0,
        startTime: json['start_time']?.toString() ?? "",
        endTime: json['end_time']?.toString() ?? "",
        shiftName: json['shift']?.toString() ?? json['shift_name']?.toString() ?? json['name']?.toString() ?? "Schedule"
    );
  }

  int id;
  String startTime;
  String endTime;
  String shiftName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['start_time'] = startTime;
    map['end_time'] = endTime;
    map['shift_name'] = shiftName;
    return map;
  }
}
