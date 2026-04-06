import 'package:cnattendance/provider/operationprovider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OperationsHistoryScreen extends StatefulWidget {
  static const String routeName = '/operations-history';

  @override
  _OperationsHistoryScreenState createState() => _OperationsHistoryScreenState();
}

class _OperationsHistoryScreenState extends State<OperationsHistoryScreen> {
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OperationProvider>(context, listen: false)
          .fetchDailyEntries(month: _selectedMonth, year: _selectedYear);
    });
  }

  void _refresh() {
    Provider.of<OperationProvider>(context, listen: false)
        .fetchDailyEntries(month: _selectedMonth, year: _selectedYear);
  }

  @override
  Widget build(BuildContext context) {
    final operationProvider = Provider.of<OperationProvider>(context);
    final entries = operationProvider.dailyEntries;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Operations History", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<int>(
                    value: _selectedMonth,
                    items: List.generate(12, (index) => index + 1).map((m) {
                      return DropdownMenuItem(value: m, child: Text(DateFormat('MMMM').format(DateTime(2024, m))));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedMonth = val);
                        _refresh();
                      }
                    },
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: DropdownButton<int>(
                    value: _selectedYear,
                    items: [2023, 2024, 2025, 2026].map((y) {
                      return DropdownMenuItem(value: y, child: Text(y.toString()));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedYear = val);
                        _refresh();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: operationProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : entries.isEmpty
                    ? Center(child: Text("No entries found for this month"))
                    : ListView.builder(
                        itemCount: entries.length,
                        itemBuilder: (ctx, i) {
                          final entry = entries[i];
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ListTile(
                              title: Text("Reading: ${entry['reading']}"),
                              subtitle: Text("Date: ${entry['date']}\nID: ${entry['operation_id']}"),
                              trailing: Text(entry['status'] ?? "Recorded", style: TextStyle(color: Colors.green)),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
