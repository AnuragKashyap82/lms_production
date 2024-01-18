import 'package:eduventure/Controller/issue_book_controller.dart';
import 'package:eduventure/screens/applied_management_screen.dart';
import 'package:eduventure/screens/issued_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../utils/colors.dart';

class LibraryManagementScreen extends StatefulWidget {
  const LibraryManagementScreen({Key? key}) : super(key: key);

  @override
  State<LibraryManagementScreen> createState() => _LibraryManagementScreenState();
}

class _LibraryManagementScreenState extends State<LibraryManagementScreen> {

  final issueBookControllerController = Get.put(IssueBookController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: colorPrimary,
              elevation: 0,
              iconTheme: IconThemeData(color: colorBlack),
              bottom:  TabBar(
                labelColor: colorBlack,
                indicatorColor: colorWhite,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(text: "Applied"),
                  Tab(text: "Issued"),
                ],
              ),
              title:  Text('Library Management', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorBlack),),
            ),
            body: const  TabBarView(
              children: [
                AppliedManagementScreen(),
                IssuedManagementScreen(),
              ],
            ),
          ),
        ),

      );
  }
}
