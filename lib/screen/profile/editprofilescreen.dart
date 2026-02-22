import 'dart:io';

import 'package:cnattendance/provider/profileprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = '/editprofile';

  @override
  State<StatefulWidget> createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();

  int genderIndex = 0;
  bool isLoading = false;
  File? _image;
  final _personalForm = GlobalKey<FormState>();
  var initial = true;

  @override
  void didChangeDependencies() {
    if (initial) {
      final profile = Provider.of<ProfileProvider>(context).profile;
      _nameController.text = profile.name;
      _emailController.text = profile.email;
      _addressController.text = profile.address;
      _phoneController.text = profile.phone;
      _dobController.text = profile.dob;

      switch (profile.gender.toLowerCase()) {
        case 'male':
          genderIndex = 0;
          break;
        case 'female':
          genderIndex = 1;
          break;
        case 'others':
          genderIndex = 2;
          break;
        default:
          genderIndex = 0;
          break;
      }
      setState(() {});
      initial = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _personalForm.currentState?.dispose();
    super.dispose();
  }

  String getGender() {
    var gender = '';
    switch (genderIndex) {
      case 0:
        gender = 'male';
        break;
      case 1:
        gender = 'female';
        break;
      case 2:
        gender = 'others';
        break;
    }

    return gender;
  }

  bool validateField(String value) {
    if (value.isEmpty) {
      return false;
    }
    return true;
  }

  void validatePersonal() async {
    final value = _personalForm.currentState!.validate();

    if (value) {
      setState(() {
        isLoading = true;
        EasyLoading.show(status: "Updating...", maskType: EasyLoadingMaskType.black);
      });

      try {
        final response = await Provider.of<ProfileProvider>(context, listen: false).updateProfile(
          _nameController.text,
          _emailController.text,
          _addressController.text,
          _dobController.text,
          getGender(),
          _phoneController.text,
          _image ?? File(''),
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message)));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        setState(() {
          isLoading = false;
          EasyLoading.dismiss();
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !isLoading;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: HexColor('#070532'),
          title: Text('Edit Profile'),
        ),
        body: _buildPersonalForm(),
      ),
    );
  }

  Widget _buildPersonalForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _personalForm,
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null ? Icon(Icons.camera_alt, size: 50) : null,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              validator: (value) {
                if (!validateField(value!)) {
                  return "Empty Field";
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Fullname',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (!validateField(value!)) {
                  return "Empty Field";
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _addressController,
              keyboardType: TextInputType.streetAddress,
              validator: (value) {
                if (!validateField(value!)) {
                  return "Empty Field";
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Address',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (!validateField(value!)) {
                  return "Empty Field";
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_android),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _dobController,
              validator: (value) {
                if (!validateField(value!)) {
                  return "Empty Field";
                }
                return null;
              },
              keyboardType: TextInputType.datetime,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2100));

                if (pickedDate != null) {
                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                  setState(() {
                    _dobController.text = formattedDate;
                  });
                }
              },
              decoration: InputDecoration(
                hintText: 'Date of Birth',
                prefixIcon: Icon(Icons.calendar_month_sharp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gender',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 10),
                  ToggleSwitch(
                    minWidth: 100,
                    minHeight: 45,
                    initialLabelIndex: genderIndex,
                    totalSwitches: 3,
                    activeBgColor: [HexColor('#ED1C24')],
                    activeFgColor: Colors.white,
                    onToggle: (index) {
                      genderIndex = index!;
                    },
                    labels: const ['Male', 'Female', 'Other'],
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: HexColor('#070532'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(double.infinity, 55),
              ),
              onPressed: () {
                validatePersonal();
              },
              child: const Text(
                'Update Personal Details',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
