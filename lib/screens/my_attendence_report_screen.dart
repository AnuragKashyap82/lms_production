import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/Model/classroom_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/colors.dart';


class MyAttendenceReportScreen extends StatefulWidget {
  final ClassroomModel classroomModel;

  const MyAttendenceReportScreen({Key? key, required this.classroomModel}) : super(key: key);

  @override
  State<MyAttendenceReportScreen> createState() => _MyAttendenceReportScreenState();
}

class _MyAttendenceReportScreenState extends State<MyAttendenceReportScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  DateTime selectedDate = DateTime.now();
  String pickedDate = DateFormat('MMMM-yyyy').format(DateTime.now());
  int totalClassConducted = 1;
  int totalPresent = 0;
  double percentPresent = 0;

  late StreamController<double> _percentPresentController;

  @override
  void initState() {
    super.initState();
    _percentPresentController = StreamController<double>.broadcast();
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
        .doc(widget.classroomModel.classCode)
        .collection("Attendance")
        .doc(date)
        .collection("Students")
        .doc(uid)
        .get();

    // Extract the attendance field value
    String attendance = studentDoc['attendance'];

    return attendance;
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2013, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      return picked;
    } else {
      return DateTime.now();
    }
  }

  // Future<String> calculatePercentagePresent() async {
  //   percentPresent = (totalPresent / totalClassConducted * 100);
  //   return "$percentPresent%";
  // }

  @override
  Widget build(BuildContext context) {
    print("Revuild");
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: colorBlack),
        centerTitle: false,
        backgroundColor: colorPrimary,
        title: Text(
          widget.classroomModel.subjectName,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorBlack,
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              DateTime date = (await _selectDate(context));
              setState(() {
                pickedDate = DateFormat('MMMM-yyyy').format(date);
              });
            },
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: colorPrimary, width: 0.5),
                  top: BorderSide(color: colorPrimary, width: 0.5),
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Center(
                            child: Icon(
                              Icons.calendar_month_sharp,
                              color: colorBlack,
                              size: 16,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Center(
                            child: Text(
                              pickedDate,
                              style: TextStyle(
                                fontSize: 14,
                                color: colorBlack,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: gray02,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: StreamBuilder<double>(
                            stream: _percentPresentController.stream,
                            initialData: percentPresent,
                            builder: (context, snapshot) {
                              return Text(
                                "${snapshot.data?.toDouble().toStringAsFixed(2)}%",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection("classroom")
                .doc(widget.classroomModel.classCode)
                .collection("Attendance")
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return  Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorPrimary,
                  ),
                );
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

                  if (date.contains(pickedDate.toString())) {
                    totalClassConducted++;
                    return FutureBuilder(
                      future: getStudentAttendance(
                        auth.currentUser!.uid,
                        date,
                      ),
                      builder: (context, AsyncSnapshot<String> attendanceSnapshot) {
                        if (attendanceSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: gray02,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  "Loading",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorBlack,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        // Check if the student was present
                        if (attendanceSnapshot.data == 'present') {
                          totalPresent++;
                          _percentPresentController.add(totalPresent/totalClassConducted * 100); // Notify stream listeners
                        }
                        // Display the ListTile with date and attendance information
                        return GestureDetector(
                          onTap: () {
                            // Handle onTap if needed
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: gray02,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text(date),
                                trailing: Text(
                                  attendanceSnapshot.data ?? "N/A",
                                  // Display "N/A" if attendance data is not available
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text(""));
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
