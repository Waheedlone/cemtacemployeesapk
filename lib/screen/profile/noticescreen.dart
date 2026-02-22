import 'package:cnattendance/provider/noticeprovider.dart';
import 'package:cnattendance/widget/notice/noticelist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoticeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NoticeProvider(),
      child: Notice(),
    );
  }
}

class Notice extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NoticeState();
}

class NoticeState extends State<Notice> {
  var initial = true;

  Future<String> getNotification() async {
    await Provider.of<NoticeProvider>(context, listen: false).getNotice();

    return "Loaded";
  }

  @override
  void didChangeDependencies() {
    if (initial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getNotification();
      });
      initial = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text('Notices', style: TextStyle(color: Colors.black)),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            onRefresh: () {
              Provider.of<NoticeProvider>(context, listen: false).page = 1;
              return getNotification();
            },
            child: NoticeList()));
  }
}
