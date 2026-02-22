import 'package:cnattendance/model/notification.dart' as model;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationDetailScreen extends StatelessWidget {
  final model.Notification notification;

  const NotificationDetailScreen({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notification Detail',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFED1C24).withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                DateFormat("MMMM d, yyyy").format(notification.date),
                style: const TextStyle(
                  color: Color(0xFFED1C24),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              notification.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            Divider(color: Colors.grey.withOpacity(0.2), thickness: 1),
            const SizedBox(height: 16),
            Text(
              notification.description,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
