import 'package:cnattendance/provider/leaveprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaveConfirmationScreen extends StatefulWidget {
  static const String routeName = '/leave-confirmation';

  @override
  _LeaveConfirmationScreenState createState() => _LeaveConfirmationScreenState();
}

class _LeaveConfirmationScreenState extends State<LeaveConfirmationScreen> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<LeaveProvider>(context, listen: false).fetchLeaveForConfirmation();
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  void _showConfirmDialog(int id) {
    final _remarksController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Confirm Leave"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Are you sure you want to approve this leave request?"),
            SizedBox(height: 10),
            TextField(
              controller: _remarksController,
              decoration: InputDecoration(hintText: "Remarks (optional)"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              try {
                await Provider.of<LeaveProvider>(context, listen: false)
                    .confirmLeave(id, "approved", _remarksController.text);
                Navigator.of(ctx).pop();
                Provider.of<LeaveProvider>(context, listen: false).fetchLeaveForConfirmation();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Leave approved")));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
            child: Text("Approve"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(int id) {
    final _remarksController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Reject Leave"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Please provide a reason for rejection:"),
            SizedBox(height: 10),
            TextField(
              controller: _remarksController,
              decoration: InputDecoration(hintText: "Reason..."),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              if (_remarksController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Remarks are required for rejection")));
                return;
              }
              try {
                await Provider.of<LeaveProvider>(context, listen: false)
                    .confirmLeave(id, "rejected", _remarksController.text);
                Navigator.of(ctx).pop();
                Provider.of<LeaveProvider>(context, listen: false).fetchLeaveForConfirmation();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Leave rejected")));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
            child: Text("Reject"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final leaveProvider = Provider.of<LeaveProvider>(context);
    final leaves = leaveProvider.leaveForConfirmationList;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Leave Confirmations", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: leaveProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => leaveProvider.fetchLeaveForConfirmation(),
              child: leaves.isEmpty
                  ? Center(child: Text("No leave requests pending confirmation"))
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: leaves.length,
                      itemBuilder: (ctx, i) {
                        final leave = leaves[i];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(leave.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(leave.status, style: TextStyle(color: Colors.orange, fontSize: 12)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text("From: ${leave.leave_from} To: ${leave.leave_to}", style: TextStyle(color: Colors.grey[700])),
                                SizedBox(height: 4),
                                Text("Requested on: ${leave.requested_date}", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () => _showRejectDialog(leave.id),
                                        child: Text("Reject", style: TextStyle(color: Colors.red)),
                                        style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.red)),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () => _showConfirmDialog(leave.id),
                                        child: Text("Approve"),
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
