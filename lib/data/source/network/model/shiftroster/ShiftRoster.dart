class ShiftRosterResponse {
  final bool status;
  final String message;
  final List<ShiftRosterData> data;

  ShiftRosterResponse({required this.status, required this.message, required this.data});

  factory ShiftRosterResponse.fromJson(Map<String, dynamic> json) {
    final dataMap = json['data'] as Map<String, dynamic>?;
    final rosterList = dataMap?['roster'] as List?;
    return ShiftRosterResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? "",
      data: rosterList?.map((e) => ShiftRosterData.fromJson(e)).toList() ?? [],
    );
  }
}

class ShiftRosterData {
  final String date;
  final String day;
  final String shiftName;
  final String? openingTime;
  final String? closingTime;
  final bool isWeeklyOff;
  final bool isCustomAssignment;

  ShiftRosterData({
    required this.date,
    required this.day,
    required this.shiftName,
    this.openingTime,
    this.closingTime,
    required this.isWeeklyOff,
    required this.isCustomAssignment,
  });

  factory ShiftRosterData.fromJson(Map<String, dynamic> json) {
    return ShiftRosterData(
      date: json['date'] ?? "",
      day: json['day'] ?? "",
      shiftName: json['shift_name'] ?? "",
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
      isWeeklyOff: json['is_weekly_off'] ?? false,
      isCustomAssignment: json['is_custom_assignment'] ?? false,
    );
  }
}
