import 'dart:io';

import 'package:cnattendance/provider/profileprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';

class Heading extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HeadingState();
}

class HeadingState extends State<Heading> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final profile = Provider.of<ProfileProvider>(context).profile;
    return WillPopScope(
      onWillPop: () async {
        return !isLoading;
      },
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                final ImagePicker _picker = ImagePicker();
                final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery, imageQuality: 50, maxWidth: 500);
                if (image != null) {
                  EasyLoading.show(
                      status: 'Changing....', maskType: EasyLoadingMaskType.black);
                  try {
                    setState(() {
                      isLoading = true;
                    });
                    await provider.updateProfile(
                        '', '', '', '', '', '', File(image.path));
                  } catch (e) {}
                  setState(() {
                    isLoading = false;
                  });
                  EasyLoading.dismiss(animation: true);
                }
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(75),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(profile.avatar),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HexColor('#ED1C24'),
                    ),
                    child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              profile.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              profile.email,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
