import 'package:cnattendance/model/substitution.dart';
import 'package:cnattendance/provider/substitutionprovider.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubstitutionDetailScreen extends StatefulWidget {
  static const String routeName = '/substitution-detail';
  final dynamic substitution;

  SubstitutionDetailScreen({required this.substitution});

  @override
  _SubstitutionDetailScreenState createState() => _SubstitutionDetailScreenState();
}

class _SubstitutionDetailScreenState extends State<SubstitutionDetailScreen> {
  final _remarksController = TextEditingController();
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.substitution is Substitution) {
          Provider.of<SubstitutionProvider>(context, listen: false)
              .fetchSubstitutionDetail(widget.substitution.id);
        } else if (widget.substitution is int) {
          Provider.of<SubstitutionProvider>(context, listen: false)
              .fetchSubstitutionDetail(widget.substitution);
        }
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  void _approve() async {
    final provider = Provider.of<SubstitutionProvider>(context, listen: false);
    final error = await provider.approveSubstitution(provider.selectedSubstitution!.id, remarks: _remarksController.text);
    if (error == null) {
      showToast("Approved successfully");
      Navigator.pop(context);
    } else {
      showToast(error);
    }
  }

  void _reject() async {
    if (_remarksController.text.isEmpty) {
      showToast("Please enter remarks for rejection");
      return;
    }
    final provider = Provider.of<SubstitutionProvider>(context, listen: false);
    final error = await provider.rejectSubstitution(provider.selectedSubstitution!.id, _remarksController.text);
    if (error == null) {
      showToast("Rejected successfully");
      Navigator.pop(context);
    } else {
      showToast(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubstitutionProvider>(context);
    final substitution = provider.selectedSubstitution;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Substitution Details",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : substitution == null
              ? Center(child: Text("Details not found"))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailItem("Employee", substitution.employeeName),
                      _buildDetailItem("Substitute", substitution.substituteName),
                      _buildDetailItem("From Date", substitution.dateFrom),
                      _buildDetailItem("To Date", substitution.dateTo),
                      _buildDetailItem("Reason", substitution.reason),
                      _buildDetailItem("Status", substitution.status.toUpperCase(), isStatus: true),
                      if (substitution.approvedByName != null)
                        _buildDetailItem("Approved By", substitution.approvedByName!),
                      if (substitution.approvedAt != null)
                        _buildDetailItem("Approved At", substitution.approvedAt!),
                      if (substitution.remarks != null && substitution.remarks!.isNotEmpty)
                        _buildDetailItem("Remarks", substitution.remarks!),
                      
                      SizedBox(height: 30),
                      if (substitution.status.toLowerCase() == 'pending') ...[
                        Text("Action Remarks", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        TextField(
                          controller: _remarksController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            hintText: "Enter remarks (required for rejection)",
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: _approve,
                                child: Text("Approve", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: _reject,
                                child: Text("Reject", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _buildDetailItem(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey, fontSize: 13)),
          SizedBox(height: 4),
          isStatus
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(value).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      color: _getStatusColor(value),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                )
              : Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
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
