// import 'package:cnattendance/model/leave.dart';
// import 'package:cnattendance/provider/leaveprovider.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:provider/provider.dart';
//
// class LeaveTypeIssueLeave extends StatefulWidget {
//
//   @override
//   State<StatefulWidget> createState() => LeaveTypeIssueLeaveState();
// }
//
// class LeaveTypeIssueLeaveState extends State<LeaveTypeIssueLeave>{
//   Leave? selectedValue;
//
//   @override
//   Widget build(BuildContext context, [bool mounted = true]) {
//     final provider = Provider.of<LeaveProvider>(context);
//
//     return DropdownButtonHideUnderline(
//       child: DropdownButton2(
//         isExpanded: true,
//         hint: Row(
//           children: const [
//             Icon(
//               Icons.list,
//               size: 16,
//               color: Colors.white,
//             ),
//             SizedBox(
//               width: 4,
//             ),
//             Expanded(
//               child: Text(
//                 'Select Leave Type',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//         items: provider.leaveList
//             .map((item) => DropdownMenuItem<Leave>(
//                   value: item,
//                   child: Text(
//                     item.name,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ))
//             .toList(),
//         value: selectedValue,
//         onChanged: (value) {
//           selectedValue = value as Leave?;
//           if (selectedValue != null) {
//             setState(() {
//
//             });
//           }
//         },
//         iconStyleData: IconStyleData(
//           icon: const Icon(
//             Icons.arrow_forward_ios_outlined,
//           ),
//           iconSize: 14,
//           iconEnabledColor: Colors.white,
//           iconDisabledColor: Colors.grey,
//         ),
//         buttonStyleData: ButtonStyleData(
//           height: 50,
//           width: 160,
//           padding: const EdgeInsets.only(left: 14, right: 14),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             color: HexColor("#036eb7"),
//           ),
//           elevation: 0,
//         ),
//         menuItemStyleData: MenuItemStyleData(
//           height: 40,
//           padding: const EdgeInsets.only(left: 14, right: 14),
//         ),
//         dropdownStyleData: DropdownStyleData(
//           maxHeight: 200,
//           width: 200,
//           padding: null,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             color: HexColor("#036eb7"),
//           ),
//           elevation: 8,
//           scrollbarTheme: ScrollbarThemeData(
//             radius: const Radius.circular(40),
//             thickness: MaterialStateProperty.all(6),
//             thumbVisibility: MaterialStateProperty.all(true),
//           ),
//           offset: const Offset(-20, 0),
//         ),
//       ),
//     );
//   }
// }
import 'package:cnattendance/model/leave.dart';
import 'package:cnattendance/provider/leaveprovider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class LeaveTypeIssueLeave extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LeaveTypeIssueLeaveState();
}

class LeaveTypeIssueLeaveState extends State<LeaveTypeIssueLeave> {
  Leave? selectedValue;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LeaveProvider>(context);

    return DropdownButtonHideUnderline(
      child: DropdownButton2<Leave>(
        isExpanded: true,
        hint: Row(
          children: const [
            Icon(
              Icons.list,
              size: 16,
              color: Colors.white,
            ),
            SizedBox(
              width: 4,
            ),
            Expanded(
              child: Text(
                'Select Leave Type',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: provider.leaveList
            .map((item) => DropdownMenuItem<Leave>(
          value: item,
          child: Text(
            item.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ))
            .toList(),
        value: selectedValue,
        onChanged: (Leave? value) {
          setState(() {
            selectedValue = value;
          });
        },
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.arrow_forward_ios_outlined),
          iconSize: 14,
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.grey,
        ),
        buttonStyleData: ButtonStyleData(
          height: 50,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: HexColor("#036eb7"),
          ),
          elevation: 0,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: HexColor("#036eb7"),
          ),
          elevation: 8,
          offset: const Offset(0, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all(6),
            thumbVisibility: WidgetStateProperty.all(true),
          ),
        ),
      ),
    );
  }
}