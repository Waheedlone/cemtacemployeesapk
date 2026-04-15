class Notification {
  int id;
  String title;
  String description;
  String month;
  int day;
  DateTime date;
  bool isMeeting;
  String type;
  String? notificationForId;

  Notification(
      {required this.id,
      required this.title,
      required this.description,
      required this.month,
      required this.day,
      required this.date,
      this.isMeeting = false,
      this.type = "",
      this.notificationForId});
}
