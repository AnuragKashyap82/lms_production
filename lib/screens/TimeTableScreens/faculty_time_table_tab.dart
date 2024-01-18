import 'package:eduventure/Controller/time_table_faculty_controller.dart';
import 'package:eduventure/utils/colors.dart';
import 'package:eduventure/widgets/time_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class FacultyTimeTableTab extends StatefulWidget {
  final String day;

   FacultyTimeTableTab({super.key, required this.day});

  @override
  State<FacultyTimeTableTab> createState() => _FacultyTimeTableTabState();
}

class _FacultyTimeTableTabState extends State<FacultyTimeTableTab> {
  final facultyTimeTableController = Get.put(FacultyTimeTableControllerController());
  @override
  Widget build(BuildContext context) {
    return Obx(
          () {
        if(widget.day == "Monday"){
          if (facultyTimeTableController.isLoading.value)
            return
              Center(
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: colorPrimary),
            );
          if (facultyTimeTableController.mondayTimeTable.isEmpty) {
            return Center(
              child: Text(
                "No Monday TimeTable",
                style: TextStyle(
                  fontSize: 14,
                  color: colorBlack,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: facultyTimeTableController.mondayTimeTable.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, index) {
              final mondayTimeTable =
              facultyTimeTableController.mondayTimeTable[index];
              return
                TimeTableWidget(timetableModel: mondayTimeTable);
            },
          );
        }else if(widget.day == "Tuesday"){
          if (facultyTimeTableController.isLoading.value)
            return
              Center(
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: colorPrimary),
            );
          if (facultyTimeTableController.tuesdayTimeTable.isEmpty) {
            return Center(
              child: Text(
                "No Tuesday TimeTable",
                style: TextStyle(
                  fontSize: 14,
                  color: colorBlack,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: facultyTimeTableController.tuesdayTimeTable.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, index) {
              final mondayTimeTable =
              facultyTimeTableController.tuesdayTimeTable[index];
              return
                TimeTableWidget(timetableModel: mondayTimeTable);
            },
          );
        }else if(widget.day == "Wednesday"){
          if (facultyTimeTableController.isLoading.value)
            return
              Center(
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: colorPrimary),
            );
          if (facultyTimeTableController.wednesdayTimeTable.isEmpty) {
            return Center(
              child: Text(
                "No Wednesday TimeTable",
                style: TextStyle(
                  fontSize: 14,
                  color: colorBlack,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: facultyTimeTableController.wednesdayTimeTable.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, index) {
              final mondayTimeTable =
              facultyTimeTableController.wednesdayTimeTable[index];
              return Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 4.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: gray02,
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding:
                    const EdgeInsets.all(16.0),
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
                                  "${mondayTimeTable.startTime}\nhr",
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
                                  "${mondayTimeTable.endTime}\nhr",
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
                                const SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  "${mondayTimeTable.subName} (${mondayTimeTable.subCode})",
                                  style: TextStyle(
                                      color: colorBlack,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                            const SizedBox(
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
                                const SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  mondayTimeTable.facultyName,
                                  style: TextStyle(
                                      color: colorBlack,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
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
                                const SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  "${mondayTimeTable.subName} (${mondayTimeTable.subCode})",
                                  style: TextStyle(
                                      color: colorBlack,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                            const SizedBox(
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
                                const SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  mondayTimeTable.facultyName,
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
            },
          );
        }else if(widget.day == "Thursday"){
          if (facultyTimeTableController.isLoading.value)
            return
              Center(
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: colorPrimary),
            );
          if (facultyTimeTableController.thursdayTimeTable.isEmpty) {
            return Center(
              child: Text(
                "No Thursday TimeTable",
                style: TextStyle(
                  fontSize: 14,
                  color: colorBlack,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: facultyTimeTableController.thursdayTimeTable.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, index) {
              final mondayTimeTable =
              facultyTimeTableController.thursdayTimeTable[index];
              return
                TimeTableWidget(timetableModel: mondayTimeTable);
            },
          );
        }else if(widget.day == "Friday"){
          if (facultyTimeTableController.isLoading.value)
            return
              Center(
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: colorPrimary),
            );
          if (facultyTimeTableController.fridayTimeTable.isEmpty) {
            return Center(
              child: Text(
                "No Friday TimeTable",
                style: TextStyle(
                  fontSize: 14,
                  color: colorBlack,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: facultyTimeTableController.fridayTimeTable.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, index) {
              final mondayTimeTable =
              facultyTimeTableController.fridayTimeTable[index];
              return TimeTableWidget(timetableModel: mondayTimeTable);
            },
          );
        }else {
          if (facultyTimeTableController.isLoading.value)
            return
              Center(
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: colorPrimary),
            );
          if (facultyTimeTableController.mondayTimeTable.isEmpty) {
            return Center(
              child: Text(
                "No Monday TimeTable",
                style: TextStyle(
                  fontSize: 14,
                  color: colorBlack,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: facultyTimeTableController.mondayTimeTable.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, index) {
              final mondayTimeTable =
              facultyTimeTableController.mondayTimeTable[index];
              return
                TimeTableWidget(timetableModel: mondayTimeTable);
            },
          );
        }

      },
    );
  }
}
