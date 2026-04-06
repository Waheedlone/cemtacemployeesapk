import 'package:cnattendance/provider/internal_requisition_provider.dart';
import 'package:cnattendance/screen/internal_requisition/internal_requisition_detail_screen.dart';
import 'package:cnattendance/widget/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class InternalRequisitionListScreen extends StatefulWidget {
  @override
  _InternalRequisitionListScreenState createState() =>
      _InternalRequisitionListScreenState();
}

class _InternalRequisitionListScreenState
    extends State<InternalRequisitionListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InternalRequisitionProvider>(context, listen: false)
          .fetchRequisitions();
    });
  }

  Future<void> _refreshData() async {
    await Provider.of<InternalRequisitionProvider>(context, listen: false)
        .fetchRequisitions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: AppBar(
        title: Text(
          'Internal Requisitions',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<InternalRequisitionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return ShimmerLoading(
              child: ShimmerLoading.buildListShimmer(itemCount: 8),
            );
          }

          if (provider.requisitions.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.assignment_outlined,
                            size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No pending requisitions found.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: provider.requisitions.length,
              itemBuilder: (context, index) {
                final requisition = provider.requisitions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              InternalRequisitionDetailScreen(id: requisition.id),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 4,
                                height: 100,
                                color: _getPriorityColor(requisition.priority),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFED1C24).withOpacity(0.12),
                                          Color(0xFFED1C24).withOpacity(0.05),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(Icons.inventory_2_outlined,
                                        color: Color(0xFFED1C24), size: 26),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              requisition.requestNo,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Color(0xFF1A1C1E),
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: _getPriorityColor(requisition.priority).withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                requisition.priority.toUpperCase(),
                                                style: TextStyle(
                                                  color: _getPriorityColor(requisition.priority),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          requisition.department,
                                          style: TextStyle(
                                            color: Color(0xFF44474E),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          "Requested by: ${requisition.requestedByName}",
                                          style: TextStyle(
                                            color: Color(0xFF74777F),
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today_outlined,
                                                size: 14, color: Color(0xFF74777F)),
                                            SizedBox(width: 4),
                                            Text(
                                              requisition.requestDate,
                                              style: TextStyle(
                                                color: Color(0xFF74777F),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              "View Details",
                                              style: TextStyle(
                                                color: Color(0xFFED1C24),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Icon(Icons.chevron_right, size: 16, color: Color(0xFFED1C24)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'normal':
        return Colors.blue;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
