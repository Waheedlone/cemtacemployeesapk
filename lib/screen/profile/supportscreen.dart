import 'package:cnattendance/model/department.dart';
import 'package:cnattendance/provider/supportcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class SupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Get.put(SupportController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Support", style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          InkWell(
            onTap: () {
              model.showList();
            },
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Icon(Icons.list_alt, color: Colors.black),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: model.form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(Icons.support_agent_rounded,
                          color: HexColor('#ED1C24'), size: 60),
                      SizedBox(height: 10),
                      Text(
                        "Help Desk",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Contact Us if any problem or complains need to be addressed.",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Obx(
                () => model.isLoading.value
                    ? Center(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ))
                    : DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Text(
                            'Select Department Type',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          items: model.departments.map((Department e) {
                            return DropdownMenuItem(
                              value: e.name,
                              child: Text(e.name, style: TextStyle(color: Colors.black)),
                            );
                          }).toList(),
                          value: model.selected.value.name == ""
                              ? null
                              : model.selected.value.name,
                          onChanged: (value) {
                            final result = model.departments
                                .where((dep) => dep.name == value)
                                .toList();
                            if (result.isNotEmpty) {
                              model.selected.value = result[0];
                            }
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 50,
                            padding: const EdgeInsets.only(left: 14, right: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.white,
                            ),
                          ),
                          iconStyleData: IconStyleData(
                            icon: const Icon(Icons.arrow_forward_ios_outlined, size: 14),
                          ),
                          dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                      ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: model.titleController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Field can't be empty";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: model.descriptionController,
                maxLength: 500,
                maxLines: 5,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Field can't be empty";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Description",
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor('#ED1C24'),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  model.onSubmitClicked();
                },
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
