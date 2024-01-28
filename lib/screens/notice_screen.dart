import 'package:eduventure/Controller/notice_controller.dart';
import 'package:eduventure/screens/add_notice_screen.dart';
import 'package:eduventure/screens/notice_view_screen.dart';
import 'package:eduventure/widgets/notice_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../Controller/user_controller.dart';
import '../utils/colors.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({Key? key}) : super(key: key);

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  final noticeController = Get.put(NoticeController());
  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
        elevation: 0,
        iconTheme: IconThemeData(color: colorBlack),
        title: Text(
          "Notice Section",
          style: TextStyle(
              fontSize: 16, color: colorBlack, fontWeight: FontWeight.bold),
        ),
      ),
      body:
      Obx(() {
        if (noticeController.isLoading.value)
          return  Center(
            child: CircularProgressIndicator(strokeWidth: 2, color: colorPrimary),
          );
        if (noticeController.allNotices.isEmpty) {
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
          itemCount: noticeController.allNotices.length,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (_, index) {
            final notice = noticeController.allNotices[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NoticeViewScreen(
                              noticeModel: notice,
                            )));
              },
              child: Container(
                child: NoticeCard(
                  noticeModel: notice,
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: userController.userData().userType == "teacher"
          ? FloatingActionButton(
              backgroundColor: colorPrimary,
              shape: StadiumBorder(),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddNoticeScreen()));
              },
              child: Icon(Icons.add, color: colorBlack,),
            )
          : userController.userData().userType == "admin"
              ? FloatingActionButton(
        backgroundColor: colorPrimary,
        shape: StadiumBorder(),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddNoticeScreen()));
                  },
                  child: Icon(Icons.add, color: colorBlack,),
                )
              : SizedBox(),
    );
  }
}
