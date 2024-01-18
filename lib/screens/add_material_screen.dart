import 'dart:io';
import '../resource/firestore_methods.dart';
import '../utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/utils/global_variables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddMaterialScreen extends StatefulWidget {
   AddMaterialScreen({Key? key}) : super(key: key);

  @override
  State<AddMaterialScreen> createState() => _AddMaterialScreenState();
}

class _AddMaterialScreenState extends State<AddMaterialScreen> {
  TextEditingController _subjectName = TextEditingController();
  TextEditingController _subjectTopic = TextEditingController();

  String semester = "Select Your Semester";
  String branch = "Select Your branch";
  bool _isLoading = false;
  UploadTask? task;
  File? file;
  String url = "";
  bool _isUploading = false;
  String id = "123";

  List<String> deviceTokens = [];
  bool _isLodingToken = false;

  void getDeviceToken() async {
    setState(() {
      _isLodingToken = true;
    });
    List<String> allTokens = await FireStoreMethods().getAllUsersToken();
    setState(() {
      deviceTokens = allTokens;
      _isLodingToken = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceToken();
  }

  @override
  Widget build(BuildContext context) {
    String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
    String dateTime = date;
    ;

    void uploadResult() async {
      setState(() {
        _isLoading = true;
      });
      try {
        Map<String, dynamic> data = {
          'semester': semester,
          // Updating Document Reference
          'branch': branch,
          // Updating Document Reference
          'subName': _subjectName.text,
          // Updating Document Reference
          'subTopic': _subjectTopic.text,
          // Updating Document Reference
          'materialUrl': url,
          // Updating Document Reference
          'materialId': id,
          // Updating Document Reference
          'dateTime': dateTime,
          // Updating Document Reference
          'uid': FirebaseAuth.instance.currentUser?.uid,
          // Updating Document Reference
        };
        await FirebaseFirestore.instance
            .collection("Materials")
            .doc(id)
            .set(data)
            .whenComplete(() async{
          setState(() {
            _isLoading = false;
          });
          await  FireStoreMethods().sendPushNotification(deviceTokens, branch, "Material: ${semester}");
          Navigator.pop(context);
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

    Future getPdfAndUpload() async {
      DateTime time = DateTime.now();
      String timestamp = time.millisecondsSinceEpoch.toString();

      final result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ['pdf']);

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
          content: Text("No files Selected"),
        ));
        return null;
      }
      setState(() {
        _isUploading = true;
      });
      final path = result.files.single.path!;

      File file = File(path);
      try {
        final Reference storageReference =
            FirebaseStorage.instance.ref().child("Materials").child(timestamp);
        UploadTask uploadTask = storageReference.putFile(file);
        url = await (await uploadTask).ref.getDownloadURL();
        showSnackBar(url, context);
        id = timestamp;
        setState(() {
          _isUploading = false;
        });
      } on FirebaseException catch (e) {
        setState(() {
          _isUploading = false;
        });
        print(e);
        showSnackBar(e.toString(), context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
        elevation: 0,
        iconTheme: IconThemeData(color: colorBlack),
        actions: [
          GestureDetector(
            child: Padding(
              padding:  const EdgeInsets.all(8.0),
              child: _isUploading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: colorBlack,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.attach_file),
            ),
            onTap: () {
              getPdfAndUpload();
            },
          )
        ],
        title: Text(
          "Add Material",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: colorBlack),
        ),
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          padding: MediaQuery.of(context).size.width > webScreenSize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              :  const EdgeInsets.all(26),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _subjectName,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.subject,
                    color: colorPrimary,
                  ),
                  hintText: "Enter Subject Name",
                  filled: true,
                  fillColor: gray02,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                controller: _subjectTopic,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.subject,
                    color: colorPrimary,
                  ),
                  hintText: "Enter Sub topic",
                  filled: true,
                  fillColor: gray02,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: colorWhite,
                          surfaceTintColor: colorWhite,
                          alignment: const Alignment(0.0, 0.0),
                          shape:  const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                20.0,
                              ),
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(top: 4.0, bottom: 4),
                          insetPadding: const EdgeInsets.symmetric(horizontal: 0),
                          content: Container(
                            constraints: BoxConstraints(maxHeight: 350),
                            width: 320,
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(
                                    height: 12,
                                  ),
                                   Text(
                                    "Select Your Semester",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: colorBlack,
                                        fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        semester = "1st Semester";
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding:  const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Container(
                                        height: 52,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: gray02,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child:  Center(
                                          child: Text(
                                            "1st Semester",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: colorBlack),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        semester = "2nd Semester";
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding:  const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Container(
                                        height: 52,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: gray02,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child:  Center(
                                          child: Text(
                                            "2nd Semester",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: colorBlack),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        semester = "3rd Semester";
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding:  const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Container(
                                        height: 52,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: gray02,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child:  Center(
                                          child: Text(
                                            "3rd Semester",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: colorBlack),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        semester = "4th Semester";
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding:  const EdgeInsets.symmetric(
                                              horizontal: 8.0)
                                          .copyWith(bottom: 4),
                                      child: Container(
                                        height: 52,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: gray02,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child:  Center(
                                          child: Text(
                                            "4th Semester",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: colorBlack),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        semester = "5th Semester";
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding:  const EdgeInsets.symmetric(
                                              horizontal: 8.0)
                                          .copyWith(bottom: 4),
                                      child: Container(
                                        height: 52,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: gray02,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child:  Center(
                                          child: Text(
                                            "5th Semester",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: colorBlack),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        semester = "6th Semester";
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding:  const EdgeInsets.symmetric(
                                              horizontal: 8.0)
                                          .copyWith(bottom: 4),
                                      child: Container(
                                        height: 52,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: gray02,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child:  Center(
                                          child: Text(
                                            "6th Semester",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: colorBlack),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        semester = "7th Semester";
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding:  const EdgeInsets.symmetric(
                                              horizontal: 8.0)
                                          .copyWith(bottom: 4),
                                      child: Container(
                                        height: 52,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: gray02,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child:  Center(
                                          child: Text(
                                            "7th Semester",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: colorBlack),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        semester = "8th Semester";
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding:  const EdgeInsets.symmetric(
                                              horizontal: 8.0)
                                          .copyWith(bottom: 4),
                                      child: Container(
                                        height: 52,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: gray02,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child:  Center(
                                          child: Text(
                                            "8th Semester",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: colorBlack),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: gray02),
                      color: gray02),
                  child: Center(
                    child: Text(
                      "${semester}",
                      style:  TextStyle(
                          fontWeight: FontWeight.bold, color: colorBlack),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: colorWhite,
                          surfaceTintColor: colorWhite,
                          alignment: const Alignment(0.0, 0.0),
                          shape:  const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                20.0,
                              ),
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(top: 4.0, bottom: 4),
                          insetPadding: const EdgeInsets.symmetric(horizontal: 0),
                          content: Container(
                              width: 320,
                              child: SingleChildScrollView(
                                  padding:  const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Select Your branch",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: colorBlack,
                                            fontSize: 16),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            branch = "cse";
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding:  const EdgeInsets.symmetric(
                                                  horizontal: 8.0)
                                              .copyWith(bottom: 4),
                                          child: Container(
                                            height: 52,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: gray02,
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child:  Center(
                                              child: Text(
                                                "CSE",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: colorBlack),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            branch = "me";
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding:  const EdgeInsets.symmetric(
                                                  horizontal: 8.0)
                                              .copyWith(bottom: 4),
                                          child: Container(
                                            height: 52,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: gray02,
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child:  Center(
                                              child: Text(
                                                "ME",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: colorBlack),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            branch = "ece";
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding:  const EdgeInsets.symmetric(
                                                  horizontal: 8.0)
                                              .copyWith(bottom: 4),
                                          child: Container(
                                            height: 52,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: gray02,
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child:  Center(
                                              child: Text(
                                                "ECE",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: colorBlack),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            branch = "ee";
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding:  const EdgeInsets.symmetric(
                                                  horizontal: 8.0)
                                              .copyWith(bottom: 4),
                                          child: Container(
                                            height: 52,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: gray02,
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child:  Center(
                                              child: Text(
                                                "EE",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: colorBlack),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            branch = "ce";
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding:  const EdgeInsets.symmetric(
                                                  horizontal: 8.0)
                                              .copyWith(bottom: 4),
                                          child: Container(
                                            height: 52,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: gray02,
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child:  Center(
                                              child: Text(
                                                "CE",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: colorBlack),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                       const SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  ))),
                        );
                      });
                },
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: gray02),
                      color: gray02),
                  child: Center(
                    child: Text(
                      "${branch}",
                      style:  TextStyle(
                        color: colorBlack,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                height: 52,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      if (_isLodingToken) {
                        showSnackBar(
                            "You have slow Network Connection. Please Wait and Click again!!!",
                            context);
                      } else {
                        if (semester == "Select Your Semester") {
                          showSnackBar("Select Your Semester", context);
                        } else if (branch == "Select Your branch") {
                          showSnackBar("Select Your branch", context);
                        } else if (url == "") {
                          showSnackBar("Pick Result PDF", context);
                        } else if (_subjectName.text.isEmpty) {
                          showSnackBar("Enter Subject Name", context);
                        } else if (_subjectTopic.text.isEmpty) {
                          showSnackBar("Enter Sub topic", context);
                        } else {
                          uploadResult();
                        }
                      }

                    },
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        elevation: 0,
                        backgroundColor: colorPrimary),
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: colorWhite,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Upload Material",
                            style: TextStyle(color: colorWhite),
                          )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
