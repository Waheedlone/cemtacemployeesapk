import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CardOverView extends StatelessWidget{
  final String type;
  final String value;
  final IconData icon;

  CardOverView({required this.type, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: HexColor('#ED1C24'),
            ),
            SizedBox(height: 8),
            Text(
              type,
              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

}