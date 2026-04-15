import 'package:cnattendance/utils/responsive.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:cnattendance/widget/headerprofile.dart';
import 'package:cnattendance/widget/leavescreen/issueleavesheet.dart';
import 'package:cnattendance/widget/leavescreen/leave_list_dashboard.dart';
import 'package:cnattendance/widget/leavescreen/leave_list_detail_dashboard.dart';
import 'package:cnattendance/widget/leavescreen/leavetypefilter.dart';
import 'package:cnattendance/widget/leavescreen/toggleleavetime.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cnattendance/provider/leaveprovider.dart';
import 'package:cnattendance/model/leave.dart';
import 'package:hexcolor/hexcolor.dart';

class LeaveScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LeaveScreenState();
}

class LeaveScreenState extends State<LeaveScreen> {
  var init = true;
  var isVisible = false;

  @override
  void didChangeDependencies() {
    if (init) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        initialState();
      });
      init = false;
    }
    super.didChangeDependencies();
  }

  Future<String> initialState() async {
    try {
      final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);
      final leaveData = await leaveProvider.getLeaveType();

      if (!mounted) return "Loaded";
      if (leaveData.status == false) {
        showToast(leaveData.message);
      }

      getLeaveDetailList();
      return "Loaded";
    } catch (e) {
      if (mounted) showToast(e.toString());
      return "Error";
    }
  }

  void getLeaveDetailList() async {
    try {
      final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);
      final detailResponse = await leaveProvider.getLeaveTypeDetail();

      if (!mounted) return;
      if (detailResponse.status == true) {
        setState(() => isVisible = true);
      } else {
        showToast(detailResponse.message);
      }
    } catch (e) {
      if (mounted) showToast(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => initialState(),
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: Responsive.isMobile(context) ? 20 : 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderProfile(),
                    const SizedBox(height: 20),
                    const Text('Leave',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    LeaveListDashboard(),
                    const SizedBox(height: 24),

                    // ── Remaining Leave Balance ──────────────────────────
                    _LeaveBalanceSection(),

                    const SizedBox(height: 20),
                    Align(
                      alignment: Responsive.isMobile(context)
                          ? Alignment.center
                          : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: Responsive.isMobile(context)
                                ? double.infinity
                                : 300),
                        child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              useRootNavigator: true,
                              builder: (context) => IssueLeaveSheet(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor('#ED1C24'),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Apply for Leave',
                            style: TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text("Recent Leave Activity",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    if (isVisible)
                      LeaveListdetailDashboard()
                    else
                      const Center(child: CircularProgressIndicator()),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Remaining Leave Balance Section
// ─────────────────────────────────────────────────────────────────────────────

class _LeaveBalanceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final leaveList = Provider.of<LeaveProvider>(context).leaveList;
    if (leaveList.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: HexColor('#ED1C24'),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Remaining Leave Balance',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF00002B),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Cards grid
        GridView.builder(
          itemCount: leaveList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisExtent: 130,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) =>
              _BalanceCard(leave: leaveList[index]),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final Leave leave;
  const _BalanceCard({required this.leave});

  @override
  Widget build(BuildContext context) {
    final remaining = leave.total - leave.allocated;
    final ratio =
        leave.total > 0 ? (remaining / leave.total).clamp(0.0, 1.0) : 0.0;

    // Traffic-light colour based on remaining ratio
    final Color accentColor = ratio > 0.5
        ? const Color(0xFF16A34A) // green  — healthy
        : ratio > 0.2
            ? const Color(0xFFF59E0B) // amber  — low
            : const Color(0xFFED1C24); // red    — critical

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.09),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Leave type name + colour dot
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    color: accentColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  leave.name,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Remaining count — big
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$remaining',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: accentColor,
                  height: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 4),
                child: Text(
                  'left',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: accentColor.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),

          // Progress bar + legend
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: ratio,
                  backgroundColor: accentColor.withOpacity(0.12),
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                  minHeight: 5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${leave.allocated} used / ${leave.total} total',
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF94A3B8),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
