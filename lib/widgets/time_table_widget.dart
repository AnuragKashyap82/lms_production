import 'package:eduventure/Model/time_table_model.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class TimeTableWidget extends StatefulWidget {
  final TimetableModel timetableModel;
  const TimeTableWidget({super.key, required this.timetableModel});

  @override
  State<TimeTableWidget> createState() => _TimeTableWidgetState();
}

class _TimeTableWidgetState extends State<TimeTableWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
            color: gray02,
            borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        color: colorPrimary.withOpacity(0.6),
                        borderRadius:
                        BorderRadius.circular(12)),
                    child: Center(
                      child: Text(
                        "${widget.timetableModel.startTime}\nhr",
                        style: TextStyle(
                            color: colorBlack,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        color: colorPrimary.withOpacity(0.6),
                        borderRadius:
                        BorderRadius.circular(12)),
                    child: Center(
                      child: Text(
                        "${widget.timetableModel.endTime}\nhr",
                        style: TextStyle(
                            color: colorBlack,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.start,
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        color: colorPrimary,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "${widget.timetableModel.subName} (${widget.timetableModel.subCode})",
                        style: TextStyle(
                            color: colorBlack,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.start,
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_pin,
                        color: colorPrimary,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        widget.timetableModel.facultyName,
                        style: TextStyle(
                            color: colorBlack,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.start,
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.class_outlined,
                        color: colorPrimary,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "${widget.timetableModel.semester}",
                        style: TextStyle(
                            color: colorBlack,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.start,
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.computer,
                        color: colorPrimary,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        widget.timetableModel.branch,
                        style: TextStyle(
                            color: colorBlack,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
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
