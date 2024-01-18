import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/screens/register_screen.dart';
import 'package:eduventure/utils/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/colors.dart';

class VerifyUniqueIdScreen extends StatefulWidget {
  const VerifyUniqueIdScreen({Key? key}) : super(key: key);

  @override
  State<VerifyUniqueIdScreen> createState() => _VerifyUniqueIdScreenState();
}

class _VerifyUniqueIdScreenState extends State<VerifyUniqueIdScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _uniqueId = TextEditingController();
  TextEditingController countryController = TextEditingController();

  bool _isLoading = false;

  String btnText = "Send Otp";
  String verify = "";
  var email = "";
  var userType = "";

  var _uniqueIdData = {};

  void checkUniqueId() async {
    try {
      var uniqueIdSnap = await FirebaseFirestore.instance
          .collection("UniqueId")
          .doc(_uniqueId.text)
          .get();
      if (uniqueIdSnap.exists) {
        setState(() {
          _isLoading = false;
          _uniqueIdData = uniqueIdSnap.data()!;
          email = _uniqueIdData['email'];
          userType = _uniqueIdData['userType'];
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar("No Student id Found", context);
      }
      setState(() {});
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(e.toString(), context);
    }
  }

  void checkAlreadyRegUniqueId() async {
    if (_uniqueId.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      try {
        var uniqueIdSnap = await FirebaseFirestore.instance
            .collection("alreadyRegUniqueId")
            .doc(_uniqueId.text)
            .get();
        if (uniqueIdSnap.exists) {
          setState(() {
            _isLoading = false;
          });
          showSnackBar("StudentId Already Registered!!!", context);
        } else {
          checkUniqueId();
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(e.toString(), context);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackBar("Enter UniqueId", context);
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
              ? EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 0),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Verify your student id",
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
                  const Text(
                    "First verify your student id to register in Eduventure",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                    textAlign: TextAlign.start,
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
                                borderRadius: BorderRadius.circular(26)),
                            child: Center(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _uniqueId,
                                decoration:  InputDecoration(
                                  hintText: "Enter your Student Id",
                                  hintStyle: TextStyle(color: colorPrimary),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
                                checkAlreadyRegUniqueId();
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder(), backgroundColor: colorPrimary, elevation: 0),
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                color: colorWhite,
                                strokeWidth: 2,
                              )
                                  : Text(
                                "Verify",
                                style: TextStyle(
                                  color: colorWhite,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 52,
                                padding:
                                EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                    color: gray02,
                                    borderRadius: BorderRadius.circular(26)),
                                child: Center(
                                  child: Text(
                                    "${_uniqueIdData['email']}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if(_uniqueIdData['email'] != null){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => RegisterScreen(
                                            email: _uniqueIdData['email'],
                                            uniqueId: _uniqueIdData['studentId'],
                                            userType: userType,
                                          ),
                                        ),
                                      );
                                    }else{
                                      showSnackBar("Verify your Id first", context);
                                    }

                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: StadiumBorder(), backgroundColor: colorPrimary, elevation: 0),
                                  child: Text(
                                    "Next",
                                    style: TextStyle(
                                      color: colorWhite,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () async {
                          String? encodeQueryParameters(
                              Map<String, String> params) {
                            return params.entries
                                .map((MapEntry<String, String> e) =>
                            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                .join('&');
                          }

                          final Uri emailUri = Uri(
                            scheme: 'mailto',
                            path: 'lmsramgarhengineering@gmail.com',
                            query: encodeQueryParameters(<String, String>{
                              'subject': 'Need help',
                            }),
                          );

                          if (await canLaunchUrl(emailUri)) {
                            launchUrl(emailUri);
                          } else {
                            throw Exception("Could not launch $emailUri");
                          }
                        },
                        child:  Text.rich(TextSpan(
                            text:
                            "In case you face any difficulty in verifying your student id. kindly contact us",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            children: [
                              TextSpan(
                                  text: " Need Help",
                                  style: TextStyle(
                                      color: colorPrimary,
                                      fontWeight: FontWeight.w600))
                            ])),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
