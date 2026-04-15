class NotifiactionDomain {
  NotifiactionDomain({
    required this.id,
    required this.notificationTitle,
    required this.description,
    required this.notificationPublishedDate,
    required this.type,
    this.notificationForId,
  });

  factory NotifiactionDomain.fromJson(dynamic json) {
    return NotifiactionDomain(
      id: json['id'] ?? 0,
      notificationTitle: json['notification_title']?.toString() ?? "",
      description: json['description']?.toString() ?? "",
      notificationPublishedDate: json['notification_published_date']?.toString() ?? "",
      type: json['type']?.toString() ?? "",
      notificationForId: json['notification_for_id']?.toString() ?? "",
    );
  }

  int id;
  String notificationTitle;
  String description;
  String notificationPublishedDate;
  String type;
  String? notificationForId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['notification_title'] = notificationTitle;
    map['description'] = description;
    map['notification_published_date'] = notificationPublishedDate;
    map['type'] = type;
    map['notification_for_id'] = notificationForId;
    return map;
  }
}
