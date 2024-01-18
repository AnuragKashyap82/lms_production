import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/screens/subbmitted_ass_stud.dart';
import 'package:eduventure/screens/your_submitted_ass.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:internet_file/internet_file.dart';
import 'package:intl/intl.dart';
import 'package:pdfx/pdfx.dart';

import '../utils/colors.dart';
import '../utils/global_variables.dart';

class AssignmentViewScreen extends StatefulWidget {
  final snap;
  final String userType;
  const AssignmentViewScreen({Key? key, required this.snap, required this.userType}) : super(key: key);

  @override
  State<AssignmentViewScreen> createState() => _AssignmentViewScreenState();

}

class _AssignmentViewScreenState extends State<AssignmentViewScreen> {
  late PdfController pdfController;

  bool _isAdmin = false;
  bool _isTeacher = false;
  bool _isUser = false;


  loadController() {
    pdfController = PdfController(
        document: PdfDocument.openData(InternetFile.get(widget.snap['url'])));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadController();
    loadIfSubmitted();
  }

  UploadTask? task;
  File? file;
  String url = "";
  bool _isUploading = false;
  bool _isLoading = false;
  bool _alreadySubmitted = false;
  bool _notSubmitted = false;
  var _marksData = {

  };

  void loadIfSubmitted() async {
    try {
      var submittedSnap = await FirebaseFirestore.instance
          .collection("classroom")
          .doc(widget.snap['classCode'])
          .collection("assignment")
          .doc(widget.snap['assignmentId'])
          .collection("submission")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      if (submittedSnap.exists) {
        setState(() {
          _alreadySubmitted = true;
          _marksData = submittedSnap.data()!;
        });

      } else {
        setState(() {
          _notSubmitted = true;
        });
      }

    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {


    if(widget.userType == "admin"){
      setState(() {
        _isAdmin = true;
      });
    }else if(widget.userType == "teacher"){
      setState(() {
        _isTeacher = true;
      });
    }else{
      setState(() {
        _isUser = true;
      });
    }


    DateTime time = DateTime.now();
    String timestamp = time.millisecondsSinceEpoch.toString();

    String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
    String dateTime = date;
    ;
    String tDate = DateFormat("HH:mm").format(DateTime.now());
    DocumentReference reference = FirebaseFirestore.instance
        .collection("classroom")
        .doc(widget.snap['classCode'])
        .collection("assignment")
        .doc(widget.snap['assignmentId'])
        .collection("submission")
        .doc(FirebaseAuth.instance.currentUser?.uid);

    void addAss() async {
      setState(() {
        _isLoading = true;
      });
      try {
        Map<String, dynamic> data = {
          'assignmentId': widget.snap['assignmentId'],
          'assignmentName': widget.snap['assignmentName'],
          'classCode': widget.snap['classCode'],
          'dueDate': widget.snap['dueDate'],
          'fullMarks': widget.snap['fullMarks'],
          'marksObtained': "",
          'dateTime': dateTime,
          'url': url,
          'uid': FirebaseAuth.instance.currentUser?.uid,
          // Updating Document Reference
        };
        await reference.set(data).whenComplete(() {
          setState(() {
            _isLoading = false;
          });
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
      final result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ['pdf']);

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("No files Selected"),
        ));
        return null;
      }
      setState(() {
        _isUploading = true;
      });
      final path = result.files.single.path!;

      DateTime time = DateTime.now();
      String timestamp = time.millisecondsSinceEpoch.toString();

      File file = File(path);
      try {
        final Reference storageReference =
            FirebaseStorage.instance.ref().child("Assignment").child(timestamp);
        UploadTask uploadTask = storageReference.putFile(file);
        url = await (await uploadTask).ref.getDownloadURL();
        showSnackBar(url, context);
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
        elevation: 0,
        iconTheme: IconThemeData(color: colorBlack),
        centerTitle: true,
        backgroundColor: colorPrimary,
        title: Text(
          widget.snap['assignmentName'],
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorBlack),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  useRootNavigator: true,
                  backgroundColor: colorWhite,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(26), topRight:  Radius.circular(26) )),
                  context: context,
                  builder: (context) => Container(
                        height: 370,
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Your Work",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )),
                                Text(
                                  widget.snap['dueDate'],
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                _alreadySubmitted?
                                Expanded(
                                    child: Text(
                                  "Completed",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                )): Expanded(
                                    child: Text(
                                      "Not yet Completed",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent),
                                    )),
                                _isUploading
                                    ? CircularProgressIndicator(
                                        color: colorPrimary,
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          getPdfAndUpload();
                                        },
                                        child: Icon(
                                            Icons.picture_as_pdf_outlined)),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Text(
                                  "${_marksData['marksObtained']}/100",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Offstage(
                              offstage: _alreadySubmitted,
                              child: SizedBox(
                                width: double.infinity,
                                height: 46,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (url == "") {
                                      showSnackBar(
                                          "Please select your ass pdf", context);
                                    } else {
                                      addAss();
                                    }
                                  },
                                  child: _isLoading
                                      ? CircularProgressIndicator(
                                          color: colorWhite,
                                        )
                                      : Text("+Add Work", style: TextStyle(color: colorWhite),),
                                  style: ElevatedButton.styleFrom(
                                      shape: StadiumBorder(), elevation: 0, backgroundColor: colorPrimary),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Offstage(
                              offstage: _notSubmitted,
                              child: SizedBox(
                                width: double.infinity,
                                height: 46,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (url == "") {
                                      showSnackBar(
                                          "Please select your ass pdf", context);
                                    } else {
                                      addAss();
                                    }
                                  },
                                  child: Text("Replace your work", style: TextStyle(color: colorWhite),),
                                  style: ElevatedButton.styleFrom(
                                      shape: StadiumBorder(), elevation: 0, backgroundColor: colorPrimary),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Offstage(
                              offstage: _notSubmitted,
                              child: SizedBox(
                                width: double.infinity,
                                height: 46,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => YourSubmittedAss(snap: widget.snap)));
                                  },
                                  child: Text("Your work", style: TextStyle(color: colorWhite),),
                                  style: ElevatedButton.styleFrom(
                                      shape: StadiumBorder(), elevation: 0, backgroundColor: colorPrimary),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            _isTeacher?
                            SizedBox(
                              width: double.infinity,
                              height: 46,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SubmittedAssStudent(snap: widget.snap)));
                                },
                                child: Text("Students Works", style: TextStyle(color: colorWhite),),
                                style: ElevatedButton.styleFrom(
                                    shape: StadiumBorder(), elevation: 0, backgroundColor: colorPrimary),
                              ),
                            ):_isAdmin?SizedBox(
                              width: double.infinity,
                              height: 46,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SubmittedAssStudent(snap: widget.snap)));
                                },
                                child: Text("Students Works", style: TextStyle(color: colorWhite),),
                                style: ElevatedButton.styleFrom(
                                    shape: StadiumBorder(), elevation: 0, backgroundColor: colorPrimary),
                              ),
                            ):SizedBox(),
                          ],
                        ),
                      ));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.upload_file_outlined,
                color: colorBlack,
              ),
            ),
          )
        ],
      ),
      body: PdfView(
        controller: pdfController,
      ),
      floatingActionButton:
      SpeedDial(
        direction: SpeedDialDirection.up,
        icon: Icons.add,
        //icon on Floating action button
        activeIcon: Icons.close,
        //icon when menu is expanded on button
        backgroundColor: colorPrimary,
        //background color of button
        foregroundColor: colorWhite,
        //font color, icon color in button
        activeBackgroundColor: colorPrimary,
        //background color when menu is expanded
        activeForegroundColor: colorWhite,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: colorBlack,
        overlayOpacity: 0.1,
        elevation: 12.0,

        //shadow elevation of button
        shape: CircleBorder(),
        //shape of button

        children: [
          _isTeacher?
          SpeedDialChild(
            //speed dial child
            child: Icon(Icons.edit_outlined),
            backgroundColor: colorPrimary,
            foregroundColor: colorWhite,
            onTap: (){
              showSnackBar("Teacher", context);
            },
          ):_isAdmin? SpeedDialChild(
            //speed dial child
            child: Icon(Icons.edit_outlined),
            backgroundColor: colorPrimary,
            foregroundColor: colorWhite,
            onTap: (){
              showSnackBar("Teacher", context);
            },
          ):SpeedDialChild(),

          _isTeacher?
          SpeedDialChild(
            //speed dial child
            child: Icon(Icons.delete_outline),
            backgroundColor: colorPrimary,
            foregroundColor: colorWhite,
            onTap: (){

            },
          ):_isAdmin?
          SpeedDialChild(
            //speed dial child
            child: Icon(Icons.delete_outline),
            backgroundColor: colorPrimary,
            foregroundColor: colorWhite,
            onTap: (){

            },
          ):SpeedDialChild(),

          SpeedDialChild(
            child: Icon(Icons.download_outlined),
            backgroundColor: colorPrimary,
            foregroundColor: colorWhite,
            onTap: () {

            },
          ),

          //add more menu item children here
        ],
      ),
    );
  }
}
