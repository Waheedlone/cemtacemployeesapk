import 'package:cnattendance/provider/notificationprovider.dart';
import 'package:cnattendance/widget/notification/notificationlist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _NotificationWidget();
  }
}

class _NotificationWidget extends StatefulWidget {
  @override
  State<_NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<_NotificationWidget> {
  bool _initial = true;

  Future<void> _fetchNotifications() async {
    final provider =
        Provider.of<NotificationProvider>(context, listen: false);
    provider.page = 1;
    await provider.getNotification();
  }

  @override
  void didChangeDependencies() {
    if (_initial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchNotifications();
      });
      _initial = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchNotifications,
        child: NotificationList(),
      ),
    );
  }
}
