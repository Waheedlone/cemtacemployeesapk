import 'package:cnattendance/model/leave.dart';
import 'package:cnattendance/provider/leaveprovider.dart';
import 'package:cnattendance/utils/navigationservice.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/customalertdialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class IssueLeaveSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IssueLeaveSheetState();
}

class IssueLeaveSheetState extends State<IssueLeaveSheet> {
  Leave? selectedValue;

  bool isLoading = false;

  TextEditingController endDate = TextEditingController();
  TextEditingController reason = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController earlyExit = TextEditingController();

  bool isHalfDay = false;

  void issueLeave() async {
    if (endDate.text.isNotEmpty &&
        startDate.text.isNotEmpty &&
        reason.text.isNotEmpty &&
        selectedValue != null) {
      
      // Reason length validation: at least 10 characters
      if (reason.text.trim().length < 10) {
        NavigationService().showSnackBar("Leave Error", "Reason must be at least 10 characters long");
        return;
      }

      // Earned Leave validation: at least 3 days
      DateTime start = DateFormat('yyyy-MM-dd').parse(startDate.text);
      DateTime end = DateFormat('yyyy-MM-dd').parse(endDate.text);
      int days = end.difference(start).inDays + 1;

      if (selectedValue!.name.toLowerCase().contains("earned")) {
        if (days < 3) {
          NavigationService().showSnackBar("Leave Error", "Earned Leave must be at least 3 days");
          return;
        }
      }

      try {
        showLoader();
        isLoading = true;

        // Prepare reason: Append early exit time if available
        String finalReason = reason.text;
        if (earlyExit.text.isNotEmpty) {
          finalReason = "[Early Exit at ${earlyExit.text}] " + finalReason;
        }

        // Backend expects early_exit as a boolean (1 or 0). 
        // We send "1" if a time is picked, "0" otherwise.
        final response =
            await Provider.of<LeaveProvider>(context, listen: false).issueLeave(
                startDate.text, endDate.text, finalReason, selectedValue!.id, 
                earlyExit: earlyExit.text.isNotEmpty ? "1" : "0",
                isHalfDay: isHalfDay ? 1 : 0);

        if (!mounted) {
          return;
        }
        dismissLoader();
        Navigator.pop(context);
        isLoading = false;
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: CustomAlertDialog(response.message),
            );
          },
        );
      } catch (e) {
        dismissLoader();
        isLoading = false;
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: CustomAlertDialog(e.toString()),
            );
          },
        );
      }
    } else {
      NavigationService()
          .showSnackBar("Leave Status", "Field must not be empty");
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
          status: "Requesting...", maskType: EasyLoadingMaskType.black);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LeaveProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        return !isLoading;
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Apply Leave',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.black,
                      )),
                ],
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Row(
                        children: const [
                          Expanded(
                            child: Text(
                              'Select Leave Type',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: provider.leaveList
                          .where((element) => element.status)
                          .map((item) => DropdownMenuItem<Leave>(
                                value: item,
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value as Leave?;
                        });
                      },
                      iconStyleData: IconStyleData(
                        icon: const Icon(
                          Icons.arrow_forward_ios_outlined,
                        ),
                        iconSize: 14,
                        iconEnabledColor: Colors.black,
                        iconDisabledColor: Colors.grey,
                      ),
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(color: Colors.black26)
                        ),
                        elevation: 0,
                      ),
                      menuItemStyleData: MenuItemStyleData(
                        height: 40,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 200,
                        padding: null,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        elevation: 8,
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(40),
                          thickness: MaterialStateProperty.all(6),
                          thumbVisibility: MaterialStateProperty.all(true),
                        ),
                        offset: const Offset(0, 0),
                      ),
                    ),
                  )),
              gaps(10),
              TextField(
                controller: startDate,
                style: TextStyle(color: Colors.black),
                //editing controller of this TextField
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'Select Start Date',
                  hintStyle: TextStyle(color: Colors.black54),
                  prefixIcon: Icon(Icons.calendar_month, color: Colors.red),
                  labelStyle: TextStyle(color: Colors.black),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                readOnly: true,
                //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2100));
  
                  if (pickedDate != null) {
                    setState(() {
                      startDate.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
              ),
              gaps(10),
              TextField(
                controller: endDate,
                style: TextStyle(color: Colors.black),
                //editing controller of this TextField
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'Select End Date',
                  hintStyle: TextStyle(color: Colors.black54),
                  prefixIcon: Icon(Icons.calendar_month, color: Colors.red),
                  labelStyle: TextStyle(color: Colors.black),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                readOnly: true,
                //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2100));
  
                  if (pickedDate != null) {
                    setState(() {
                      endDate.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
              ),
              gaps(10),
              CheckboxListTile(
                title: const Text("Is Half Day?", style: TextStyle(color: Colors.black)),
                value: isHalfDay,
                onChanged: (bool? value) {
                  setState(() {
                    isHalfDay = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: Colors.red,
                checkColor: Colors.white,
              ),
              gaps(10),
              TextField(
                textAlignVertical: TextAlignVertical.top,
                controller: reason,
                maxLines: 5,
                style: TextStyle(color: Colors.black),
                //editing controller of this TextField
                cursorColor: Colors.black,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Reason',
                  hintStyle: TextStyle(color: Colors.black54),
                  prefixIcon: Icon(Icons.edit_note, color: Colors.red),
                  labelStyle: TextStyle(color: Colors.black),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              if (selectedValue != null && selectedValue!.isEarlyLeave)
                Column(
                  children: [
                    gaps(10),
                    TextField(
                      controller: earlyExit,
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: 'Early Exit Time (Optional)',
                        hintStyle: TextStyle(color: Colors.black54),
                        prefixIcon: Icon(Icons.access_time, color: Colors.red),
                        labelStyle: TextStyle(color: Colors.black),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      readOnly: true,
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
 
                        if (pickedTime != null) {
                          setState(() {
                            final now = DateTime.now();
                            final dt = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
                            earlyExit.text = DateFormat('HH:mm').format(dt);
                          });
                        }
                      },
                    ),
                  ],
                ),
              gaps(20),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 5),
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: HexColor("#00002B"),
                      padding: EdgeInsets.zero,
                      shape: ButtonBorder(),
                    ),
                    onPressed: () {
                      issueLeave();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Request Leave',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget gaps(double value) {
    return SizedBox(
      height: value,
    );
  }
}
