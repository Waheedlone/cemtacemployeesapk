import 'package:cnattendance/provider/shifthandoverprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateShiftHandoverScreen extends StatefulWidget {
  @override
  _CreateShiftHandoverScreenState createState() =>
      _CreateShiftHandoverScreenState();
}

class _CreateShiftHandoverScreenState extends State<CreateShiftHandoverScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _summaryController = TextEditingController();
  final _pendingTasksController = TextEditingController();
  final _criticalIssuesController = TextEditingController();
  final _remarksController = TextEditingController();

  int? _selectedEmployeeId;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<ShiftHandoverProvider>(context, listen: false)
          .fetchHandoverEmployees();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _summaryController.dispose();
    _pendingTasksController.dispose();
    _criticalIssuesController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Submitting...');
      final error = await Provider.of<ShiftHandoverProvider>(context,
              listen: false)
          .submitShiftHandover(
        date: _dateController.text,
        summary: _summaryController.text,
        pendingTasks: _pendingTasksController.text,
        criticalIssues: _criticalIssuesController.text,
        handoverToUserId: _selectedEmployeeId,
        remarks: _remarksController.text,
      );

      EasyLoading.dismiss();

      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Shift handover submitted successfully!")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeeList = Provider.of<ShiftHandoverProvider>(context).employees;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Create Handover",
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
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Handover Date *",
                  hintText: "YYYY-MM-DD",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? "Required" : null,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(Duration(days: 7)),
                    lastDate: DateTime.now().add(Duration(days: 30)),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: "Handover To",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon: Icon(Icons.person),
                ),
                value: _selectedEmployeeId,
                items: employeeList.map((emp) {
                  return DropdownMenuItem<int>(
                    value: emp.id,
                    child: Text(emp.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEmployeeId = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _summaryController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Summary *",
                  hintText: "Enter work summary...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? "Required (max 5000 chars)"
                    : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _pendingTasksController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: "Pending Tasks",
                  hintText: "Enter any pending tasks...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _criticalIssuesController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: "Critical Issues",
                  hintText: "Enter any critical issues...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _remarksController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: "Remarks",
                  hintText: "Enter any additional remarks...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFED1C24),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Submit Handover",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
