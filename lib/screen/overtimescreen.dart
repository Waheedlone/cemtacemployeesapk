import 'package:cnattendance/provider/overtimeprovider.dart';
import 'package:cnattendance/screen/overtimedetailscreen.dart';
import 'package:cnattendance/screen/overtimerequestscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OvertimeScreen extends StatefulWidget {
  static const String routeName = '/overtime';

  @override
  _OvertimeScreenState createState() => _OvertimeScreenState();
}

class _OvertimeScreenState extends State<OvertimeScreen> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<OvertimeProvider>(context, listen: false).fetchOvertimeRecords();
      Provider.of<OvertimeProvider>(context, listen: false).fetchOvertimeForApproval();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<void> _refreshData() async {
    await Provider.of<OvertimeProvider>(context, listen: false).fetchOvertimeRecords();
    await Provider.of<OvertimeProvider>(context, listen: false).fetchOvertimeForApproval();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Overtime",
              style: TextStyle(
                  color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          bottom: TabBar(
            labelColor: Color(0xFFED1C24),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFFED1C24),
            tabs: [
              Tab(text: "My Overtime"),
              Tab(text: "For Approval"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOvertimeList(context, false),
            _buildOvertimeList(context, true),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, OvertimeRequestScreen.routeName);
          },
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Color(0xFFED1C24),
        ),
      ),
    );
  }

  Widget _buildOvertimeList(BuildContext context, bool forApproval) {
    final otProvider = Provider.of<OvertimeProvider>(context);
    final records = forApproval ? otProvider.forApprovalRecords : otProvider.records;

    return otProvider.isLoading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _refreshData,
            child: records.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.more_time, size: 80, color: Colors.grey[300]),
                        SizedBox(height: 16),
                        Text(forApproval ? "No Pending Approvals" : "No Overtime Records Found",
                            style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final item = records[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        margin: EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Text(
                              forApproval ? item.employeeName : "Overtime - ${item.month}/${item.year}",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              if (forApproval) Text("Period: ${item.month}/${item.year}"),
                              Text("Hours: ${item.otHours} hrs"),
                              Text("Amount: ${item.otAmount}"),
                            ],
                          ),
                          trailing: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getStatusColor(item.status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item.status.toUpperCase(),
                              style: TextStyle(
                                color: _getStatusColor(item.status),
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              OvertimeDetailScreen.routeName,
                              arguments: item,
                            );
                          },
                        ),
                      );
                    },
                  ),
          );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'paid':
        return Colors.blue;
      case 'pending_final':
        return Colors.blue;
      case 'pending':
      default:
        return Colors.orange;
    }
  }
}
