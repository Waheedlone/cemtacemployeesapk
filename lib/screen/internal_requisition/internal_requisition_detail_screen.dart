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
          ? Center(child: CircularProgressIndicator(color: Color(0xFFED1C24)))
          : _requisition == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Failed to load detail',
                          style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderCard(),
                        SizedBox(height: 20),
                        _buildSectionCard(
                          title: "Information",
                          icon: Icons.info_outline,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow("Request No", _requisition!.requestNo, isBold: true),
                              _buildDivider(),
                              _buildDetailRow("Department", _requisition!.department),
                              _buildDivider(),
                              _buildDetailRow("Requester", _requisition!.requestedByName),
                              _buildDivider(),
                              _buildDetailRow("Request Date", _requisition!.requestDate),
                              _buildDivider(),
                              _buildDetailRow("Priority", _requisition!.priority.toUpperCase(),
                                  statusTextColor: _getPriorityColor(_requisition!.priority)),
                              _buildDivider(),
                              _buildDetailRow("Status", _requisition!.status.toUpperCase(), 
                                  statusTextColor: _getStatusColor(_requisition!.status)),
                            ],
                          ),
                        ),
                        if (_requisition!.items.isNotEmpty) ...[
                          SizedBox(height: 20),
                          _buildSectionCard(
                            title: "Items Requested",
                            icon: Icons.list_alt_outlined,
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _requisition!.items.length,
                              separatorBuilder: (context, index) => _buildDivider(),
                              itemBuilder: (context, index) {
                                final item = _requisition!.items[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFED1C24).withOpacity(0.08),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "${index + 1}",
                                            style: TextStyle(
                                              color: Color(0xFFED1C24),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
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
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: Color(0xFF1A1C1E),
                                              ),
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              "Quantity: ${item.quantity} ${item.unit}",
                                              style: TextStyle(
                                                color: Color(0xFF74777F),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        if (_requisition!.remarks != null && _requisition!.remarks!.isNotEmpty) ...[
                          SizedBox(height: 20),
                          _buildSectionCard(
                            title: "Remarks",
                            icon: Icons.chat_bubble_outline,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Text(
                                _requisition!.remarks!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF44474E),
                                  height: 1.5,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                        ],
                        if (_requisition!.approvedByName != null) ...[
                          SizedBox(height: 20),
                          _buildSectionCard(
                            title: "Approval Details",
                            icon: Icons.verified_user_outlined,
                            child: Column(
                              children: [
                                _buildDetailRow("Approved By", _requisition!.approvedByName!),
                                if (_requisition!.approvedAt != null) ...[
                                  _buildDivider(),
                                  _buildDetailRow("Approved At", _requisition!.approvedAt!),
                                ],
                              ],
                            ),
                          ),
                        ],
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: _isLoading || _requisition == null || _requisition!.status.toLowerCase() != 'pending'
          ? null 
          : Container(
              padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: Offset(0, -5))
                ],
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showActionDialog(context, false),
                      child: Text("Reject"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFFED1C24),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(color: Color(0xFFED1C24), width: 1.5),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showActionDialog(context, true),
                      child: Text("Approve"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFED1C24),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 4,
                        shadowColor: Color(0xFFED1C24).withOpacity(0.4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFED1C24), Color(0xFFB51218)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFED1C24).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Internal Requisition",
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _requisition!.priority.toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            _requisition!.requestNo,
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.person_pin_outlined, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text(
                _requisition!.requestedByName,
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: Offset(0, 5))
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Color(0xFFED1C24)),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1C1E),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, Color? statusTextColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: Color(0xFF74777F), fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14, 
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: statusTextColor ?? Color(0xFF1A1C1E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(height: 1, color: Colors.grey[100], thickness: 1),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved': return Colors.green[700]!;
      case 'rejected': return Color(0xFFED1C24);
      case 'pending': return Colors.orange[700]!;
      default: return Colors.blue[700]!;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent': return Color(0xFFED1C24);
      case 'high': return Colors.orange[800]!;
      case 'normal': return Colors.blue[700]!;
      case 'low': return Colors.green[700]!;
      default: return Colors.grey[600]!;
    }
  }

  void _showActionDialog(BuildContext context, bool isApprove) {
    _remarksController.clear();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isApprove ? Colors.green : Color(0xFFED1C24)).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isApprove ? Icons.check_circle_outline : Icons.cancel_outlined,
                color: isApprove ? Colors.green : Color(0xFFED1C24),
                size: 40,
              ),
            ),
            SizedBox(height: 16),
            Text(
              isApprove ? "Approve Requisition" : "Reject Requisition",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Are you sure you want to ${isApprove ? 'approve' : 'reject'} this internal requisition?",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF44474E), fontSize: 14),
            ),
            if (!isApprove) ...[
              SizedBox(height: 20),
              TextField(
                controller: _remarksController,
                maxLines: 3,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Enter rejection reason...",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Color(0xFFED1C24)),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ],
          ],
        ),
        actionsPadding: EdgeInsets.fromLTRB(16, 0, 16, 20),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text("Go Back", style: TextStyle(color: Color(0xFF74777F), fontWeight: FontWeight.w600)),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    if (!isApprove && _remarksController.text.trim().isEmpty) {
                      showToast("Please enter a reason for rejection");
                      return;
                    }
                    Navigator.pop(ctx);
                    EasyLoading.show(status: isApprove ? 'Processing...' : 'Rejecting...');
                    try {
                      if (isApprove) {
                        await Provider.of<InternalRequisitionProvider>(context, listen: false)
                            .approveRequisition(widget.id);
                      } else {
                        await Provider.of<InternalRequisitionProvider>(context, listen: false)
                            .rejectRequisition(widget.id, _remarksController.text.trim());
                      }
                      EasyLoading.dismiss();
                      showToast("Successfully ${isApprove ? 'approved' : 'rejected'}");
                      Navigator.pop(context); // Go back to list
                    } catch (e) {
                      EasyLoading.dismiss();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                          backgroundColor: Color(0xFFED1C24),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    }
                  },
                  child: Text("Confirm"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isApprove ? Colors.green : Color(0xFFED1C24),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
