import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/resource/firestore_methods.dart';
import 'package:flutter/material.dart';
import '../utils/global_variables.dart';
import '../utils/colors.dart';

class StudentReportsWidgets extends StatefulWidget {
  final snap;
  final String classCode;

  const StudentReportsWidgets({Key? key,required this.snap, required this.classCode}) : super(key: key);

  @override
  State<StudentReportsWidgets> createState() => _StudentReportsWidgetsState();
}

class _StudentReportsWidgetsState extends State<StudentReportsWidgets> {
  bool _isLoading = false;
  var _studentsData = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoading = true;
    });
    loadUserDetails();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void loadUserDetails() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.snap['uid'])
          .get();
      if (userSnap.exists) {
        setState(() {
          _studentsData = userSnap.data()!;
        });
      } else {}
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    log("student widget gets called!!!");
    return _isLoading
        ? SizedBox()
        : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${_studentsData['name']}",
                style: TextStyle(
                    fontSize: 16,
                    color: colorBlack,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "${_studentsData['studentId']}",
                style: TextStyle(
                    fontSize: 12,
                    color: colorBlack.withOpacity(0.54),
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: PhysicalModel(
              color: colorWhite,
              elevation: 7,
              shadowColor: colorPrimary,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colorBlack.withOpacity(0.54))),
                child: Center(
                    child:
                    Text(
                      widget.snap['attendance'] == "present"?"P":"A",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: widget.snap['attendance'] == "present" ? Colors.green : Colors.red),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
