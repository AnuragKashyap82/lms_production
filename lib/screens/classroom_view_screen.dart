import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/Model/classroom_model.dart';
import 'package:eduventure/screens/assignment_screen.dart';
import 'package:eduventure/screens/class_msg_view_screen.dart';
import 'package:eduventure/screens/post_msg_screen.dart';
import 'package:eduventure/utils/colors.dart';
import 'package:eduventure/utils/global_variables.dart';
import 'package:eduventure/widgets/class_post_msg_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'attendance_screen.dart';
import 'my_attendence_report_screen.dart';

class ClassroomViewScreen extends StatefulWidget {
  final ClassroomModel classroomModel;
  final String userType;

  const ClassroomViewScreen({
    Key? key,
    required this.classroomModel,
    required this.userType,
  }) : super(key: key);

  @override
  State<ClassroomViewScreen> createState() => _ClassroomViewScreenState();
}

class _ClassroomViewScreenState extends State<ClassroomViewScreen> {
  bool _isTeacher = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (widget.classroomModel.uid == FirebaseAuth.instance.currentUser?.uid) {
      setState(() {
        _isTeacher = true;
      });
    } else {}

    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: colorBlack),
        centerTitle: true,
        backgroundColor: colorPrimary,
        title: Text(
          widget.classroomModel.subjectName,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: colorBlack),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("classroom")
                  .doc(widget.classroomModel.classCode)
                  .collection("postMsg")
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                  snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ClassMsgViewScreen(
                            snap: snapshot.data!.docs[index].data(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: width > webScreenSize ? width * 0.3 : 0,
                        vertical: width > webScreenSize ? 15 : 0,
                      ),
                      child: ClassPostMsgCard(
                        snap: snapshot.data!.docs[index].data(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8).copyWith(top: 0),
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorPrimary,
                borderRadius: BorderRadius.circular(30)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.video_call, color: colorBlack,),
                    onPressed: () {
                      showSnackBar("To be integrated!!!", context);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.assignment_outlined, color: colorBlack,),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssignmentScreen(
                            classroomModel: widget.classroomModel,
                            userType: widget.userType,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit_outlined,color: colorBlack),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClassroomPostMsgScreen(
                            classroomModel: widget.classroomModel,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                        icon: Icon(Icons.mark_as_unread,color: colorBlack),
                        onPressed: () {
                          _isTeacher?
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AttendanceScreen(
                                classroomModel: widget.classroomModel,
                              ),
                            ),
                          ):Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyAttendenceReportScreen(
                                classroomModel: widget.classroomModel,
                              ),
                            ),
                          );
                        },
                      )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
