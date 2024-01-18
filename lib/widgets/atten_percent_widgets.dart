import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/global_variables.dart';

class AttendancePercentWidget extends StatefulWidget {
  final snap;
  final String classCode;
  final String pickedDate;

  const AttendancePercentWidget({Key? key,required this.snap, required this.classCode, required this.pickedDate}) : super(key: key);

  @override
  State<AttendancePercentWidget> createState() => _AttendancePercentWidgetState();
}

class _AttendancePercentWidgetState extends State<AttendancePercentWidget> {
  bool _isLoading = false;
  var _studentsData = {};
  int totalClassConducted = 1;
  int totalPresent = 0;
  double percentPresent = 0;

  late StreamController<double> _percentPresentController;

  @override
  void initState() {
    super.initState();
    _percentPresentController = StreamController<double>.broadcast();
    setState(() {
      _isLoading = true;
    });
    loadUserDetails();
  }

  @override
  void dispose() {
    _percentPresentController.close();
    super.dispose();
  }

  Future<String> getStudentAttendance(String uid, String date) async {
    // Fetch the attendance information for the student from the Students collection
    DocumentSnapshot<Map<String, dynamic>> studentDoc = await FirebaseFirestore
        .instance
        .collection("classroom")
        .doc(widget.classCode)
        .collection("Attendance")
        .doc(date)
        .collection("Students")
        .doc(uid)
        .get();

    // Extract the attendance field value
    String attendance = studentDoc['attendance'];

    return attendance;
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                const  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "${_studentsData['studentId']}",
                    style:   TextStyle(
                        fontSize: 12,
                        color: colorBlack.withOpacity(0.54),
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8),
                child: StreamBuilder<double>(
                  stream: _percentPresentController.stream,
                  initialData: percentPresent,
                  builder: (context, snapshot) {
                    return Text(
                      "${snapshot.data?.toDouble().toStringAsFixed(2)}%",
                      style: TextStyle(
                        fontSize: 12,
                        color: snapshot.data! <75 ?Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection("classroom")
                .doc(widget.classCode)
                .collection("Attendance")
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }
              // Reset counters for each snapshot
              totalClassConducted = 0;
              totalPresent = 0;
              _percentPresentController.add(totalPresent/totalClassConducted * 100); // Notify stream listeners

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // Get the date and student UID from the Attendance collection
                  String date = snapshot.data!.docs[index]['date'];

                  if (date.contains(widget.pickedDate.toString())) {
                    totalClassConducted++;
                    return FutureBuilder(
                      future: getStudentAttendance(
                        widget.snap['uid'],
                        date,
                      ),
                      builder: (context, AsyncSnapshot<String> attendanceSnapshot) {
                        if (attendanceSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox();
                        }

                        // Check if the student was present
                        if (attendanceSnapshot.data == 'present') {
                          totalPresent++;
                          _percentPresentController.add(totalPresent/totalClassConducted * 100); // Notify stream listeners
                        }
                        // Display the ListTile with date and attendance information
                        return SizedBox();
                      },
                    );
                  } else {
                    return SizedBox();
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
