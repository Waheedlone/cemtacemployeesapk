import 'package:cnattendance/model/gatepass.dart';
import 'package:cnattendance/provider/gatepassprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GatePassDetailScreen extends StatefulWidget {
  final GatePass gatePass;

  const GatePassDetailScreen({required this.gatePass});

  @override
  State<GatePassDetailScreen> createState() => _GatePassDetailScreenState();
}

class _GatePassDetailScreenState extends State<GatePassDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GatePassProvider>(context, listen: false)
          .fetchGatePassDetails(widget.gatePass.id);
    });
  }

  Widget _buildRow(String label, String? value, {bool isStatus = false, Color? statusColor}) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          if (isStatus)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: (statusColor ?? Colors.blue).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                value,
                style: TextStyle(
                  color: statusColor ?? Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            )
          else
            Text(value,
                style: const TextStyle(
                    color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Divider(color: Colors.grey[100], thickness: 1),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case '1':
        return Colors.green;
      case 'pending':
      case '0':
        return Colors.orange;
      case 'rejected':
      case '2':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Gate Pass Detail", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<GatePassProvider>(
        builder: (context, provider, child) {
          final gatePass = provider.selectedGatePass ?? widget.gatePass;
          final statusColor = _getStatusColor(gatePass.status);

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRow("Purpose / Reason", gatePass.reason),
                    _buildRow("Exit Time", gatePass.time),
                    _buildRow("Status", gatePass.statusLabel ?? gatePass.status,
                        isStatus: true, statusColor: statusColor),
                    _buildRow("GP Number", gatePass.gpNumber),
                    _buildRow("Remarks", gatePass.remarks),
                    _buildRow("Approved At", gatePass.approvedAt),
                    _buildRow("Approved By", gatePass.approvedByName),
                    _buildRow("Department", gatePass.departmentName),
                  ],
                ),
              ),
              if (provider.isLoading)
                const Center(
                  child: CircularProgressIndicator(color: Color(0xFFED1C24)),
                ),
            ],
          );
        },
      ),
    );
  }
}

