import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AttendanceCardView extends StatelessWidget {
  final int index;
  final String date;
  final String day;
  final String start;
  final String end;

  AttendanceCardView(this.index, this.date, this.day, this.start, this.end);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Date Badge Section
              Container(
                width: 70,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [HexColor("#00002B"), HexColor("#00002B").withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      date.split('-').last, // Getting the day number
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      day.substring(0, 3).toUpperCase(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Times Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTimeInfo("CHECK IN", start, Icons.login_rounded, Colors.green),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      _buildTimeInfo("CHECK OUT", end, Icons.logout_rounded, HexColor("#ED1C24")),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeInfo(String label, String time, IconData icon, Color color) {
    bool isNull = time == "-" || time.toLowerCase() == "null" || time.isEmpty;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          isNull ? "Not Set" : time,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: isNull ? Colors.grey : HexColor("#00002B"),
          ),
        ),
      ],
    );
  }
}

