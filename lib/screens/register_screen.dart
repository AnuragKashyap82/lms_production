import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/resource/auth_methods.dart';
import 'package:eduventure/screens/home_page.dart';
import 'package:eduventure/screens/login_screen.dart';
import 'package:eduventure/screens/verify_email_screen.dart';
import 'package:eduventure/utils/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/colors.dart';

class RegisterScreen extends StatefulWidget {
  final String email;
  final String uniqueId;
  final String userType;

  const RegisterScreen({
    Key? key,
    required this.email,
    required this.uniqueId,
    required this.userType,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();

  bool _isPasswordVisible = true;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _cPasswordController.dispose();
  }

  void sendVerificationEmail() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VerifyEmailScreen()),
      );
    }
  }

  void registerAlreadyUniqueId() async {
    String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
    String tDate = DateFormat("HH:mm").format(DateTime.now());
    try {
      Map<String, dynamic> data = {
        "name": _nameController.text,
        "email": widget.email,
        "uniqueId": widget.uniqueId,
        "userType": widget.userType,
        "dateTime": "$date  $tDate",
        'uid': FirebaseAuth.instance.currentUser?.uid,
      };
      DocumentReference reference = FirebaseFirestore.instance
          .collection("alreadyRegUniqueId")
          .doc(widget.uniqueId);
      await reference.set(data).whenComplete(() {
        if(widget.email == "test@user.com"){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }else{
          sendVerificationEmail();
        }

      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(e.toString(), context);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    await AuthMethods().signUpUser(
      email: widget.email,
      password: _passwordController.text,
      studentId: widget.uniqueId,
      name: _nameController.text,
      userType: widget.userType,
      cPassword: _cPasswordController.text,
    ).then((value) {
      if (value != 'Success') {
        showSnackBar(value, context);
      } else {
        registerAlreadyUniqueId();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController =
    TextEditingController(text: widget.email);

    return SafeArea(
      child: Scaffold(
        backgroundColor: colorWhite,
        body: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize
              ? EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 0),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  Text(
                    "Create an Account",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colorPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Create an account to be able to learn everything online and boost your knowledge",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 16,
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
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                controller: _nameController,
                                decoration: InputDecoration(
                                  hintText: "Enter your Name",
                                  hintStyle: TextStyle(color: colorPrimary),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            height: 52,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: gray02,
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Center(
                              child: TextFormField(
                                enabled: false,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: "Enter your Email",
                                  hintStyle: TextStyle(color: colorPrimary),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            height: 52,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: gray02,
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Center(
                              child: TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.next,
                                obscureText: _isPasswordVisible,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  hintText: "Enter your password",
                                  hintStyle: TextStyle(color: colorPrimary),
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() =>
                                      _isPasswordVisible = !_isPasswordVisible);
                                    },
                                    icon: _isPasswordVisible
                                        ? Icon(Icons.visibility_off)
                                        : Icon(Icons.visibility),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            height: 52,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: gray02,
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Center(
                              child: TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                obscureText: _isPasswordVisible,
                                controller: _cPasswordController,
                                decoration: InputDecoration(
                                  hintText: "Confirm your Password",
                                  hintStyle: TextStyle(color: colorPrimary),
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() =>
                                      _isPasswordVisible = !_isPasswordVisible);
                                    },
                                    icon: _isPasswordVisible
                                        ? Icon(Icons.visibility_off)
                                        : Icon(Icons.visibility),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 42.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () async {
                                signUpUser();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(),
                                elevation: 0,
                                backgroundColor: colorPrimary
                              ),
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                color: colorWhite,
                                strokeWidth: 2,
                              )
                                  : Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: colorWhite,
                                  fontWeight: FontWeight.bold,
                                ),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          child: Text.rich(
                            TextSpan(
                              text: "Already have an account?",
                              style: TextStyle(
                                color: colorBlack,
                                fontWeight: FontWeight.w400,
                              ),
                              children:  [
                                TextSpan(
                                  text: " Sign In",
                                  style: TextStyle(
                                    color: colorPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
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
