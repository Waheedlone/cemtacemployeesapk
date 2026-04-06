import 'package:cnattendance/provider/notificationprovider.dart';
import 'package:cnattendance/provider/noticeprovider.dart';
import 'package:cnattendance/widget/notification/notificationlist.dart';
import 'package:cnattendance/widget/notice/noticelist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoticeProvider()),
      ],
      child: _NotificationWidget(),
    );
  }
}

class _NotificationWidget extends StatefulWidget {
  @override
  State<_NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<_NotificationWidget> {
  bool _initial = true;

  Future<void> _fetchAll() async {
    final notifProvider = Provider.of<NotificationProvider>(context, listen: false);
    final noticeProvider = Provider.of<NoticeProvider>(context, listen: false);

    notifProvider.page = 1;
    noticeProvider.page = 1;

    await Future.wait([
      notifProvider.getNotification(),
      noticeProvider.getNotice(),
    ]);

    // Update unread counts
    notifProvider.fetchUnreadCount();
  }

  @override
  void didChangeDependencies() {
    if (_initial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchAll();
      });
      _initial = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Notifications & Notices',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          bottom: TabBar(
            labelColor: HexColor('#ED1C24'),
            unselectedLabelColor: Colors.grey,
            indicatorColor: HexColor('#ED1C24'),
            tabs: const [
              Tab(text: 'Notifications'),
              Tab(text: 'Notices'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RefreshIndicator(
              onRefresh: _fetchAll,
              child: NotificationList(),
            ),
            RefreshIndicator(
              onRefresh: _fetchAll,
              child: NoticeList(),
            ),
          ],
        ),
      ),
    );
  }
}

