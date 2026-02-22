import 'package:cnattendance/provider/notificationprovider.dart';
import 'package:cnattendance/widget/notification_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotificationProvider(),
      child: NotificationScreenContent(),
    );
  }
}

class NotificationScreenContent extends StatefulWidget {
  @override
  _NotificationScreenContentState createState() => _NotificationScreenContentState();
}

class _NotificationScreenContentState extends State<NotificationScreenContent> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNotifications();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _fetchMoreNotifications();
    }
  }

  Future<void> _fetchNotifications() async {
    try {
      Provider.of<NotificationProvider>(context, listen: false).page = 1;
      await Provider.of<NotificationProvider>(context, listen: false).getNotification();
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchMoreNotifications() async {
    if (_isFetchingMore) return;

    setState(() {
      _isFetchingMore = true;
    });

    try {
      await Provider.of<NotificationProvider>(context, listen: false).getNotification();
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchNotifications,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: provider.notificationList.length + (_isFetchingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == provider.notificationList.length) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final notification = provider.notificationList[index];
                  return NotificationRow(notification);
                },
              ),
            ),
    );
  }
}
