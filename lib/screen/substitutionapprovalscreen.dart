import 'package:cnattendance/provider/substitutionprovider.dart';
import 'package:cnattendance/screen/substitutiondetailscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubstitutionApprovalScreen extends StatefulWidget {
  static const String routeName = '/substitution-approval';

  @override
  _SubstitutionApprovalScreenState createState() => _SubstitutionApprovalScreenState();
}

class _SubstitutionApprovalScreenState extends State<SubstitutionApprovalScreen> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<SubstitutionProvider>(context, listen: false).fetchSubstitutionsForApproval();
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<void> _refreshData() async {
    await Provider.of<SubstitutionProvider>(context, listen: false).fetchSubstitutionsForApproval();
  }

  @override
  Widget build(BuildContext context) {
    final substitutionProvider = Provider.of<SubstitutionProvider>(context);
    final substitutions = substitutionProvider.forApprovalSubstitutions;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Substitution Approvals",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: substitutionProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: substitutions.isEmpty
                  ? Center(child: Text("No substitution requests for approval"))
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: substitutions.length,
                      itemBuilder: (context, index) {
                        final item = substitutions[index];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text("${item.employeeName} (Employee)",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                Text("Substitute: ${item.substituteName}",
                                    style: TextStyle(color: Colors.grey[700])),
                                SizedBox(height: 4),
                                Text("Dates: ${item.dateFrom} to ${item.dateTo}",
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                SizedBox(height: 4),
                                Text("Reason: ${item.reason}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                              ],
                            ),
                            trailing: Icon(Icons.arrow_forward_ios,
                                size: 16, color: Colors.grey),
                            onTap: () async {
                              await Navigator.pushNamed(
                                  context, SubstitutionDetailScreen.routeName,
                                  arguments: item);
                              _refreshData();
                            },
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
