import 'package:cnattendance/provider/leaveprovider.dart';
import 'package:cnattendance/utils/navigationservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class CancelLeaveBottomSheet extends StatefulWidget {
  int id;

  CancelLeaveBottomSheet(this.id);

  @override
  State<StatefulWidget> createState() => CancelLeaveBottomSheetState(id);
}

class CancelLeaveBottomSheetState extends State<CancelLeaveBottomSheet> {
  int id;

  CancelLeaveBottomSheetState(this.id);

  void cancelLeave() async {
    try {
      setState(() {
        showLoader();
      });
      final leaveData = Provider.of<LeaveProvider>(context, listen: false);

      final response = await leaveData.cancelLeave(id);

      setState(() {
        dismissLoader();
      });
      if (!mounted) {
        return;
      }
      
      NavigationService().showSnackBar("Leave Status", response.message);
      Navigator.pop(context);
      await leaveData.getLeaveTypeDetail();

    } catch (e) {
      NavigationService().showSnackBar("Cancel Leave", e.toString());
      setState(() {
        dismissLoader();
      });
    }
  }

  void dismissLoader() {
    setState(() {
      EasyLoading.dismiss(animation: true);
    });
  }

  void showLoader() {
    setState(() {
      EasyLoading.show(
          status: "Canceling, Please Wait..",
          maskType: EasyLoadingMaskType.black);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Cancel Leave',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Text(
              'Are you sure you want to cancel this leave?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Go back',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor('#ED1C24'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      cancelLeave();
                    },
                    child: Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
