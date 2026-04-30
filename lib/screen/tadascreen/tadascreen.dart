import 'package:cnattendance/model/tada.dart';
import 'package:cnattendance/provider/tadalistcontroller.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class TadaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Get.put(TadaListController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("TADA", style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            model.onTadaCreateClicked();
          },
          child: Icon(Icons.add),
          backgroundColor: HexColor('#ED1C24')),
      body: Obx(
        () => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: RefreshIndicator(
              onRefresh: () {
                return model.getTadaList();
              },
              child: model.tadaList.isEmpty
                  ? ListView(
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Center(child: Text("No TADA records found")),
                        ),
                      ],
                    )
                  : ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: model.tadaList.length,
                itemBuilder: (context, index) {
                  Tada item = model.tadaList[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      onTap: () {
                        model.onTadaClicked(item.id.toString());
                      },
                      title: Text(
                        item.title,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        item.submittedDate,
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          if (item.status == "Accepted") {
                            showToast("Accepted TADA can't be edited");
                          } else {
                            model.onTadaEditClicked(item.id.toString());
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.edit, color: Colors.grey),
                        ),
                      ),
                      leading: CircleAvatar(
                          backgroundColor: item.status == "Pending"
                              ? Colors.orange.withOpacity(0.1)
                              : item.status == "Rejected"
                                  ? Colors.red.withOpacity(0.1)
                                  : Colors.green.withOpacity(0.1),
                          child: Text(
                            item.status == "Pending"
                                ? "P"
                                : item.status == "Rejected"
                                    ? "R"
                                    : "A",
                            style: TextStyle(
                                color: item.status == "Pending"
                                    ? Colors.orange
                                    : item.status == "Rejected"
                                        ? Colors.red
                                        : Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
