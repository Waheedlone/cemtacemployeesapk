import 'package:cnattendance/provider/notificationprovider.dart';
import 'package:cnattendance/provider/prefprovider.dart';
import 'package:cnattendance/screen/profile/NotificationScreen.dart';
import 'package:cnattendance/screen/profile/profilescreen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';

class HeaderProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HeaderState();
}

class HeaderState extends State<HeaderProfile> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false)
          .fetchUnreadCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PrefProvider>(context);
    return GestureDetector(
      onTap: () {
        pushScreen(context,
            screen: ProfileScreen(),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.fade);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: provider.avatar.isNotEmpty && provider.avatar.startsWith('http')
                      ? Image.network(
                          provider.avatar,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/dummy_avatar.png',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'assets/images/dummy_avatar.png',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello There',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    Text(
                      provider.fullname,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            Consumer<NotificationProvider>(
              builder: (context, notificationProvider, child) {
                final count = notificationProvider.unreadCount;
                return Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        notificationProvider.markAllRead();
                        pushScreen(context,
                            screen: NotificationScreen(),
                            withNavBar: false,
                            pageTransitionAnimation:
                                PageTransitionAnimation.fade);
                      },
                      icon: Icon(
                        Icons.notifications_none,
                        color: HexColor('#ED1C24'),
                        size: 30,
                      ),
                    ),
                    if (count > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFED1C24),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 17,
                            minHeight: 17,
                          ),
                          child: Text(
                            count > 99 ? '99+' : count.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
