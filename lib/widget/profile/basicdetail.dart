import 'package:cnattendance/provider/profileprovider.dart';
import 'package:cnattendance/widget/cartTitle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BasicDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context).profile;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Basic Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            CardTitle('Phone', profile.phone),
            CardTitle('Post', profile.post),
            CardTitle('Employee ID', profile.id.toString()),
            CardTitle('Date of birth', profile.dob),
            CardTitle('Gender', profile.gender),
            CardTitle('Address', profile.address),
          ],
        ),
      ),
    );
  }
}
