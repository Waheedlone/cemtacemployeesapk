import 'package:cnattendance/provider/substitutionprovider.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SubstitutionRequestScreen extends StatefulWidget {
  static const String routeName = '/substitution-request';

  @override
  _SubstitutionRequestScreenState createState() => _SubstitutionRequestScreenState();
}

class _SubstitutionRequestScreenState extends State<SubstitutionRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  
  DateTime? _dateFrom;
  DateTime? _dateTo;
  int? _selectedEmployeeId;
  int? _selectedSubstituteId;
  
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<SubstitutionProvider>(context, listen: false).fetchEmployees();
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _dateFrom = picked;
        } else {
          _dateTo = picked;
        }
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dateFrom == null || _dateTo == null) {
      showToast("Please select dates");
      return;
    }
    if (_selectedSubstituteId == null) {
      showToast("Please select a substitute");
      return;
    }

    final provider = Provider.of<SubstitutionProvider>(context, listen: false);
    final Map<String, dynamic> body = {
      "substitute_id": _selectedSubstituteId,
      "date_from": DateFormat('yyyy-MM-dd').format(_dateFrom!),
      "date_to": DateFormat('yyyy-MM-dd').format(_dateTo!),
      "reason": _reasonController.text,
    };

    if (_selectedEmployeeId != null) {
      body["employee_id"] = _selectedEmployeeId;
    }

    final error = await provider.createSubstitution(body);
    if (error == null) {
      showToast("Substitution request created successfully");
      Navigator.pop(context);
    } else {
      showToast(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final employees = Provider.of<SubstitutionProvider>(context).employees;
    final isLoading = Provider.of<SubstitutionProvider>(context).isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Request Substitution",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Requesting for (Optional - for Supervisor)", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      hint: Text("Select Employee"),
                      value: _selectedEmployeeId,
                      items: employees.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                      onChanged: (val) => setState(() => _selectedEmployeeId = val),
                    ),
                    SizedBox(height: 20),
                    Text("Select Substitute *", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      hint: Text("Select Substitute"),
                      value: _selectedSubstituteId,
                      items: employees.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                      onChanged: (val) => setState(() => _selectedSubstituteId = val),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Date From *", style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              InkWell(
                                onTap: () => _selectDate(context, true),
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(_dateFrom == null ? "Select Date" : DateFormat('yyyy-MM-dd').format(_dateFrom!)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Date To *", style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              InkWell(
                                onTap: () => _selectDate(context, false),
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(_dateTo == null ? "Select Date" : DateFormat('yyyy-MM-dd').format(_dateTo!)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text("Reason *", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _reasonController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        hintText: "Enter reason for substitution",
                      ),
                      validator: (val) => val == null || val.isEmpty ? "Required" : null,
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFED1C24),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: _submit,
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
