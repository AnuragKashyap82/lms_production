import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/resource/firestore_methods.dart';
import 'package:flutter/material.dart';
import '../utils/global_variables.dart';
import '../utils/colors.dart';

class StudentWidgets extends StatefulWidget {
  final snap;
  final String classCode;

  const StudentWidgets({Key? key, required this.snap, required this.classCode})
      : super(key: key);

  @override
  State<StudentWidgets> createState() => _StudentWidgetsState();
}

class _StudentWidgetsState extends State<StudentWidgets> {
  String absentPresent = "N/A";
  @override
  Widget build(BuildContext context) {
    log("student widget gets called!!!");
    return  Padding(
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
                      "${widget.snap['name']}",
                      style: TextStyle(
                          fontSize: 16,
                          color: colorBlack,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${widget.snap['studentId']}",
                      style: TextStyle(
                          fontSize: 12,
                          color: colorBlack.withOpacity(0.54),
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    if (widget.snap['attendance'] == "absent") {
                      await FireStoreMethods()
                          .markAttendancePresent(
                              classCode: widget.classCode,
                              uid: widget.snap['uid'])
                          .then((value) {
                        setState(() {
                          // absentPresent = "P";

                        });
                      });
                    } else if(widget.snap['attendance'] == "present") {
                      FireStoreMethods()
                          .markAttendanceAbsent(
                              classCode: widget.classCode,
                              uid: widget.snap['uid'])
                          .then((value) {
                        setState(() {
                          // absentPresent = "A";
                        });
                      });
                    }else{
                      showSnackBar("${widget.snap['attendance'] == "present"}", context);
                    }
                  },
                  child: Padding(
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
                            border: Border.all(
                                color: colorBlack.withOpacity(0.54))),
                        child: Center(
                            child: Text(
                          widget.snap['attendance'] == "present" ? "P" : "A",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: widget.snap['attendance'] == "present"
                                  ? Colors.green
                                  : Colors.red),
                        )),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
