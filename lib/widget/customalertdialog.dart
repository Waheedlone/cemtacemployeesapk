import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;

  CustomAlertDialog(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, color: HexColor('#ED1C24'), size: 80),
          SizedBox(
            height: 20,
          ),
          Text(
            textAlign: TextAlign.center,
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor('#ED1C24'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Close", style: TextStyle(color: Colors.white, fontSize: 16))),
          )
        ],
      ),
    );
  }
}
