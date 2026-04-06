import 'package:cnattendance/provider/noticeprovider.dart';
import 'package:cnattendance/widget/notification/notificationcard.dart';
import 'package:cnattendance/widget/shimmer_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoticeList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NoticeListState();
}

class NoticeListState extends State<NoticeList> {
  late ScrollController _controller;
  var isLoading = false;

  void _loadMore() async{
    if(!isLoading) {
      if (_controller.position.maxScrollExtent == _controller.position.pixels) {
        isLoading = true;
        await Provider.of<NoticeProvider>(context, listen: false)
            .getNotice();
        isLoading = false;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noticeProvider = Provider.of<NoticeProvider>(context);
    final items = noticeProvider.notificationList;

    if (noticeProvider.isLoading && items.isEmpty) {
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
              "No notices yet",
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _controller,
        itemCount: items.length,
        itemBuilder: (ctx, index) {
          return NotificationCard(notification: items[index]);
        });
  }
}
