import 'package:cnattendance/provider/shifthandoverprovider.dart';
import 'package:cnattendance/screen/createshifthandoverscreen.dart';
import 'package:cnattendance/screen/shifthandoverdetailscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShiftHandoverScreen extends StatefulWidget {
  static const String routeName = '/shifthandover';

  @override
  _ShiftHandoverScreenState createState() => _ShiftHandoverScreenState();
}

class _ShiftHandoverScreenState extends State<ShiftHandoverScreen> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ShiftHandoverProvider>(context, listen: false).fetchShiftHandovers();
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<void> _refreshData() async {
    await Provider.of<ShiftHandoverProvider>(context, listen: false).fetchShiftHandovers();
  }

  @override
  Widget build(BuildContext context) {
    final handoverProvider = Provider.of<ShiftHandoverProvider>(context);
    final handovers = handoverProvider.handovers;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Shift Handover",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: handoverProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: handovers.isEmpty
                  ? Center(child: Text("No handovers found"))
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: handovers.length,
                      itemBuilder: (context, index) {
                        final item = handovers[index];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text("Handover - ${item.handoverDate}",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                Text("Handed over to: ${item.handoverToName ?? 'N/A'}",
                                    style: TextStyle(color: Colors.grey[700])),
                                SizedBox(height: 4),
                                Text(item.summary,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 12)),
                              ],
                            ),
                            trailing: Icon(Icons.arrow_forward_ios,
                                size: 16, color: Colors.grey),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, ShiftHandoverDetailScreen.routeName,
                                  arguments: item);
                            },
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateShiftHandoverScreen(),
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFFED1C24),
      ),
    );
  }
}

