import 'package:cnattendance/provider/overtimeprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class OvertimeRequestScreen extends StatefulWidget {
  static const String routeName = '/overtime-request';

  @override
  _OvertimeRequestScreenState createState() => _OvertimeRequestScreenState();
}

class _OvertimeRequestScreenState extends State<OvertimeRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _hoursController = TextEditingController();
  final _remarksController = TextEditingController();
  
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  final List<int> _years = List.generate(10, (index) => DateTime.now().year + index);
  final List<String> _months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  @override
  void dispose() {
    _hoursController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    EasyLoading.show(status: 'Submitting...');
    
    final provider = Provider.of<OvertimeProvider>(context, listen: false);
    final error = await provider.submitOvertimeRequest(
      month: _selectedMonth,
      year: _selectedYear,
      otHours: double.parse(_hoursController.text),
      remarks: _remarksController.text.isNotEmpty ? _remarksController.text : null,
    );

    EasyLoading.dismiss();

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Overtime request submitted successfully")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Request Overtime",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Month", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _selectedMonth,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                items: List.generate(12, (index) => index + 1).map((month) {
                  return DropdownMenuItem(
                    value: month,
                    child: Text(_months[month - 1]),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedMonth = val!),
              ),
              SizedBox(height: 20),
              Text("Year", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _selectedYear,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                items: _years.map((year) {
                  return DropdownMenuItem(
                    value: year,
                    child: Text(year.toString()),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedYear = val!),
              ),
              SizedBox(height: 20),
              Text("OT Hours", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              TextFormField(
                controller: _hoursController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: "Enter hours (e.g. 4.5)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return "Please enter hours";
                  if (double.tryParse(val) == null) return "Enter a valid number";
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text("Remarks (Optional)", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              TextFormField(
                controller: _remarksController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Enter any remarks",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFED1C24),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("Submit Request", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
