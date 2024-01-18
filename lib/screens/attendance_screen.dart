import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/Model/classroom_model.dart';
import 'package:eduventure/resource/firestore_methods.dart';
import 'package:eduventure/screens/report_screen.dart';
import 'package:eduventure/widgets/students_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/colors.dart';

class AttendanceScreen extends StatefulWidget {
  final ClassroomModel classroomModel;

  const AttendanceScreen({Key? key, required this.classroomModel}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _isLoading = false;
  bool _isInit = false;
  bool _isClassCreated = false;
  int noOfStudents = 0;
  int attendanceCount = 0;
  int totalClassCount = 0;
  String currentYear = DateTime.now().year.toString();
  String currentMonthName = DateFormat('MMMM').format(DateTime.now());
  String currentDay = DateFormat('d').format(DateTime.now());

  Future<void> getAttendanceCount() async {
    String year = DateTime.now().year.toString();
    String month = DateFormat('MMMM').format(DateTime.now());
    String date = DateFormat('d').format(DateTime.now());
    final CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('classroom')
        .doc(widget.classroomModel.classCode)
        .collection("Attendance")
        .doc("$date-$month-$year")
        .collection("Students");
    collectionRef.get().then((QuerySnapshot snapshot) {
      setState(() {
        attendanceCount = snapshot.size;
      });
    });
  }

  Future<void> getNoOfStudents() async {
    final CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('classroom')
        .doc(widget.classroomModel.classCode)
        .collection("students");
    collectionRef.get().then((QuerySnapshot snapshot) {
      setState(() {
        noOfStudents = snapshot.size;
      });
    });
  }

  Future<void> checkClassCreated() async {
    try {
      var classCreatedSnap = await FirebaseFirestore.instance
          .collection("classroom")
          .doc(widget.classroomModel.classCode)
          .collection("Attendance")
          .doc("$currentDay-$currentMonthName-$currentYear")
          .get();
      if (classCreatedSnap.exists) {
        setState(() {
          _isClassCreated = true;
        });
      }
    } catch (e) {}
  }

  void initFunctions() async {
    setState(() {
      _isInit = true;
    });
    await checkClassCreated();
    await getNoOfStudents();
    await getAttendanceCount();
    setState(() {
      _isInit = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFunctions();
  }

  @override
  Widget build(BuildContext context) {
    void createTodayClass() async {
      try {
        setState(() {
          _isLoading = true;
        });

        await FireStoreMethods()
            .createTodayAttendance(
          year: currentYear,
          month: currentMonthName,
          date: currentDay,
          classCode: widget.classroomModel.classCode,
        )
            .then((value) {
          setState(() {
            _isLoading = false;
            _isClassCreated = true;
          });
        });
      } catch (error) {
        print("Error in createTodayClass: $error");
        // Handle the error as needed, e.g., show a toast, log, etc.
        setState(() {
          _isLoading = false;
          // Optionally set _isClassCreated to false or handle accordingly.
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
        title: Text(
          widget.classroomModel.subjectName,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                "0",
                style: TextStyle(fontSize: 14, color: colorBlack),
              ),
            ),
          )
        ],
      ),
      body:_isInit? Center(child: CircularProgressIndicator(strokeWidth: 2, color: colorPrimary,)): SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.classroomModel.className}",
                style: TextStyle(
                    fontSize: 16,
                    color: colorBlack,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "Total No Of Students: $noOfStudents",
                style: TextStyle(
                    fontSize: 14,
                    color: colorBlack,
                    fontWeight: FontWeight.normal),
              ),
              Text(
                "Total No Of Attendance: $attendanceCount",
                style: TextStyle(
                    fontSize: 14,
                    color: colorBlack,
                    fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 52,
                    width: MediaQuery.of(context).size.width / 2 - 32,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ReportScreen(
                                      classroomModel: widget.classroomModel,
                                    )));
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: colorPrimary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: Text(
                        "Report",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  !_isClassCreated
                      ? SizedBox(
                          height: 52,
                          width: MediaQuery.of(context).size.width / 2 - 32,
                          child: ElevatedButton(
                              onPressed: () async {
                                createTodayClass();
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: colorPrimary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                      color: colorWhite,
                                      strokeWidth: 2,
                                    )
                                  : Text(
                                      "Create Attendance",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black),
                                    )),
                        )
                      : Container(),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Quick Attendance",
                style: TextStyle(
                    fontSize: 14,
                    color: colorBlack,
                    fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 16,
              ),
              _isClassCreated
                  ? noOfStudents == attendanceCount
                      ? Center(
                          child: Container(
                          child: Text(
                            "All Attendance are marked",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                                fontWeight: FontWeight.normal),
                          ),
                        ))
                      : StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("classroom")
                              .doc(widget.classroomModel.classCode)
                              .collection("students")
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
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                      child: GestureDetector(
                                        child: Container(
                                          width: double.infinity,
                                          height: 85,
                                          child: StudentWidgets(
                                            snap: snapshot.data!.docs[index]
                                                .data(),
                                            classCode: widget.classroomModel.classCode,
                                          ),
                                        ),
                                      ),
                                    ));
                          })
                  : Center(
                      child: Container(
                        child: Text(
                          "No Class Created!!!!",
                          style: TextStyle(
                            fontSize: 14,
                            color: colorBlack,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
