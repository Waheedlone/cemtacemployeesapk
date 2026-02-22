import 'package:cnattendance/provider/noticeprovider.dart';
import 'package:cnattendance/widget/notice_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoticeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NoticeProvider(),
      child: NoticeScreenContent(),
    );
  }
}

class NoticeScreenContent extends StatefulWidget {
  @override
  _NoticeScreenContentState createState() => _NoticeScreenContentState();
}

class _NoticeScreenContentState extends State<NoticeScreenContent> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNotices();
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
      _fetchMoreNotices();
    }
  }

  Future<void> _fetchNotices() async {
    try {
      Provider.of<NoticeProvider>(context, listen: false).page = 1;
      await Provider.of<NoticeProvider>(context, listen: false).getNotice();
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

  Future<void> _fetchMoreNotices() async {
    if (_isFetchingMore) return;

    setState(() {
      _isFetchingMore = true;
    });

    try {
      await Provider.of<NoticeProvider>(context, listen: false).getNotice();
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
    final provider = Provider.of<NoticeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Notices", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchNotices,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: provider.notificationList.length + (_isFetchingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == provider.notificationList.length) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final notice = provider.notificationList[index];
                  return NoticeRow(notice);
                },
              ),
            ),
    );
  }
}
