import 'package:cnattendance/data/source/network/model/shiftroster/ShiftRoster.dart';
import 'package:cnattendance/provider/shiftrosterprovider.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ShiftRosterScreen extends StatefulWidget {
  static const String routeName = '/shift-roster';

  @override
  State<ShiftRosterScreen> createState() => _ShiftRosterScreenState();
}

class _ShiftRosterScreenState extends State<ShiftRosterScreen>
    with SingleTickerProviderStateMixin {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  static const Color navyColor = Color(0xFF00002B);
  static const Color redColor = Color(0xFFED1C24);
  static const Color offColor = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    Future.delayed(Duration.zero, _fetchRoster);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _fetchRoster() {
    _animController.reset();
    Provider.of<ShiftRosterProvider>(context, listen: false)
        .fetchShiftRoster(month: selectedMonth, year: selectedYear)
        .then((_) => _animController.forward());
  }

  void _changeMonth(int delta) {
    setState(() {
      selectedMonth += delta;
      if (selectedMonth > 12) {
        selectedMonth = 1;
        selectedYear++;
      } else if (selectedMonth < 1) {
        selectedMonth = 12;
        selectedYear--;
      }
    });
    _fetchRoster();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShiftRosterProvider>(context);
    final shifts = provider.shifts;
    final workingDays = shifts.where((s) => !s.isWeeklyOff).length;
    final offDays = shifts.where((s) => s.isWeeklyOff).length;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: CustomScrollView(
        slivers: [
          // ─── Premium SliverAppBar ───────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: navyColor,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00002B), Color(0xFF0D0D4A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Shift Roster',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Month Navigator
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _NavBtn(icon: Icons.chevron_left, onTap: () => _changeMonth(-1)),
                            Column(
                              children: [
                                Text(
                                  DateFormat('MMMM').format(DateTime(selectedYear, selectedMonth)),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  '$selectedYear',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.55),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            _NavBtn(icon: Icons.chevron_right, onTap: () => _changeMonth(1)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Stats Row
                      if (!provider.isLoading && shifts.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              _StatChip(label: 'Total', value: '${shifts.length}', color: Colors.white),
                              const SizedBox(width: 8),
                              _StatChip(label: 'Working', value: '$workingDays', color: Colors.greenAccent),
                              const SizedBox(width: 8),
                              _StatChip(label: 'Days Off', value: '$offDays', color: Colors.redAccent.shade100),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              centerTitle: true,
            ),
          ),

          // ─── Body ────────────────────────────────────────────────────────
          if (provider.isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: redColor),
              ),
            )
          else if (shifts.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text(
                      'No shifts assigned',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
                    ),
                    Text(
                      'for ${DateFormat('MMMM yyyy').format(DateTime(selectedYear, selectedMonth))}',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // Section header: week separator
                    final shift = shifts[index];
                    final isToday = shift.date == today;
                    final isFirst = index == 0;
                    final prevShift = isFirst ? null : shifts[index - 1];

                    // Add week label before Monday (or first entry)
                    final showWeekLabel = isFirst ||
                        (prevShift != null &&
                            _weekNumber(shift.date) != _weekNumber(prevShift.date));

                    return FadeTransition(
                      opacity: _fadeAnim,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showWeekLabel) _buildWeekLabel(shift.date, index),
                          _buildShiftCard(shift, isToday),
                        ],
                      ),
                    );
                  },
                  childCount: shifts.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  int _weekNumber(String dateStr) {
    try {
      final d = DateTime.parse(dateStr);
      return ((d.day - 1) ~/ 7) + 1;
    } catch (_) {
      return 0;
    }
  }

  Widget _buildWeekLabel(String dateStr, int index) {
    try {
      final d = DateTime.parse(dateStr);
      final weekNum = ((d.day - 1) ~/ 7) + 1;
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 6, left: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: navyColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Week $weekNum',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: Divider(color: Colors.grey.shade300)),
          ],
        ),
      );
    } catch (_) {
      return const SizedBox.shrink();
    }
  }

  Widget _buildShiftCard(ShiftRosterData shift, bool isToday) {
    final isOff = shift.isWeeklyOff;
    DateTime? dateObj;
    try {
      dateObj = DateTime.parse(shift.date);
    } catch (_) {}

    final dayNum = dateObj != null ? DateFormat('dd').format(dateObj) : '--';
    final dayName = shift.day.isNotEmpty
        ? shift.day.substring(0, 3).toUpperCase()
        : (dateObj != null ? DateFormat('EEE').format(dateObj).toUpperCase() : '---');

    final hasTime = (shift.openingTime != null && shift.openingTime!.isNotEmpty) ||
        (shift.closingTime != null && shift.closingTime!.isNotEmpty);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: isToday
            ? Border.all(color: redColor, width: 2)
            : Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: isToday
                ? redColor.withOpacity(0.12)
                : Colors.black.withOpacity(0.05),
            blurRadius: isToday ? 14 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // ── Date Badge ──────────────────────────────────
            Container(
              width: 54,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isOff
                    ? const Color(0xFFF1F5F9)
                    : (isToday ? redColor : navyColor),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayNum,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: isOff ? offColor : Colors.white,
                    ),
                  ),
                  Text(
                    dayName,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isOff ? offColor.withOpacity(0.7) : Colors.white.withOpacity(0.8),
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // ── Shift Info ──────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isOff ? 'Weekly Off' : shift.shiftName,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: isOff ? offColor : navyColor,
                          ),
                        ),
                      ),
                      if (isToday)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: redColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'TODAY',
                            style: TextStyle(
                              color: redColor,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (!isOff && hasTime) ...[
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 13, color: Colors.grey.shade400),
                        const SizedBox(width: 4),
                        Text(
                          '${shift.openingTime ?? "--"} – ${shift.closingTime ?? "--"}',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ] else if (!isOff) ...[
                    Row(
                      children: [
                        Icon(Icons.work_outline_rounded, size: 13, color: Colors.grey.shade400),
                        const SizedBox(width: 4),
                        Text(
                          'Regular hours apply',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Icon(Icons.weekend_outlined, size: 13, color: offColor.withOpacity(0.5)),
                        const SizedBox(width: 4),
                        Text(
                          shift.isCustomAssignment ? 'Custom assignment' : 'Scheduled rest day',
                          style: TextStyle(
                            color: offColor.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // ── Status Pill ─────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isOff
                    ? const Color(0xFFF1F5F9)
                    : const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                isOff ? 'OFF' : 'ON',
                style: TextStyle(
                  color: isOff ? offColor : const Color(0xFF16A34A),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper Widgets ──────────────────────────────────────────────────────────

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.55),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
