import 'package:cnattendance/provider/notificationprovider.dart';
import 'package:cnattendance/widget/notification/notificationcard.dart';
import 'package:cnattendance/widget/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NotificationListState();
}

class NotificationListState extends State<NotificationList> {
  late ScrollController _controller;
  bool _isLoadingMore = false;

  void _loadMore() async {
    if (!_isLoadingMore) {
      if (_controller.position.maxScrollExtent == _controller.position.pixels) {
        setState(() => _isLoadingMore = true);
        await Provider.of<NotificationProvider>(context, listen: false)
            .getNotification();
        if (mounted) setState(() => _isLoadingMore = false);
      }
    }
  }

  @override
  void initState() {
    _controller = ScrollController()..addListener(_loadMore);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);
    final items = provider.notificationList;

    if (provider.isLoading && items.isEmpty) {
      return ShimmerLoading(child: ShimmerLoading.buildListShimmer());
    }

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off_outlined,
                size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              "No notifications yet",
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _controller,
      itemCount: items.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (ctx, index) {
        if (index == items.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return NotificationCard(notification: items[index]);
      },
    );
  }
}
