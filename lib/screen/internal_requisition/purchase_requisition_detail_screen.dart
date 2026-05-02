import 'package:cnattendance/model/purchase_requisition.dart';
import 'package:cnattendance/provider/purchase_requisition_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PurchaseRequisitionDetailScreen extends StatefulWidget {
  final int id;

  const PurchaseRequisitionDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  _PurchaseRequisitionDetailScreenState createState() => _PurchaseRequisitionDetailScreenState();
}

class _PurchaseRequisitionDetailScreenState extends State<PurchaseRequisitionDetailScreen> {
  PurchaseRequisition? _requisition;
  bool _isLoading = true;
  final TextEditingController _remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    try {
      final requisition = await Provider.of<PurchaseRequisitionProvider>(context, listen: false)
          .fetchDetail(widget.id);
      if (mounted) {
        setState(() {
          _requisition = requisition;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: AppBar(
        title: Text('Purchase Req Detail', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _requisition == null
              ? Center(child: Text('Not found'))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildHeaderCard(),
                      SizedBox(height: 16),
                      _buildInfoCard(),
                      SizedBox(height: 16),
                      _buildItemsCard(),
                      SizedBox(height: 16),
                      _buildHistoryCard(),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
      bottomNavigationBar: _requisition?.canApprove == true
          ? _buildActionButtons()
          : null,
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue[700]!, Colors.blue[900]!]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_requisition!.prNumber, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Row(
            children: [
              _buildBadge(_requisition!.status.toUpperCase(), Colors.white.withOpacity(0.2)),
              SizedBox(width: 8),
              _buildBadge(_requisition!.currentLevel.replaceAll('_', ' ').toUpperCase(), Colors.white.withOpacity(0.1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInfoCard() {
    return _buildSection('General Information', Icons.info_outline, [
      _buildRow('Requested By', _requisition!.requestedBy),
      _buildRow('Date', _requisition!.requisitionDate),
      _buildRow('Warehouse', _requisition!.warehouse ?? 'N/A'),
      _buildRow('Purpose', _requisition!.purpose ?? 'N/A'),
    ]);
  }

  Widget _buildItemsCard() {
    return _buildSection('Requested Items', Icons.shopping_cart_outlined, [
      ..._requisition!.items.map((item) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.materialName, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(item.materialCode, style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            )),
            Text('${item.quantity} ${item.unit}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          ],
        ),
      )).toList(),
    ]);
  }

  Widget _buildHistoryCard() {
    if (_requisition!.history.isEmpty) return SizedBox();
    return _buildSection('Approval History', Icons.history, [
      ..._requisition!.history.map((h) => Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Icon(Icons.check_circle, size: 16, color: Colors.green),
                Container(width: 2, height: 30, color: Colors.grey[200]),
              ],
            ),
            SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${h.actionBy} (${h.level.replaceAll('_', ' ')})', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(h.action.toUpperCase(), style: TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold)),
                if (h.remarks != null) Text(h.remarks!, style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                Text(h.date, style: TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            )),
          ],
        ),
      )).toList(),
    ]);
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, size: 18, color: Colors.blue), SizedBox(width: 8), Text(title, style: TextStyle(fontWeight: FontWeight.bold))]),
          Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Row(
        children: [
          Expanded(child: OutlinedButton(
            onPressed: () => _showActionDialog('reject'),
            child: Text('Reject'),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.red, padding: EdgeInsets.symmetric(vertical: 16), side: BorderSide(color: Colors.red)),
          )),
          SizedBox(width: 16),
          Expanded(child: ElevatedButton(
            onPressed: () => _showActionDialog('approve'),
            child: Text('Approve'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: EdgeInsets.symmetric(vertical: 16)),
          )),
        ],
      ),
    );
  }

  void _showActionDialog(String action) {
    _remarksController.clear();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: Text('${action[0].toUpperCase()}${action.substring(1)} Requisition'),
      content: TextField(
        controller: _remarksController,
        maxLines: 3,
        decoration: InputDecoration(hintText: 'Remarks (Optional)', border: OutlineInputBorder()),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(ctx);
            EasyLoading.show(status: 'Processing...');
            try {
              await Provider.of<PurchaseRequisitionProvider>(context, listen: false)
                  .takeAction(widget.id, action, _remarksController.text);
              EasyLoading.dismiss();
              Navigator.pop(context);
            } catch (e) {
              EasyLoading.dismiss();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
            }
          },
          child: Text('Confirm'),
        ),
      ],
    ));
  }
}
