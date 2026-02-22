import 'package:cnattendance/model/internal_requisition.dart';
import 'package:cnattendance/provider/internal_requisition_provider.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class InternalRequisitionDetailScreen extends StatefulWidget {
  final int id;

  const InternalRequisitionDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  _InternalRequisitionDetailScreenState createState() => _InternalRequisitionDetailScreenState();
}

class _InternalRequisitionDetailScreenState extends State<InternalRequisitionDetailScreen> {
  InternalRequisition? _requisition;
  bool _isLoading = true;
  final TextEditingController _remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _loadDetail() async {
    try {
      final requisition = await Provider.of<InternalRequisitionProvider>(context, listen: false)
          .fetchRequisitionDetail(widget.id);
      if (mounted) {
        setState(() {
          _requisition = requisition;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: AppBar(
        title: Text('Requisition Detail', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _requisition == null
              ? Center(child: Text('Failed to load detail'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionCard(
                          title: "Information",
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow("Request No", _requisition!.requestNo, isBold: true),
                              Divider(height: 24),
                              _buildDetailRow("Department", _requisition!.department),
                              Divider(height: 24),
                              _buildDetailRow("Requester", _requisition!.requestedByName),
                              Divider(height: 24),
                              _buildDetailRow("Request Date", _requisition!.requestDate),
                              Divider(height: 24),
                              _buildDetailRow("Priority", _requisition!.priority.toUpperCase(),
                                  statusTextColor: _getPriorityColor(_requisition!.priority)),
                              Divider(height: 24),
                              _buildDetailRow("Status", _requisition!.status.toUpperCase(), 
                                  statusTextColor: _getStatusColor(_requisition!.status)),
                            ],
                          ),
                        ),
                        if (_requisition!.items.isNotEmpty) ...[
                          SizedBox(height: 16),
                          _buildSectionCard(
                            title: "Items Requested",
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _requisition!.items.length,
                              separatorBuilder: (context, index) => Divider(height: 20),
                              itemBuilder: (context, index) {
                                final item = _requisition!.items[index];
                                return Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${index + 1}",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.itemName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            "Qty: ${item.quantity} ${item.unit}",
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                        if (_requisition!.remarks != null && _requisition!.remarks!.isNotEmpty) ...[
                          SizedBox(height: 16),
                          _buildSectionCard(
                            title: "Remarks",
                            child: Text(
                              _requisition!.remarks!,
                              style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
                            ),
                          ),
                        ],
                        if (_requisition!.approvedByName != null) ...[
                          SizedBox(height: 16),
                          _buildSectionCard(
                            title: "Approval Details",
                            child: Column(
                              children: [
                                _buildDetailRow("Approved By", _requisition!.approvedByName!),
                                if (_requisition!.approvedAt != null) ...[
                                  Divider(height: 24),
                                  _buildDetailRow("Approved At", _requisition!.approvedAt!),
                                ],
                              ],
                            ),
                          ),
                        ],
                        SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: _isLoading || _requisition == null || _requisition!.status.toLowerCase() != 'pending'
          ? null 
          : Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))
                ]
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showActionDialog(context, true),
                      child: Text("Approve"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showActionDialog(context, false),
                      child: Text("Reject"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFED1C24),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[600], letterSpacing: 0.5)),
          SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, Color? statusTextColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 110, child: Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14))),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14, 
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: statusTextColor ?? Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved': return Colors.green;
      case 'rejected': return Colors.red;
      case 'pending': return Colors.orange;
      default: return Colors.blue;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent': return Colors.red;
      case 'high': return Colors.orange;
      case 'normal': return Colors.blue;
      case 'low': return Colors.green;
      default: return Colors.grey;
    }
  }

  void _showActionDialog(BuildContext context, bool isApprove) {
    _remarksController.clear();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isApprove ? "Approve Requisition" : "Reject Requisition", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Are you sure you want to ${isApprove ? 'approve' : 'reject'} this requisition?"),
            if (!isApprove) ...[
              SizedBox(height: 16),
              TextField(
                controller: _remarksController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Enter remarks (optional)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel", style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              EasyLoading.show(status: isApprove ? 'Approving...' : 'Rejecting...');
              try {
                if (isApprove) {
                  await Provider.of<InternalRequisitionProvider>(context, listen: false)
                      .approveRequisition(widget.id);
                } else {
                  await Provider.of<InternalRequisitionProvider>(context, listen: false)
                      .rejectRequisition(widget.id, _remarksController.text.trim());
                }
                EasyLoading.dismiss();
                showToast("Requisition ${isApprove ? 'approved' : 'rejected'} successfully");
                Navigator.pop(context); // Go back to list
              } catch (e) {
                EasyLoading.dismiss();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
            child: Text("Confirm"),
            style: ElevatedButton.styleFrom(
              backgroundColor: isApprove ? Colors.green : Color(0xFFED1C24),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}
