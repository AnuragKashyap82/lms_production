import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/Controller/faculty_controller.dart';
import 'package:eduventure/Controller/time_table_controller.dart';
import 'package:eduventure/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AddTimeTableScreen extends StatefulWidget {
   const AddTimeTableScreen({super.key});

  @override
  State<AddTimeTableScreen> createState() => _AddTimeTableScreenState();
}

final TimeTableController timeTableController = Get.find();

class _AddTimeTableScreenState extends State<AddTimeTableScreen> {
  bool _isLoading = false;

  TextEditingController _subjectCodeController = TextEditingController();

  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime,
    );

    if (picked != null && picked != _selectedStartTime) {
      setState(() {
        _selectedStartTime = picked;
        timeTableController.startTime.value =
            _selectedEndTime.format(context).toString();
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime,
    );

    if (picked != null && picked != _selectedEndTime) {
      setState(() {
        _selectedEndTime = picked;
        timeTableController.endTime.value =
            _selectedEndTime.format(context).toString();
      });
    }
  }

  List<String> subjectNameList = [
    "Operating System",
    "Data Science",
    "DSA",
    "DS",
    "Machine Learning",
    "AI",
    "Operating System",
    "Data Science",
    "DSA",
    "DS",
    "Machine Learning",
    "AI",
    "Operating System",
    "Data Science",
    "DSA",
    "DS",
    "Machine Learning",
    "AI",
    "Operating System",
    "Data Science",
    "DSA",
    "DS",
    "Machine Learning",
    "AI",
    "Operating System",
    "Data Science",
    "DSA",
    "DS",
    "Machine Learning",
    "AI",
    "Operating System",
    "Data Science",
    "DSA",
    "DS",
    "Machine Learning",
    "AI",
    "Operating System",
    "Data Science",
    "DSA",
    "DS",
    "Machine Learning",
    "AI",
    "Operating System",
    "Data Science",
    "DSA",
    "DS",
    "Machine Learning",
    "AI",
  ];

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> clearTimeTableController() async{
    timeTableController.subjectName.value = "";
    timeTableController.subjectCode.value = "";
    timeTableController.facultyName.value = "";
    timeTableController.startTime.value = "";
    timeTableController.endTime.value = "";
  }

  Future<void> _addTimeTable() async {
    try {
      DateTime time = DateTime.now();
      String timestamp = time.millisecondsSinceEpoch.toString();

      setState(() {
        _isLoading = true;
      });

      // Perform asynchronous tasks here
      await firebaseFirestore.collection("TimeTable").doc(timestamp).set({
        "id": timestamp,
        "semester": timeTableController.semester.value,
        "branch": timeTableController.branch.value,
        "day": timeTableController.day.value,
        "subName": timeTableController.subjectName.value,
        "subCode": timeTableController.subjectCode.value,
        "facultyUid": timeTableController.facultyUid.value,
        "startTime": timeTableController.startTime.value,
        "endTime": timeTableController.endTime.value,
        "facultyName": timeTableController.facultyName.value,
      });
      await clearTimeTableController();
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred. Please try again. $error"),
          duration: Duration(seconds: 3),
        ),
      );

      // Set state to indicate that loading has finished
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    Get.put(FacultyController());
    final facultyController = Get.put(FacultyController());
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorPrimary,
        iconTheme: IconThemeData(color: colorBlack),
        title: Text(
          "Time Table",
          style: TextStyle(
              fontSize: 16, color: colorBlack, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            showDragHandle: true,
                            enableDrag: true,
                            barrierColor: Colors.transparent,
                            backgroundColor: colorWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20)),
                            ),
                            context: context,
                            builder: (context) => Container(
                              padding:  EdgeInsets.all(16.0).copyWith(top: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Select Semester",
                                      style:  TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: colorPrimary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                   SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "Provide marks to this student according to their submitted Assignment",
                                    style:  TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                   SizedBox(
                                    height: 16,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        timeTableController.semester.value =
                                            "1st Sem";
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 52,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: gray02,
                                          borderRadius: BorderRadius.circular(26)),
                                      child: Center(
                                          child: Text(
                                        "1st Sem",
                                        style: TextStyle(color: colorBlack),
                                      )),
                                    ),
                                  ),
                                   SizedBox(
                                    height: 12,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        timeTableController.semester.value =
                                            "2nd Sem";
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 52,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: gray02,
                                          borderRadius: BorderRadius.circular(26)),
                                      child: Center(
                                          child: Text(
                                        "2nd Sem",
                                        style: TextStyle(color: colorBlack),
                                      )),
                                    ),
                                  ),
                                   SizedBox(
                                    height: 12,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        timeTableController.semester.value =
                                            "3rd Sem";
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 52,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: gray02,
                                          borderRadius: BorderRadius.circular(26)),
                                      child: Center(
                                          child: Text(
                                        "3rd Sem",
                                        style: TextStyle(color: colorBlack),
                                      )),
                                    ),
                                  ),
                                   SizedBox(
                                    height: 12,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        timeTableController.semester.value =
                                            "4th Sem";
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 52,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: gray02,
                                          borderRadius: BorderRadius.circular(26)),
                                      child: Center(
                                          child: Text(
                                        "4th Sem",
                                        style: TextStyle(color: colorBlack),
                                      )),
                                    ),
                                  ),
                                   SizedBox(
                                    height: 12,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        timeTableController.semester.value =
                                            "5th Sem";
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 52,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: gray02,
                                          borderRadius: BorderRadius.circular(26)),
                                      child: Center(
                                          child: Text(
                                        "5th Sem",
                                        style: TextStyle(color: colorBlack),
                                      )),
                                    ),
                                  ),
                                   SizedBox(
                                    height: 12,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        timeTableController.semester.value =
                                            "6th Sem";
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 52,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: gray02,
                                          borderRadius: BorderRadius.circular(26)),
                                      child: Center(
                                          child: Text(
                                        "6th Sem",
                                        style: TextStyle(color: colorBlack),
                                      )),
                                    ),
                                  ),
                                   SizedBox(
                                    height: 12,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        timeTableController.semester.value =
                                            "7th Sem";
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 52,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: gray02,
                                          borderRadius: BorderRadius.circular(26)),
                                      child: Center(
                                          child: Text(
                                        "7th Sem",
                                        style: TextStyle(color: colorBlack),
                                      )),
                                    ),
                                  ),
                                   SizedBox(
                                    height: 12,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        timeTableController.semester.value =
                                            "8th Sem";
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 52,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: gray02,
                                          borderRadius: BorderRadius.circular(26)),
                                      child: Center(
                                          child: Text(
                                        "8th Sem",
                                        style: TextStyle(color: colorBlack),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 4.0),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: gray02,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                                child: Text(
                              timeTableController.semester.value,
                              style: TextStyle(color: colorBlack, fontSize: 12),
                            )),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              showDragHandle: true,
                              enableDrag: true,
                              barrierColor: Colors.transparent,
                              backgroundColor: colorWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                ),
                              ),
                              context: context,
                              builder: (context) => Container(
                                padding:
                                     EdgeInsets.all(16.0).copyWith(top: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Select Department",
                                        style:  TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: colorPrimary,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                     SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "Provide marks to this student according to their submitted Assignment",
                                      style:  TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                     SizedBox(
                                      height: 16,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          timeTableController.branch.value = "CSE";
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 52,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: gray02,
                                          borderRadius: BorderRadius.circular(26),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "CSE",
                                            style: TextStyle(color: colorBlack),
                                          ),
                                        ),
                                      ),
                                    ),
                                     SizedBox(
                                      height: 12,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          timeTableController.branch.value = "ECE";
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 52,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: gray02,
                                          borderRadius: BorderRadius.circular(26),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "ECE",
                                            style: TextStyle(color: colorBlack),
                                          ),
                                        ),
                                      ),
                                    ),
                                     SizedBox(
                                      height: 12,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          timeTableController.branch.value = "ME";
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 52,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: gray02,
                                          borderRadius: BorderRadius.circular(26),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "ME",
                                            style: TextStyle(color: colorBlack),
                                          ),
                                        ),
                                      ),
                                    ),
                                     SizedBox(
                                      height: 12,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          timeTableController.branch.value = "EE";
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 52,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: gray02,
                                          borderRadius: BorderRadius.circular(26),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "EE",
                                            style: TextStyle(color: colorBlack),
                                          ),
                                        ),
                                      ),
                                    ),
                                     SizedBox(
                                      height: 12,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          timeTableController.branch.value = "CE";
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 52,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: gray02,
                                          borderRadius: BorderRadius.circular(26),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "CE",
                                            style: TextStyle(color: colorBlack),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: gray02,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                                child: Text(
                              timeTableController.branch.value,
                              style: TextStyle(color: colorBlack, fontSize: 12),
                            )),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              showDragHandle: true,
                              enableDrag: true,
                              barrierColor: Colors.transparent,
                              backgroundColor: colorWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                ),
                              ),
                              context: context,
                              builder: (context) => Container(
                                padding:
                                     EdgeInsets.all(16.0).copyWith(top: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Select Weekday",
                                        style:  TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: colorPrimary,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                     SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "Provide marks to this student according to their submitted Assignment",
                                      style:  TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                     SizedBox(
                                      height: 16,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          timeTableController.day.value = "Monday";
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 52,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: gray02,
                                          borderRadius: BorderRadius.circular(26),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Monday",
                                            style: TextStyle(color: colorBlack),
                                          ),
                                        ),
                                      ),
                                    ),
                                     SizedBox(
                                      height: 12,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          timeTableController.day.value = "Tuesday";
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 52,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: gray02,
                                          borderRadius: BorderRadius.circular(26),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Tuesday",
                                            style: TextStyle(color: colorBlack),
                                          ),
                                        ),
                                      ),
                                    ),
                                     SizedBox(
                                      height: 12,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          timeTableController.day.value =
                                              "Wednesday";
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 52,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: gray02,
                                          borderRadius: BorderRadius.circular(26),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Wednesday",
                                            style: TextStyle(color: colorBlack),
                                          ),
                                        ),
                                      ),
                                    ),
                                     SizedBox(
                                      height: 12,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          timeTableController.day.value =
                                              "Thursday";
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 52,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: gray02,
                                          borderRadius: BorderRadius.circular(26),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Thursday",
                                            style: TextStyle(color: colorBlack),
                                          ),
                                        ),
                                      ),
                                    ),
                                     SizedBox(
                                      height: 12,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          timeTableController.day.value = "Friday";
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 52,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: gray02,
                                          borderRadius: BorderRadius.circular(26),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Friday",
                                            style: TextStyle(color: colorBlack),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: gray02,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                                child: Text(
                              timeTableController.day.value,
                              style: TextStyle(color: colorBlack, fontSize: 12),
                            )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            showDragHandle: true,
                            enableDrag: true,
                            barrierColor: Colors.transparent,
                            backgroundColor: colorWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20)),
                            ),
                            context: context,
                            builder: (context) => Container(
                              constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.85),
                              padding:  EdgeInsets.all(16.0).copyWith(top: 0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding:  EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.close_sharp,
                                              color: colorBlack,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Select Subject Name",
                                            style:  TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: colorPrimary,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                     SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "Provide marks to this student according to their submitted Assignment",
                                      style:  TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                     SizedBox(
                                      height: 16,
                                    ),
                                    GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        // You can adjust the number of columns as needed
                                        crossAxisSpacing: 6.0,
                                        mainAxisSpacing: 6.0,
                                      ),
                                      itemCount: subjectNameList.length,
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        String subjectName = subjectNameList[index];
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              timeTableController
                                                  .subjectName.value = subjectName;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding:  EdgeInsets.symmetric(
                                                horizontal: 6.0, vertical: 6),
                                            child: Container(
                                              height: 48,
                                              decoration: BoxDecoration(
                                                color: gray02,
                                                borderRadius:
                                                    BorderRadius.circular(26),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                       EdgeInsets.all(4.0),
                                                  child: Text(
                                                    subjectName,
                                                    style: TextStyle(
                                                        color: colorBlack,
                                                        fontSize: 14),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: TextFieldWidget(
                            heading: "Subject Name",
                            title: timeTableController.subjectName.value),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              showDragHandle: true,
                              enableDrag: true,
                              barrierColor: Colors.transparent,
                              backgroundColor: colorWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20)),
                              ),
                              context: context,
                              builder: (context) => Container(
                                constraints: BoxConstraints(
                                    minHeight:
                                        MediaQuery.of(context).size.height * 0.65),
                                padding:
                                     EdgeInsets.all(16.0).copyWith(top: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Icon(Icons.arrow_back),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Obtained Marks",
                                            style:  TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: colorPrimary,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                     SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "Provide marks to this student according to their submitted Assignment",
                                      style:  TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                     SizedBox(
                                      height: 16,
                                    ),
                                    TextField(
                                      controller: _subjectCodeController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                        prefixIcon:  Icon(Icons.pin_outlined),
                                        fillColor: gray02,
                                        filled: true,
                                        hintText: "Enter Obtained Marks",
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(color: gray02),
                                          borderRadius: BorderRadius.circular(26),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorPrimary),
                                          borderRadius: BorderRadius.circular(26),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorPrimary),
                                          borderRadius: BorderRadius.circular(26),
                                        ),
                                      ),
                                    ),
                                     SizedBox(
                                      height: 12,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 46,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            timeTableController.subjectCode.value =
                                                _subjectCodeController.text.trim();
                                          });
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape:  StadiumBorder(),
                                            elevation: 0,
                                            backgroundColor: colorPrimary),
                                        child: _isLoading
                                            ?  CircularProgressIndicator(
                                                color: colorWhite,
                                              )
                                            :  Text(
                                                "Done",
                                                style: TextStyle(color: colorWhite),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: TextFieldWidget(
                              heading: "Subject Code",
                              title: timeTableController.subjectCode.value)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      showDragHandle: true,
                      enableDrag: true,
                      barrierColor: Colors.transparent,
                      backgroundColor: colorWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                      ),
                      context: context,
                      builder: (context) => Container(
                        constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.85),
                        padding:  EdgeInsets.all(16.0).copyWith(top: 0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding:  EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.close_sharp,
                                        color: colorBlack,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Select Faculty Name",
                                      style:  TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: colorPrimary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                               SizedBox(
                                height: 12,
                              ),
                              Text(
                                "Provide marks to this student according to their submitted Assignment",
                                style:  TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                               SizedBox(
                                height: 16,
                              ),
                              Column(
                                children: [
                                  Obx(() {
                                    if (facultyController.isLoading.value)
                                      return  Center(
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2, color: colorPrimary),
                                      );
                                    if (facultyController.allFaculties.isEmpty) {
                                      return Center(
                                        child: Text(
                                          "No Notices",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: colorBlack,
                                          ),
                                        ),
                                      );
                                    }
                                    return ListView.builder(
                                      itemCount:
                                          facultyController.allFaculties.length,
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (_, index) {
                                        final faculty =
                                            facultyController.allFaculties[index];
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              timeTableController.facultyUid.value =
                                                  faculty.uid;
                                              timeTableController
                                                  .facultyName.value = faculty.name;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding:  EdgeInsets.symmetric(
                                                horizontal: 0.0, vertical: 4),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: gray02,
                                                borderRadius:
                                                    BorderRadius.circular(26),
                                              ),
                                              child: ListTile(
                                                leading: faculty.photoUrl != ""
                                                    ? CircleAvatar(
                                                        radius: 26,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                faculty.photoUrl),
                                                      )
                                                    : Container(
                                                        width: 52,
                                                        height: 52,
                                                        decoration: BoxDecoration(
                                                            color: colorWhite,
                                                            shape: BoxShape.circle),
                                                        child: Center(
                                                            child: Icon(
                                                          Icons.person,
                                                          color: colorPrimary,
                                                          size: 26,
                                                        )),
                                                      ),
                                                title: Text(
                                                  faculty.name,
                                                  style: TextStyle(
                                                      color: colorBlack,
                                                      fontSize: 14),
                                                  textAlign: TextAlign.start,
                                                ),
                                                subtitle: Text(
                                                  faculty.studentId,
                                                  style: TextStyle(
                                                      color: colorBlack,
                                                      fontSize: 14),
                                                  textAlign: TextAlign.start,
                                                ),
                                                trailing: Icon(
                                                  Icons.arrow_right_alt,
                                                  color: colorPrimary,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: TextFieldWidget(
                      heading: "Faculty Name",
                      title: timeTableController.facultyName.value),
                ),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    _selectStartTime(context);
                  },
                  child: TextFieldWidget(
                      heading: "Start Time",
                      title: timeTableController.startTime.value),
                ),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                    onTap: () {
                      _selectEndTime(context);
                    },
                    child: TextFieldWidget(
                        heading: "End Time",
                        title: timeTableController.endTime.value)),

              ],
            ),
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _addTimeTable();
                    },
                    style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        backgroundColor: colorPrimary,
                        elevation: 0),
                    child: _isLoading
                        ? CircularProgressIndicator(
                      color: colorWhite,
                      strokeWidth: 2,
                    )
                        : Text(
                      "Add Class",
                      style: TextStyle(
                        color: colorWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  final String heading;
  final String title;

   const TextFieldWidget(
      {super.key, required this.heading, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            heading,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 6,
        ),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            height: 52,
            decoration: BoxDecoration(
                color: gray02, borderRadius: BorderRadius.circular(26)),
            child: Center(
                child: Text(
              title,
              style: TextStyle(color: colorBlack),
            )),
          ),
        ),
      ],
    );
  }
}
