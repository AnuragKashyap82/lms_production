import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';

import '../utils/global_variables.dart';

class YourSubmittedAss extends StatefulWidget {
  final snap;
  const YourSubmittedAss({Key? key, required this.snap}) : super(key: key);

  @override
  State<YourSubmittedAss> createState() => _YourSubmittedAssState();
}

class _YourSubmittedAssState extends State<YourSubmittedAss> {

  bool _isLoading = false;
  var _submittedAssData = {};
  late PdfController pdfController;

  loadController() {
    pdfController = PdfController(
        document: PdfDocument.openData(InternetFile.get(_submittedAssData['url'])));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUrl();
  }

  void getUrl() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var _submittedAssSnap = await FirebaseFirestore.instance
          .collection("classroom")
          .doc(widget.snap['classCode'])
          .collection("assignment")
          .doc(widget.snap['assignmentId'])
          .collection("submission")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      if (_submittedAssSnap.exists) {
        setState(() {
          _submittedAssData = _submittedAssSnap.data()!;
        });
        loadController();
      } else {}
      setState(() {

      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
         
        elevation: 0,
        iconTheme: IconThemeData(color: colorBlack),
        title: _isLoading ? CircularProgressIndicator(color: colorWhite,) :
        Text(
          _submittedAssData['assignmentName'],
            style: TextStyle(fontSize: 16, color: colorBlack, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(color: colorPrimary,)):
      PdfView(
        controller: pdfController,
      ),
    );
  }
}
