import 'package:cnattendance/provider/createtadacontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class CreateTadaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Get.put(CreateTadaController());
    return Scaffold(
      backgroundColor: Colors.white, // Match homescreen background
      appBar: AppBar(
        title: Text("Create TADA"),
        elevation: 0, // A flatter look
        backgroundColor: Colors.white, // Match background
        foregroundColor: Colors.black, // For title and back button
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: HexColor('#070532'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Consistent border radius
              ),
              padding: EdgeInsets.all(15),
            ),
            onPressed: () {
              model.checkForm();
            },
            child: Text("Submit"),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20), // Consistent padding
          child: Form(
            key: model.key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10), // Initial space
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: model.titleController,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Field is required";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: model.descriptionController,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Field is required";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: model.expensesController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Field is required";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Total Expenses',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Add Attachment",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Heading style from homescreen
                        ),
                        SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: () {
                            model.onFileClicked();
                          },
                          icon: Icon(Icons.add),
                          label: Text("Select File"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: HexColor('#070532'),
                            side: BorderSide(color: HexColor('#070532')),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                        ),
                        SizedBox(height: 10),
                        Obx(
                          () => ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: model.fileList.length,
                            itemBuilder: (context, index) {
                              final file = model.fileList[index];
                              return ListTile(
                                title: Text(file.name),
                                trailing: IconButton(
                                  onPressed: () {
                                    model.removeItem(index);
                                  },
                                  icon: Icon(Icons.close),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20), // Space at the bottom before nav bar
              ],
            ),
          ),
        ),
      ),
    );
  }
}
