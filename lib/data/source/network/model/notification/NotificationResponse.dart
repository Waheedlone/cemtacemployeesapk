import 'package:cnattendance/data/source/network/model/notification/NotifiactionDomain.dart';

class NotificationResponse {
  bool status;
  String message;
  List<NotifiactionDomain> data;

  NotificationResponse(
      {required this.status, required this.message, required this.data});

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? "",
      data: json['data'] != null
          ? List<NotifiactionDomain>.from(
              json['data'].map((x) => NotifiactionDomain.fromJson(x)))
          : [],
    );
  }
}
