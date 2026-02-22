import 'package:cnattendance/provider/createtadacontroller.dart';
import 'package:cnattendance/provider/edittadacontroller.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class EditTadaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Get.put(EditTadaController());
    return Container(
      decoration: RadialDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Edit TADA"),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            margin: EdgeInsets.all(20),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(10)))),
                onPressed: () {
                  model.checkForm();
                },
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text("Submit"),
                )),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: model.key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: model.titleController,
                    keyboardType: TextInputType.name,
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Field is required";
                      }
                      return null;
                    },
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(color: Colors.white70),
                      labelStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.white24,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(10))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(10))),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(10))),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(10))),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: model.descriptionController,
                    maxLines: 5,
                    keyboardType: TextInputType.name,
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Field is required";
                      }
                      return null;
                    },
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      hintStyle: TextStyle(color: Colors.white70),
                      labelStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.white24,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(10))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(10))),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(10))),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(10))),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: model.expensesController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Field is required";
                      }
                      return null;
                    },
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: 'Total Expenses',
                      hintStyle: TextStyle(color: Colors.white70),
                      labelStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.white24,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(10))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(10))),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(10))),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(10))),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Attachment",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: model.attachmentList.length,
                      itemBuilder: (context, index) {
                        final file = model.attachmentList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            onTap: () {
                              model.launchUrls(file.url);
                            },
                            tileColor: Colors.white12,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(0),
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(10))),
                            minVerticalPadding: 10,
                            title: Text(
                              file.url,
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: GestureDetector(
                                onTap: () {
                                  model.removeAttachment(file.id, index);
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                )),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Add Attachments",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      model.onFileClicked();
                    },
                    child: Card(
                        shape: CircleBorder(),
                        color: Colors.white54,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        )),
                  ),
                  Obx(
                    () => ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: model.fileList.length,
                      itemBuilder: (context, index) {
                        final file = model.fileList[index];
                        return ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(0),
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(10))),
                          onTap: () {
                            model.launchFile(file.path!);
                          },
                          title: Text(
                            file.name,
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: GestureDetector(
                              onTap: () {
                                model.removeItem(index);
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              )),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
