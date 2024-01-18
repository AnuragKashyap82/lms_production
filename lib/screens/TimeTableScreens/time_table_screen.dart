import 'package:eduventure/screens/TimeTableScreens/add_time_table_screen.dart';
import 'package:eduventure/screens/TimeTableScreens/time_table_tab.dart';
import 'package:eduventure/utils/colors.dart';
import 'package:eduventure/utils/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Controller/user_controller.dart';
import 'faculty_time_table_tab.dart';

class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({super.key});

  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  final userController = Get.put(UserController());
  DateTime now = DateTime.now();

  int getInitialIndex(){
    int dayOfWeek = now.weekday;
    if(dayOfWeek == 1){
      return 0;
    }else if(dayOfWeek == 2){
      return 1;
    }else if(dayOfWeek == 3){
      return 2;
    }else if(dayOfWeek == 4){
      return 3;
    }else if(dayOfWeek == 5){
      return 4;
    }else{
      return 0;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      body: DefaultTabController(
        length: 5,
        initialIndex: getInitialIndex(),
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: colorPrimary,
              iconTheme: IconThemeData(color: colorBlack),
              bottom: TabBar(
                labelColor: colorBlack,
                indicatorColor: colorWhite,
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelColor: gray02,
                physics: BouncingScrollPhysics(),
                tabs: const [
                  Tab(text: "Mon"),
                  Tab(text: "Tue"),
                  Tab(text: "Wed"),
                  Tab(text: "Thur"),
                  Tab(text: "Fri"),
                ],
              ),
              title: userController.userData().userType == "user"
                  ?Text(
                '${userController.userData().semester} - ${userController.userData().branch}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorBlack),
              ):Text(
                'Time Table',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorBlack),
              )
            ),
            body: userController.userData().userType == "user"
                ? TabBarView(
                    children: [
                      TimeTableTab(day: "Monday"),
                      TimeTableTab(day: "Tuesday"),
                      TimeTableTab(day: "Wednesday"),
                      TimeTableTab(day: "Thursday"),
                      TimeTableTab(day: "Friday"),
                    ],
                  )
                : TabBarView(
                    children: [
                      FacultyTimeTableTab(day: "Monday"),
                      FacultyTimeTableTab(day: "Tuesday"),
                      FacultyTimeTableTab(day: "Wednesday"),
                      FacultyTimeTableTab(day: "Thursday"),
                      FacultyTimeTableTab(day: "Friday"),
                    ],
                  )),
      ),
      floatingActionButton: userController.userData().userType == "admin"
          ? FloatingActionButton(
              backgroundColor: colorPrimary,
              shape: StadiumBorder(),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => AddTimeTableScreen()));
              },
              child: Icon(
                Icons.edit_calendar_outlined,
                color: colorBlack,
              ),
            )
          : SizedBox(),
    );
  }
}
