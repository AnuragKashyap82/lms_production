import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/resource/firestore_methods.dart';
import 'package:eduventure/utils/global_variables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import '../Controller/notice_controller.dart';
import '../utils/colors.dart';

class AddNoticeScreen extends StatefulWidget {
  const AddNoticeScreen({Key? key}) : super(key: key);

  @override
  State<AddNoticeScreen> createState() => _AddNoticeScreenState();
}

class _AddNoticeScreenState extends State<AddNoticeScreen> {
  TextEditingController _noticeTitle = TextEditingController();
  TextEditingController _noticeNo = TextEditingController();

  NoticeController noticeController = Get.find();

  List<String> deviceTokens = [];
  bool _isLodingToken = false;

  @override
  void dispose() {
    super.dispose();
    _noticeNo.dispose();
    _noticeNo.dispose();
  }



  void getDeviceToken()async{
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

  UploadTask? task;
  File? file;
  String url = "";
  bool _isUploading = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.now();
    String timestamp = time.millisecondsSinceEpoch.toString();

    String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
    String dateTime = date;
    String tDate = DateFormat("HH:mm").format(DateTime.now());
    DocumentReference reference =
    FirebaseFirestore.instance.collection("Notice").doc(timestamp);

    void uploadNotice() async {
      setState(() {
        _isLoading = true;
      });
      try {
        Map<String, dynamic> data = {
          'noticeTitle': _noticeTitle.text, // Updating Document Reference
          'noticeNo': _noticeNo.text, // Updating Document Reference
          'noticeId': timestamp, // Updating Document Reference
          'noticeUrl': url, // Updating Document Reference
          'dateTime': dateTime, // Updating Document Reference
          'uid': FirebaseAuth.instance.currentUser?.uid, // Updating Document Reference
        };
        await reference.set(data).whenComplete(() {
          noticeController.fetchNotices();
         FireStoreMethods().sendPushNotification(deviceTokens, _noticeNo.text.trim(), "Notice: ${_noticeTitle.text.trim()}");
          setState(() {
            _isLoading = false;
          });
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
        FirebaseStorage.instance.ref().child("Notice").child(timestamp);
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
        backgroundColor: colorPrimary,
        iconTheme: IconThemeData(color: colorBlack),
        title: Text(
          "Add Notice",
          style: TextStyle(
              fontSize: 16, color: colorBlack, fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _isUploading
                  ? Center(
                child: CircularProgressIndicator(
                  color: colorBlack,
                  strokeWidth: 2,
                ),
              )
                  : Icon(Icons.attach_file),
            ),
            onTap: () {
              getPdfAndUpload();
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(26),
        margin: EdgeInsets.only(top: 100),
        child: SizedBox(
          child: Column(
            children: [
              TextField(
                controller: _noticeTitle,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.line_axis, color: colorPrimary,),
                  hintText: "Notice Title",
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
                controller: _noticeNo,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.line_axis, color: colorPrimary,),
                  hintText: "Notice No",
                  fillColor: gray02,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                height: 52,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if(_isLodingToken){
                      showSnackBar("Please wait", context);
                    }else{
                      if (url == "") {
                        showSnackBar("Please Pick Pdf", context);
                      } else {
                        if (_noticeTitle.text.isEmpty) {
                          showSnackBar("Enter Notice Title", context);
                        } else if (_noticeNo.text.isEmpty) {
                          showSnackBar("Enter Notice No", context);
                        } else {
                          uploadNotice();
                        }
                      }
                    }

                  },
                  style: ElevatedButton.styleFrom(shape: StadiumBorder(), elevation: 0, backgroundColor: colorPrimary),
                  child: _isLoading
                      ? CircularProgressIndicator(
                    color: colorWhite,
                    strokeWidth: 2,
                  )
                      :  Text("Upload Notice", style: TextStyle(color: colorWhite),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
