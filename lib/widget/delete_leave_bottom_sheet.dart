import 'package:cnattendance/provider/leaveprovider.dart';
import 'package:cnattendance/utils/navigationservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class DeleteLeaveBottomSheet extends StatefulWidget {
  final int id;

  DeleteLeaveBottomSheet(this.id);

  @override
  State<StatefulWidget> createState() => _DeleteLeaveBottomSheetState();
}

class _DeleteLeaveBottomSheetState extends State<DeleteLeaveBottomSheet> {
  void deleteLeave() async {
    try {
      showLoader();
      final leaveData = Provider.of<LeaveProvider>(context, listen: false);

      final response = await leaveData.deleteLeave(widget.id);

      dismissLoader();
      if (!mounted) {
        return;
      }
      
      NavigationService().showSnackBar("Leave Status", response.message);
      Navigator.pop(context);
      await leaveData.getLeaveTypeDetail();

    } catch (e) {
      NavigationService().showSnackBar("Delete Leave", e.toString());
      dismissLoader();
    }
  }

  void dismissLoader() {
    if (mounted) {
      setState(() {
        EasyLoading.dismiss(animation: true);
      });
    }
  }

  void showLoader() {
    if (mounted) {
      setState(() {
        EasyLoading.show(
            status: "Deleting, Please Wait..",
            maskType: EasyLoadingMaskType.black);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
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
            const Text(
              'Delete Leave',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            const Text(
              'Are you sure you want to delete this leave? This action cannot be undone.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Go back',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor('#ED1C24'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      deleteLeave();
                    },
                    child: const Text(
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
