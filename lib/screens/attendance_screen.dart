import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/Model/classroom_model.dart';
import 'package:eduventure/resource/firestore_methods.dart';
import 'package:eduventure/screens/report_screen.dart';
import 'package:eduventure/utils/global_variables.dart';
import 'package:eduventure/widgets/students_report_widgets.dart';
import 'package:eduventure/widgets/students_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../utils/colors.dart';

class AttendanceScreen extends StatefulWidget {
  final ClassroomModel classroomModel;

  const AttendanceScreen({Key? key, required this.classroomModel})
      : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _isLoading = false;
  bool _isInit = false;
  bool _isClassCreated = false;
  int noOfStudents = 0;
  int totalClassCount = 0;
  String year = DateTime.now().year.toString();
  String month = DateFormat('MMMM').format(DateTime.now());
  String date = DateFormat('d').format(DateTime.now());

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
          .doc("$date-$month-$year")
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

  Future<void> _copyStudentsToAttendance() async {
    try {
      // Retrieve students from the students collection
      var studentsQuery = await FirebaseFirestore.instance
          .collection('classroom/${widget.classroomModel.classCode}/students')
          .get();
      var students = studentsQuery.docs;

      // Create a reference to the attendance collection
      var attendanceCollectionRef = FirebaseFirestore.instance.collection(
          'classroom/${widget.classroomModel.classCode}/Attendance/${date + "-" + month + "-" + year}/Students');

      // Add each student to the attendance collection
      for (var studentDoc in students) {
        var studentData = studentDoc.data() as Map<String, dynamic>;
        var uid = studentData['uid'] as String;
        var name = studentData['name'] as String;
        var studentId = studentData['studentId'] as String;
        await attendanceCollectionRef.doc(studentDoc.id).set({
          "date": "$date-$month-$year",
          "attendance": "present",
          "uid": uid,
          'name': name,
          'studentId': studentId,
        });
      }
      setState(() {
        _isLoading = false;
        _isClassCreated = true;
      });
      // Show a success message
    } catch (e) {
      print('Error copying students to attendance: $e');

      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error copying students to Attendance.'),
      ));
    }
  }

  void createTodayClass() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await FireStoreMethods()
          .createTodayAttendance(
        year: year,
        month: month,
        date: date,
        classCode: widget.classroomModel.classCode,
      )
          .then((value) {
        _copyStudentsToAttendance();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
        title: Text(
          widget.classroomModel.subjectName,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: _isInit
          ? Center(
              child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colorPrimary,
            ))
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
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
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Total No Of Students: $noOfStudents",
                      style: TextStyle(
                          fontSize: 14,
                          color: colorBlack,
                          fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
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
                                            classroomModel:
                                                widget.classroomModel,
                                          )));
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: colorPrimary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            child: const Text(
                              "Report",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        !_isClassCreated
                            ? SizedBox(
                                height: 52,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 32,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      createTodayClass();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: colorPrimary,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12))),
                                    child: _isLoading
                                        ? CircularProgressIndicator(
                                            color: colorWhite,
                                            strokeWidth: 2,
                                          )
                                        : const Text(
                                            "Create Attendance",
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                              )
                            : const SizedBox(),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    _isClassCreated
                        ? StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('classroom')
                                .doc(widget.classroomModel.classCode)
                                .collection("Attendance")
                                .doc("$date-$month-$year")
                                .collection("Students")
                                .orderBy("studentId", descending: false)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<
                                        QuerySnapshot<Map<String, dynamic>>>
                                    snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
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
                                              classCode: widget
                                                  .classroomModel.classCode,
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
