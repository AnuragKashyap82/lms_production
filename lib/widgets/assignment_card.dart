import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/global_variables.dart';

class AssignmentCard extends StatefulWidget {
  final snap;

  const AssignmentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<AssignmentCard> createState() => _AssignmentCardState();
}

class _AssignmentCardState extends State<AssignmentCard> {
  bool _alreadySubmitted = false;
  bool _notSubmitted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadIfSubmitted();
  }

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: gray02,
          borderRadius: BorderRadius.circular(12)
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          leading: Icon(
            Icons.assignment,
            color:
                _alreadySubmitted ? colorBlack.withOpacity(0.4) : colorPrimary,
          ),
          title: Text(
            widget.snap['assignmentName'],
            style: TextStyle(color: colorBlack, fontSize: 16),
          ),
          subtitle: Text(
            "Teacher Name",
            style: TextStyle(color: colorBlack.withOpacity(0.5), fontSize: 14),
          ),
          trailing: Text(
            "${widget.snap['dueDate']}\n${widget.snap['dateTime']}",
            style: TextStyle(
                color: colorBlack,
                fontWeight: FontWeight.w500,
                fontSize: 14),
            textAlign: TextAlign.end,
          ),
        ),
      ),
    );
  }
}
