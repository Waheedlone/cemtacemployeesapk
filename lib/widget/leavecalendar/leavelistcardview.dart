import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class LeaveListCardView extends StatelessWidget {
  final String name;
  final String avatar;
  final String post;
  final String leaveDays;

  LeaveListCardView(this.name, this.avatar, this.post, this.leaveDays);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                avatar,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                  Icon(Icons.person, size: 50, color: Colors.grey.shade300),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    post,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: HexColor('#ED1C24').withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    leaveDays,
                    style: TextStyle(
                        color: HexColor('#ED1C24'),
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Days',
                    style: TextStyle(
                        color: HexColor('#ED1C24'),
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
