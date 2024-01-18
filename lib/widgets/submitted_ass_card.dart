import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/utils/colors.dart';
import 'package:flutter/material.dart';

import '../utils/global_variables.dart';

class SubmittedAssCard extends StatefulWidget {
  final snap;

  const SubmittedAssCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<SubmittedAssCard> createState() => _SubmittedAssCardState();
}

class _SubmittedAssCardState extends State<SubmittedAssCard> {
  bool _isLoading = false;
  var _userData = {};

  void getStudentName() async {
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
          _userData = userSnap.data()!;
        });
      } else {
        // Handle non-existing user case
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getStudentName();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: _isLoading
          ? Center(
        child: CircularProgressIndicator(color: colorPrimary),
      )
          : Container(
        height: 60,
        width: 600,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: colorWhite, ),
          borderRadius: BorderRadius.circular(12),
          color: gray02,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        _userData["photoUrl"]),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userData['name'],
                          style: TextStyle(
                            fontSize: 14,
                            color: colorBlack,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "${widget.snap['marksObtained']}/${widget.snap['fullMarks']}",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      widget.snap['dateTime'],
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
