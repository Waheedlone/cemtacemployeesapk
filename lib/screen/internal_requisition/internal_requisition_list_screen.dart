import 'package:cnattendance/provider/internal_requisition_provider.dart';
import 'package:cnattendance/provider/purchase_requisition_provider.dart';
import 'package:cnattendance/screen/internal_requisition/create_requisition_screen.dart';
import 'package:cnattendance/screen/internal_requisition/internal_requisition_detail_screen.dart';
import 'package:cnattendance/screen/internal_requisition/purchase_requisition_detail_screen.dart';
import 'package:cnattendance/widget/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InternalRequisitionListScreen extends StatefulWidget {
  @override
  _InternalRequisitionListScreenState createState() =>
      _InternalRequisitionListScreenState();
}

class _InternalRequisitionListScreenState
    extends State<InternalRequisitionListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  Future<void> _refreshData() async {
    final irProvider = Provider.of<InternalRequisitionProvider>(context, listen: false);
    final prProvider = Provider.of<PurchaseRequisitionProvider>(context, listen: false);
    
    await Future.wait([
      irProvider.fetchMyRequisitions(),
      irProvider.fetchRequisitions(),
      prProvider.fetchForApproval(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: AppBar(
        title: Text(
          'IMS Management',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Color(0xFFED1C24),
          unselectedLabelColor: Colors.grey,
          indicatorColor: Color(0xFFED1C24),
          tabs: [
            Tab(text: 'My IRs'),
            Tab(text: 'IR Approvals'),
            Tab(text: 'PR Approvals'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMyRequisitionsTab(),
          _buildForApprovalTab(),
          _buildPrApprovalTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateRequisitionScreen()),
          ).then((_) => _refreshData());
        },
        backgroundColor: Color(0xFFED1C24),
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('New IR', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildMyRequisitionsTab() {
    return Consumer<InternalRequisitionProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.myRequisitions.isEmpty) {
          return ShimmerLoading(child: ShimmerLoading.buildListShimmer(itemCount: 8));
        }
        if (provider.myRequisitions.isEmpty) return _buildEmptyState('No internal requests created.');
        return RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: provider.myRequisitions.length,
            itemBuilder: (context, index) => _buildIRCard(provider.myRequisitions[index]),
          ),
        );
      },
    );
  }

  Widget _buildForApprovalTab() {
    return Consumer<InternalRequisitionProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.requisitions.isEmpty) {
          return ShimmerLoading(child: ShimmerLoading.buildListShimmer(itemCount: 8));
        }
        if (provider.requisitions.isEmpty) return _buildEmptyState('No IRs pending your approval.');
        return RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: provider.requisitions.length,
            itemBuilder: (context, index) => _buildIRCard(provider.requisitions[index]),
          ),
        );
      },
    );
  }

  Widget _buildPrApprovalTab() {
    return Consumer<PurchaseRequisitionProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.requisitions.isEmpty) {
          return ShimmerLoading(child: ShimmerLoading.buildListShimmer(itemCount: 8));
        }
        if (provider.requisitions.isEmpty) return _buildEmptyState('No PRs pending your approval.');
        return RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: provider.requisitions.length,
            itemBuilder: (context, index) => _buildPRCard(provider.requisitions[index]),
          ),
        );
      },
    );
  }

  Widget _buildIRCard(dynamic requisition) {
    return _buildBaseCard(
      title: requisition.requestNo,
      subtitle: requisition.department,
      date: requisition.requestDate,
      status: requisition.status,
      extra: requisition.warehouseName ?? 'No Warehouse',
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => InternalRequisitionDetailScreen(id: requisition.id)))
            .then((_) => _refreshData());
      },
    );
  }

  Widget _buildPRCard(dynamic requisition) {
    return _buildBaseCard(
      title: requisition.prNumber,
      subtitle: '${requisition.requestedBy} • ${requisition.department ?? 'N/A'}',
      date: requisition.requisitionDate,
      status: requisition.status,
      extra: 'Level: ${requisition.currentLevel.replaceAll('_', ' ')}',
      color: Colors.blue[600],
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PurchaseRequisitionDetailScreen(id: requisition.id)))
            .then((_) => _refreshData());
      },
    );
  }

  Widget _buildBaseCard({required String title, required String subtitle, required String date, required String status, required String extra, required VoidCallback onTap, Color? color}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
                  _buildStatusBadge(status),
                ],
              ),
              SizedBox(height: 8),
              Text(subtitle, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(date, style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Spacer(),
                  Text(extra, style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending': color = Colors.orange; break;
      case 'approved': color = Colors.green; break;
      case 'issued': color = Colors.blue; break;
      case 'rejected': color = Colors.red; break;
      default: color = Colors.grey;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(status.toUpperCase(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(message, style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}
