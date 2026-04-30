import 'package:cnattendance/provider/substitutionprovider.dart';
import 'package:cnattendance/screen/substitutionrequestscreen.dart';
import 'package:cnattendance/screen/substitutiondetailscreen.dart';
import 'package:cnattendance/screen/substitutionapprovalscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubstitutionScreen extends StatefulWidget {
  static const String routeName = '/substitution';

  @override
  _SubstitutionScreenState createState() => _SubstitutionScreenState();
}

class _SubstitutionScreenState extends State<SubstitutionScreen> with SingleTickerProviderStateMixin {
  bool _isInit = true;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) return;
    String? status;
    switch (_tabController.index) {
      case 1:
        status = 'pending';
        break;
      case 2:
        status = 'approved';
        break;
      case 3:
        status = 'rejected';
        break;
    }
    Provider.of<SubstitutionProvider>(context, listen: false).fetchSubstitutions(status: status);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<SubstitutionProvider>(context, listen: false).fetchSubstitutions();
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<void> _refreshData() async {
    String? status;
    switch (_tabController.index) {
      case 1:
        status = 'pending';
        break;
      case 2:
        status = 'approved';
        break;
      case 3:
        status = 'rejected';
        break;
    }
    await Provider.of<SubstitutionProvider>(context, listen: false).fetchSubstitutions(status: status);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final substitutionProvider = Provider.of<SubstitutionProvider>(context);
    final substitutions = substitutionProvider.substitutions;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Substitutions",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.approval),
            onPressed: () {
              Navigator.pushNamed(context, SubstitutionApprovalScreen.routeName);
            },
            tooltip: "For Approval",
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Color(0xFFED1C24),
          unselectedLabelColor: Colors.grey,
          indicatorColor: Color(0xFFED1C24),
          tabs: [
            Tab(text: "All"),
            Tab(text: "Pending"),
            Tab(text: "Approved"),
            Tab(text: "Rejected"),
          ],
        ),
      ),
      body: substitutionProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: substitutions.isEmpty
                  ? ListView(
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Center(child: Text("No substitutions found")),
                        ),
                      ],
                    )
                  : ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
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
                            title: Text("${item.substituteName} (Substitute)",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                Text("Dates: ${item.dateFrom} to ${item.dateTo}",
                                    style: TextStyle(color: Colors.grey[700])),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text("Status: ", style: TextStyle(fontSize: 12)),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(item.status).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        item.status.toUpperCase(),
                                        style: TextStyle(
                                          color: _getStatusColor(item.status),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Icon(Icons.arrow_forward_ios,
                                size: 16, color: Colors.grey),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, SubstitutionDetailScreen.routeName,
                                  arguments: item);
                            },
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, SubstitutionRequestScreen.routeName);
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFFED1C24),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
