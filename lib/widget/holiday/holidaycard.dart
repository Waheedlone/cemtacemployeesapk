import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:hexcolor/hexcolor.dart';

class Holidaycard extends StatelessWidget {
  final int id;
  final String name;
  final String month;
  final String day;
  final String desc;

  Holidaycard(
      {required this.id,
      required this.name,
      required this.month,
      required this.day,
      required this.desc});

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
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: HexColor('#ED1C24').withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day,
                    style: TextStyle(
                        color: HexColor('#ED1C24'),
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(month, style: TextStyle(color: HexColor('#ED1C24'))),
                ],
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
                    parse(desc).body!.text,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
