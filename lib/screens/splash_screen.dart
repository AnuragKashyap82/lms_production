import 'dart:async';
import 'package:eduventure/screens/home_page.dart';
import 'package:eduventure/screens/login_screen.dart';
import 'package:eduventure/screens/verify_email_screen.dart';
import 'package:eduventure/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/global_variables.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var auth = FirebaseAuth.instance;
  bool _isLoading = false;

  checkIsLoggedIn() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        if (auth.currentUser!.emailVerified) {
          setState(() {
            _isLoading = false;
          });
          setState(() {
            Timer(Duration(milliseconds: 1000), () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            });
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          showSnackBar("Email id not Verifiefd!!", context);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => VerifyEmailScreen()));
        }
      } else {
        Timer(Duration(milliseconds: 1000), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIsLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
       SystemUiOverlayStyle(statusBarColor: colorWhite).copyWith(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark),
    );

    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? CircularProgressIndicator(
                color: colorPrimary,
                strokeWidth: 2,
              )
            : Container(
                height: double.infinity,
                width: double.infinity,
                color: colorWhite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25)
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                            child: Image.asset("assets/images/logo.png", ))
                    ),
                    SizedBox(
                      height: 26,
                    ),
                    Text(
                      "Eduventure",
                      style: TextStyle(
                          color: colorBlack.withOpacity(0.87),
                          fontSize: 25, fontWeight: FontWeight.w500),
                    )
                  ],
                )),
      ),
    );
  }
}
