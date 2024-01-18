import 'package:eduventure/screens/login_screen.dart';
import 'package:eduventure/utils/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _emailController = TextEditingController();
  bool isDone = false;

  Future<void> _resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
      setState(() {
        isDone = false;
      });
      // Show success message or navigate to a success screen
    } catch (e) {
      // Handle any errors that occur during the password reset process
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('error: $e'),
        ),
      );
      setState(() {
        isDone = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: colorWhite,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorBlack),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize
              ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 0),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Forgot password!!!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: colorPrimary,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Reset your password using your registered email",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  Form(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 52,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: gray02,
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Center(
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: "Enter your Email",
                                  hintStyle: TextStyle(color: colorPrimary),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_emailController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Enter your email')),
                                  );
                                } else {
                                  setState(() {
                                    isDone = true;
                                  });
                                  await _resetPassword();
                                }
                              },
                              style: ElevatedButton.styleFrom(shape: StadiumBorder(), backgroundColor: colorPrimary, elevation: 0),
                              child: isDone
                                  ? CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorWhite,
                              )
                                  : Text(
                                "Send password link",
                                style: TextStyle(fontWeight: FontWeight.bold, color: colorWhite),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                          child: Text(
                            "back to login",
                            style: TextStyle(color: colorPrimary, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
