import 'package:cnattendance/provider/profileprovider.dart';
import 'package:cnattendance/screen/profile/editprofilescreen.dart';
import 'package:cnattendance/widget/profile/basicdetail.dart';
import 'package:cnattendance/widget/profile/bankdetail.dart';
import 'package:cnattendance/screen/profile/bankdetailsscreen.dart';
import 'package:cnattendance/screen/profile/officialdetailsscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cnattendance/widget/profile/heading.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  @override
  State<StatefulWidget> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  var initalState = true;

  @override
  void didChangeDependencies() {
    if (initalState) {
      getProfileDetail();
      initalState = false;
    }
    super.didChangeDependencies();
  }

  var isLoading = true;

  Future<String> getProfileDetail() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<ProfileProvider>(context, listen: false).getProfile();
    } catch (e) {
      return "loaded";
    }

    setState(() {
      isLoading = false;
    });
    return "loaded";
  }

  @override
  Widget build(BuildContext context) {
    final userProfile =
        Provider.of<ProfileProvider>(context, listen: false).profile;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: isLoading
                ? Center(
                    child: Container(
                        width: 20,
                        height: 20,
                        child: const CircularProgressIndicator(
                          color: Colors.black,
                        )))
                : Icon(Icons.edit_note),
            onPressed: () {
              isLoading
                  ? null
                  : Navigator.of(context)
                      .pushNamed(EditProfileScreen.routeName);
            },
          )
        ],
        title: const Text("Profile", style: TextStyle(color: Colors.black)),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return getProfileDetail();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Heading(),
                SizedBox(height: 20),
                if (userProfile.post != '') ...[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(OfficialDetailsScreen.routeName);
                    },
                    child: BasicDetail(),
                  ),
                  SizedBox(height: 20),
                ],
                if (userProfile.bankName != '') ...[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(BankDetailsScreen.routeName);
                    },
                    child: BankDetail(),
                  ),
                  SizedBox(height: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
