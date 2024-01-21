import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/Model/classroom_model.dart';
import 'package:eduventure/widgets/atten_percent_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/colors.dart';

class MonthlyAttendanceScreen extends StatefulWidget {
  final ClassroomModel classroomModel;

  const MonthlyAttendanceScreen({Key? key, required this.classroomModel})
      : super(key: key);

  @override
  State<MonthlyAttendanceScreen> createState() =>
      _MonthlyAttendanceScreenState();
}

class _MonthlyAttendanceScreenState extends State<MonthlyAttendanceScreen> {

  DateTime selectedDate = DateTime.now();
  String pickedDate = DateFormat('MMMM-yyyy').format(DateTime.now());


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
        backgroundColor: colorPrimary,
        title: Text(
          widget.classroomModel.subjectName,
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async{
              DateTime date = (await _selectDate(context));
              print(date);
              setState(() {
                pickedDate = DateFormat('MMMM-yyyy').format(date);
              });
            },
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: colorPrimary, width: 0.5), top: BorderSide(color: colorPrimary, width: 0.5))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: colorBlack,
                    size: 16,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    pickedDate,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorBlack,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("classroom")
                    .doc(widget.classroomModel.classCode)
                    .collection("students")
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
                            child: AttendancePercentWidget(
                              snap: snapshot.data!.docs[index].data(),
                              classCode: widget.classroomModel.classCode,
                              pickedDate: pickedDate
                            ),
                          ),
                        ),
                      ));
                }),
          )
        ],
      ),
    );
  }

}
