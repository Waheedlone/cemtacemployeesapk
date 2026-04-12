class ShiftRosterResponse {
  final bool status;
  final String message;
  final List<ShiftRosterData> data;

  ShiftRosterResponse({required this.status, required this.message, required this.data});

  factory ShiftRosterResponse.fromJson(Map<String, dynamic> json) {
    return ShiftRosterResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? "",
      data: (json['data'] as List?)?.map((e) => ShiftRosterData.fromJson(e)).toList() ?? [],
    );
  }
}

class ShiftRosterData {
  final String date;
  final String shiftName;
  final String startTime;
  final String endTime;
  final bool isWeeklyOff;

  ShiftRosterData({
    required this.date,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.isWeeklyOff,
  });

  factory ShiftRosterData.fromJson(Map<String, dynamic> json) {
    return ShiftRosterData(
      date: json['date'] ?? "",
      shiftName: json['shift_name'] ?? "",
      startTime: json['start_time'] ?? "",
      endTime: json['end_time'] ?? "",
      isWeeklyOff: json['is_weekly_off'] ?? false,
    );
  }
}
