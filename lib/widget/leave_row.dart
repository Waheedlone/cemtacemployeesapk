import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class LeaveRow extends StatelessWidget {
  final int id;
  final String name;
  final int allocated;
  final int used;

  LeaveRow(this.id, this.name, this.used, this.allocated);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.card_travel, color: HexColor('#ED1C24'), size: 30),
            SizedBox(height: 15),
            Text(
              name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              '$used/$allocated',
              style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
