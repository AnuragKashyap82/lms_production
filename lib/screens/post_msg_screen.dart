import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/Model/classroom_model.dart';
import 'package:eduventure/utils/colors.dart';
import 'package:eduventure/utils/global_variables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../resource/firestore_methods.dart';

class ClassroomPostMsgScreen extends StatefulWidget {
  final ClassroomModel classroomModel;

  const ClassroomPostMsgScreen({
    Key? key,
    required this.classroomModel,
  }) : super(key: key);

  @override
  State<ClassroomPostMsgScreen> createState() =>
      _ClassroomPostMsgScreenState();
}

class _ClassroomPostMsgScreenState extends State<ClassroomPostMsgScreen> {
  TextEditingController _msg = TextEditingController();

  UploadTask? task;
  File? file;
  String url = "";
  bool _isLoading = false;

  List<String> deviceTokens = [];
  bool _isLodingToken = false;

  void getDeviceToken()async{
    setState(() {
      _isLodingToken = true;
    });

    List<String> allUsersUid = await FireStoreMethods().getAllUsersJoined(widget.classroomModel.classCode);
    List<String> userTokens = await FireStoreMethods().getUsersTokens(allUsersUid);

    print("All Joined Tokens: [$userTokens]");

    setState(() {
      deviceTokens = userTokens;
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
    DateTime time = DateTime.now();
    String timestamp = time.millisecondsSinceEpoch.toString();

    String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
    String tDate = DateFormat("HH:mm").format(DateTime.now());
    String dateTime = date + "  " + tDate;

    DocumentReference reference = FirebaseFirestore.instance
        .collection("classroom")
        .doc(widget.classroomModel.classCode)
        .collection("postMsg")
        .doc(timestamp);

    void postClassMsgWithAttachment(String url) async {
      setState(() {
        _isLoading = true;
      });
      try {
        Map<String, dynamic> data = {
          'classCode': widget.classroomModel.classCode,
          'classMsg': _msg.text,
          'timestamp': timestamp,
          'dateTime': dateTime,
          'attachment': url,
          'uid': FirebaseAuth.instance.currentUser?.uid,
        };
        await reference.set(data).whenComplete(() async{
          await FireStoreMethods().sendPushNotification(deviceTokens, _msg.text, "Classroom: ${widget.classroomModel.subjectName}");
          Navigator.pop(context);
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(e.toString(), context);
      }
    }

    void postClassMsg() async {
      setState(() {
        _isLoading = true;
      });
      try {
        Map<String, dynamic> data = {
          'classCode': widget.classroomModel.classCode,
          'classMsg': _msg.text,
          'timestamp': timestamp,
          'dateTime': dateTime,
          'attachment': "",
          'uid': FirebaseAuth.instance.currentUser?.uid,
        };
        await reference.set(data).whenComplete(() async{
          await FireStoreMethods().sendPushNotification(deviceTokens, _msg.text, "Classroom: ${widget.classroomModel.subjectName}");
          Navigator.pop(context);
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(e.toString(), context);
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
        _isLoading = true;
      });
      final path = result.files.single.path!;

      DateTime time = DateTime.now();
      String timestamp = time.millisecondsSinceEpoch.toString();

      File file = File(path);
      try {
        final Reference storageReference = FirebaseStorage.instance
            .ref()
            .child("classPost")
            .child(timestamp);
        UploadTask uploadTask = storageReference.putFile(file);
        url = await (await uploadTask).ref.getDownloadURL();

        setState(() {
          _isLoading = false;
        });
      } on FirebaseException catch (e) {
        setState(() {
          _isLoading = false;
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
        title:  Text(
          "Share with you class",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: colorBlack),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
          child: Column(
            children: [
              TextField(
                controller: _msg,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                autofocus: true,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText:
                  "post your Doubts or class related message",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide.none),
                ),
              ),
              Expanded(child: SizedBox()),
               Divider(
                color: gray02,
                thickness: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      getPdfAndUpload();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(Icons.attach_file, color: colorPrimary),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(Icons.video_call_outlined, color: colorPrimary),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(Icons.picture_as_pdf, color: colorPrimary),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(Icons.more_vert_sharp, color: colorPrimary),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 0,
          backgroundColor: colorPrimary,
          shape: StadiumBorder(),
          child: _isLoading
              ? CircularProgressIndicator(
            color: colorWhite,
            strokeWidth: 2,
          )
              : Icon(
            Icons.send_outlined,
            color: colorWhite,
          ),
          onPressed: () {
            if(_isLodingToken){
              showSnackBar("Please wait and send", context);
            }else{
              if (url == "") {
                if (_msg.text == "") {
                  showSnackBar("Enter msg", context);
                } else {
                  postClassMsg();
                }
              } else {
                if (_msg.text == "") {
                  showSnackBar("Enter msg", context);
                } else {
                  postClassMsgWithAttachment(url);
                }
              }
            }

          }),
    );
  }
}
