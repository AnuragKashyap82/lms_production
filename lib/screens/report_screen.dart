import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/Model/classroom_model.dart';
import 'package:eduventure/screens/monthly_attendance_screen.dart';
import 'package:eduventure/widgets/students_report_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/colors.dart';

class ReportScreen extends StatefulWidget {
  final ClassroomModel classroomModel;

  const ReportScreen({Key? key, required this.classroomModel}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime selectedDate = DateTime.now();
  String pickedDate = "${DateFormat('d').format(DateTime.now())}-${DateFormat('MMMM').format(DateTime.now())}-${DateTime.now().year.toString()}";
  // String pickedMonth = "April";

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2013, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      return picked;
    }else{
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.classroomModel.subjectName,
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: colorPrimary,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => MonthlyAttendanceScreen(
                            classroomModel: widget.classroomModel,
                          )));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.date_range,
                color: colorBlack,
              ),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async{
              DateTime date = (await _selectDate(context));
              print(date);
              setState(() {
                pickedDate = "${DateFormat('d').format(date)}-${DateFormat('MMMM').format(date)}-${date.year.toString()}";
              });
            },
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: colorPrimary, width: 0.5), top: BorderSide(color: colorPrimary, width: 0.5))
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: Icon(
                          Icons.date_range_sharp,
                          color: colorBlack,
                          size: 16,
                        )),
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: SizedBox(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("classroom")
                      .doc(widget.classroomModel.classCode)
                      .collection("Attendance")
                      .doc(pickedDate)
                      .collection("Students")
                      .orderBy("studentId", descending: false)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (!snapshot.hasData) {
                      return  Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorPrimary,
                        ),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => GestureDetector(
                              child: GestureDetector(
                                child: Container(
                                  width: double.infinity,
                                  height: 85,
                                  child:  StudentReportsWidgets(
                                    snap:
                                    snapshot.data!.docs[index].data(),
                                    classCode: widget.classroomModel.classCode,
                                  ),
                                ),
                              ),
                            ));
                  }),
            ),
          )
        ],
      ),
    );
  }
}
