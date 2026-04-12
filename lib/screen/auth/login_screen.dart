import 'package:cnattendance/model/auth.dart';
import 'package:cnattendance/screen/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cnattendance/screen/auth/face_registration_screen.dart';
import 'package:cnattendance/utils/firestore_service.dart';
import 'package:cnattendance/provider/prefprovider.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  @override
  State<StatefulWidget> createState() => loginScreenState();
}

class loginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _form = GlobalKey<FormState>();

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  var _isLoading = false;

  bool validateField(String value) {
    if (value.isEmpty) {
      return false;
    }
    return true;
  }

  validateValue() {
    final value = _form.currentState!.validate();

    if (value) {
      loginUser();
    }
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
      EasyLoading.show(
          status: 'Signing in..', maskType: EasyLoadingMaskType.black);
    });

    try {
      final response = await Provider.of<Auth>(context, listen: false)
          .login(_usernameController.text, _passwordController.text);

      if (!mounted) return;

      final firestoreService = FirestoreService();
      await firestoreService.saveCredentials(_usernameController.text, _passwordController.text);
      
      final faceData = await firestoreService.getUserFace(_usernameController.text);

      if (faceData == null) {
        // Redirect to Face Registration if not registered
        Provider.of<PrefProvider>(context, listen: false).saveFaceRegistered(false);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => FaceRegistrationScreen(
            username: _usernameController.text,
            password: _passwordController.text,
          ),
        ));
        return;
      }

      Provider.of<PrefProvider>(context, listen: false).saveFaceRegistered(true);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.message)));

      Navigator.of(context)
          .pushNamedAndRemoveUntil(DashboardScreen.routeName, (route) => false);
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }

    setState(() {
      _isLoading = false;
      EasyLoading.dismiss(animation: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 450),
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _form,
              child: IgnorePointer(
                ignoring: _isLoading,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 50),
                    Center(
                      child: SizedBox(
                        width: 180,
                        height: 180,
                        child: Image.asset('assets/icons/cemtac.png'),
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: HexColor('#00002B'),
                      ),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (!validateField(value!)) {
                          return "Empty Field";
                        }
                        return null;
                      },
                      controller: _usernameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person, color: HexColor('#00002B').withOpacity(0.6)),
                        labelText: 'Username',
                        labelStyle: TextStyle(color: HexColor('#00002B').withOpacity(0.6)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: HexColor('#ED1C24'), width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      obscureText: _obscureText,
                      validator: (value) {
                        if (!validateField(value!)) {
                          return "Empty Field";
                        }
                        return null;
                      },
                      controller: _passwordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: HexColor('#00002B').withOpacity(0.6)),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: HexColor('#00002B').withOpacity(0.6)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: HexColor('#ED1C24'), width: 2),
                        ),
                        suffixIcon: InkWell(
                          onTap: _toggle,
                          child: Icon(
                            _obscureText
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeSlash,
                            size: 15.0,
                            color: HexColor('#00002B').withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor('#ED1C24'),
                        minimumSize: Size(double.infinity, 55),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        validateValue();
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 25),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          openBrowserTab();
                        },
                        child: Text(
                          'Forget Password?',
                          style: TextStyle(
                            color: HexColor('#00002B').withOpacity(0.6),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  openBrowserTab() async {
    await FlutterWebBrowser.openWebPage(
      url: "https://attendance.cyclonenepal.com/password/reset",
    );
  }
}
