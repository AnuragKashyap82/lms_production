import 'package:eduventure/Controller/users_time_table_controller.dart';
import 'package:eduventure/screens/edit_profile_screen.dart';
import 'package:eduventure/utils/colors.dart';
import 'package:eduventure/widgets/time_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Controller/user_controller.dart';

class TimeTableTab extends StatefulWidget {
  final String day;

   TimeTableTab({super.key, required this.day});

  @override
  State<TimeTableTab> createState() => _TimeTableTabState();
}

class _TimeTableTabState extends State<TimeTableTab> {
  final userController = Get.put(UserController());
  final userTimeTableController = Get.put(UsersTimeTableControllerController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      body: Padding(
        padding:  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
        child: userController.userData().branch == "" ||
                userController.userData().semester == ""
            ? Center(
                child: Padding(
                  padding:  const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Go to Profile and Update your Branch and Semester to View TimeTable",
                        style: TextStyle(
                            color: colorBlack,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const EditProfileScreen()));
                        },
                        child: Container(
                          height: 52,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: colorPrimary,
                              borderRadius: BorderRadius.circular(26)),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Go To Profile",
                                style: TextStyle(
                                    color: colorWhite,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.arrow_right_alt,
                                color: colorWhite,
                              )
                            ],
                          )),
                        ),
                      )
                    ],
                  ),
                ),
              )
            :
        Obx(
                () {
                  if(widget.day == "Monday"){
                    if (userTimeTableController.isLoading.value)
                      return  Center(
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: colorPrimary),
                      );
                    if (userTimeTableController.mondayTimeTable.isEmpty) {
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
                      itemCount: userTimeTableController.mondayTimeTable.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (_, index) {
                        final mondayTimeTable =
                        userTimeTableController.mondayTimeTable[index];
                        return
                          TimeTableWidget(timetableModel: mondayTimeTable);
                      },
                    );
                  }else if(widget.day == "Tuesday"){
                    if (userTimeTableController.isLoading.value)
                      return  Center(
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: colorPrimary),
                      );
                    if (userTimeTableController.tuesdayTimeTable.isEmpty) {
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
                      itemCount: userTimeTableController.tuesdayTimeTable.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (_, index) {
                        final mondayTimeTable =
                        userTimeTableController.tuesdayTimeTable[index];
                        return
                          TimeTableWidget(timetableModel: mondayTimeTable);
                      },
                    );
                  }else if(widget.day == "Wednesday"){
                    if (userTimeTableController.isLoading.value)
                      return  Center(
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: colorPrimary),
                      );
                    if (userTimeTableController.wednesdayTimeTable.isEmpty) {
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
                      itemCount: userTimeTableController.wednesdayTimeTable.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (_, index) {
                        final mondayTimeTable =
                        userTimeTableController.wednesdayTimeTable[index];
                        return Padding(
                          padding:  const EdgeInsets.symmetric(vertical: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: gray02,
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding:  const EdgeInsets.all(16.0),
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
                    if (userTimeTableController.isLoading.value)
                      return  Center(
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: colorPrimary),
                      );
                    if (userTimeTableController.thursdayTimeTable.isEmpty) {
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
                      itemCount: userTimeTableController.thursdayTimeTable.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (_, index) {
                        final mondayTimeTable =
                        userTimeTableController.thursdayTimeTable[index];
                        return
                          TimeTableWidget(timetableModel: mondayTimeTable);
                      },
                    );
                  }else if(widget.day == "Friday"){
                    if (userTimeTableController.isLoading.value)
                      return  Center(
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: colorPrimary),
                      );
                    if (userTimeTableController.fridayTimeTable.isEmpty) {
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
                      itemCount: userTimeTableController.fridayTimeTable.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (_, index) {
                        final mondayTimeTable =
                        userTimeTableController.fridayTimeTable[index];
                        return TimeTableWidget(timetableModel: mondayTimeTable);
                      },
                    );
                  }else {
                    if (userTimeTableController.isLoading.value)
                      return  Center(
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: colorPrimary),
                      );
                    if (userTimeTableController.mondayTimeTable.isEmpty) {
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
                      itemCount: userTimeTableController.mondayTimeTable.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (_, index) {
                        final mondayTimeTable =
                        userTimeTableController.mondayTimeTable[index];
                        return
                          TimeTableWidget(timetableModel: mondayTimeTable);
                      },
                    );
                  }

                },
              ),
      ),
    );
  }
}
