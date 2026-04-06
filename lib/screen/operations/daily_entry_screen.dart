import 'package:cnattendance/provider/operationprovider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cnattendance/utils/responsive.dart';

class DailyEntryScreen extends StatefulWidget {
  static const String routeName = '/daily-entry';

  @override
  _DailyEntryScreenState createState() => _DailyEntryScreenState();
}

class _DailyEntryScreenState extends State<DailyEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _readingController = TextEditingController();
  final _remarksController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedOperationId;

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<OperationProvider>(context, listen: false).fetchOperations();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitData() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedOperationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select an operation")));
      return;
    }

    final provider = Provider.of<OperationProvider>(context, listen: false);
    final success = await provider.addDailyEntry(
      int.parse(_selectedOperationId!),
      DateFormat('yyyy-MM-dd').format(_selectedDate),
      double.parse(_readingController.text),
      _remarksController.text,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Daily entry added successfully")));
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to add daily entry")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final operationProvider = Provider.of<OperationProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Daily Site Entry", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Select Operation Unit", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedOperationId,
                    hint: Text("Select Unit"),
                    items: operationProvider.operations.map((op) {
                      return DropdownMenuItem(
                        value: op.id.toString(),
                        child: Text(op.title),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedOperationId = val;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Date", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                          Icon(Icons.calendar_today, size: 20),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Reading", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _readingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter reading value",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return "Please enter reading";
                      if (double.tryParse(val) == null) return "Please enter a valid number";
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Text("Remarks", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _remarksController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Optional remarks",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: operationProvider.isLoading ? null : _submitData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: operationProvider.isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Submit Entry", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
