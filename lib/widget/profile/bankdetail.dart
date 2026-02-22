import 'package:cnattendance/provider/profileprovider.dart';
import 'package:cnattendance/widget/cartTitle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BankDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context, listen: false).profile;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bank Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            CardTitle('Bank name', profile.bankName),
            CardTitle('Account Number', profile.bankNumber),
            CardTitle('Joined Date', profile.joinedDate),
          ],
        ),
      ),
    );
  }
}
