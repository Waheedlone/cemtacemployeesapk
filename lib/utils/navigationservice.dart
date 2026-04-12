import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:in_app_notification/in_app_notification.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void showSnackBar(String title, String desc, {bool isError = false}) {
    try {
      InAppNotification.show(
        child: Card(
          margin: const EdgeInsets.all(15),
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            leading: Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: isError ? Colors.red : Colors.green,
              size: 30,
            ),
            iconColor: HexColor("#011754"),
            textColor: HexColor("#011754"),
            minVerticalPadding: 10,
            minLeadingWidth: 0,
            tileColor: Colors.white,
            title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              desc,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ),
        context: NavigationService.navigatorKey.currentState!.context,
      );
    } catch (e) {
      print(e);
    }
  }
}
