import 'package:cnattendance/provider/changepasswordprovider.dart';
import 'package:cnattendance/utils/navigationservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';

class ChangePasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ChangePasswordProvider(), child: ChangePassword());
  }
}

class ChangePassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool validateField(String value) {
    if (value.isEmpty) {
      return false;
    }
    return true;
  }

  void changePassword() async {
    final validate = _form.currentState!.validate();

    if (validate) {
      setState(() {
        EasyLoading.show(
            status: "Please wait..", maskType: EasyLoadingMaskType.clear);
      });

      try {
        final response =
            await Provider.of<ChangePasswordProvider>(context, listen: false)
                .changePassword(
                    _oldPasswordController.text,
                    _newPasswordController.text,
                    _confirmPasswordController.text);

        if (!mounted) {
          return;
        }
        if (response.statusCode == 200) {
          Navigator.pop(context);
          NavigationService().showSnackBar("Password Alert", response.message);
        } else {
          NavigationService().showSnackBar("Password Alert", response.message);
        }
      } catch (e) {
        NavigationService().showSnackBar("Password Alert", e.toString());
      }

      setState(() {
        EasyLoading.dismiss(animation: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Change Password', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              _buildPasswordField(
                controller: _oldPasswordController,
                label: 'Old Password',
                obscure: _obscureText,
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                controller: _newPasswordController,
                label: 'New Password',
                obscure: _obscureText,
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                obscure: _obscureText,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor('#ED1C24'),
                  minimumSize: const Size(double.infinity, 55),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: changePassword,
                child: const Text(
                  'Update Password',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: obscure,
          controller: controller,
          keyboardType: TextInputType.visiblePassword,
          style: const TextStyle(color: Colors.black, fontSize: 15),
          validator: (value) {
            if (!validateField(value!)) {
              return "Field can't be empty";
            }
            if (label == 'Confirm Password' || label == 'New Password') {
              if (_newPasswordController.text != _confirmPasswordController.text) {
                return "Passwords do not match";
              }
            }
            return null;
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline, color: Colors.redAccent, size: 20),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            suffixIcon: InkWell(
              onTap: _toggle,
              child: Icon(
                _obscureText ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                size: 14.0,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
