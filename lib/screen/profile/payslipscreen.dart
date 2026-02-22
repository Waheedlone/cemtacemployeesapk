import 'package:cnattendance/provider/payslipprovider.dart';
import 'package:cnattendance/screen/profile/payslipdetailscreen.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';


class PaySlipScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final list = Provider.of<PaySlipProvider>(context).paySlipList;
    return Container(
      decoration: RadialDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('PaySlip'),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  color: Colors.black26,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Text(
                          textAlign: TextAlign.start,
                          "ID",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          textAlign: TextAlign.center,
                          "Date",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          textAlign: TextAlign.end,
                          "Payment",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          textAlign: TextAlign.end,
                          "",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(PaySlipDetailScreen.routeName);
                      },
                      child: Container(
                        color: index % 2 == 0 ? Colors.white30 : Colors.black26,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Text(
                                    textAlign: TextAlign.start,
                                    list[index].id,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    list[index].date,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    textAlign: TextAlign.end,
                                    "Rs. ${list[index].payment}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      FileDownloader.downloadFile(
                                        url: "https://www.africau.edu/images/default/sample.pdf",
                                        name:
                                        '${list[index].date}.pdf',
                                        onDownloadCompleted: (path) {
                                          //NotificationService().flutterLocalNotificationsPlugin.show(1, "Download", "Completed", NotificationService().platform());
                                          print(path);
                                        },
                                        onDownloadError: (errorMessage) {
                                          print(errorMessage);
                                        },
                                        onProgress: (fileName, progress) {
                                          print(progress);
                                        },
                                      );
                                    },
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.download,
                                          color: Colors.white,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
