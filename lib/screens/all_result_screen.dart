import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/Controller/result_controller.dart';
import 'package:eduventure/screens/result_screen.dart';
import 'package:eduventure/screens/result_view_screen.dart';
import 'package:eduventure/widgets/result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../utils/colors.dart';

class AllResultScreen extends StatefulWidget {
  final String semester;
  final String branch;
  final String userType;

  const AllResultScreen(
      {Key? key, required this.semester, required this.branch, required this.userType})
      : super(key: key);

  @override
  State<AllResultScreen> createState() => _AllResultScreenState();
}

class _AllResultScreenState extends State<AllResultScreen> {

  final resultController = Get.put(ResultController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    resultController.fetchResults(widget.semester, widget.branch);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
         
        elevation: 0,
        iconTheme: IconThemeData(color: colorBlack),
        title: Text("${widget.semester} - ${widget.branch}",style: TextStyle(fontSize: 16, color: colorBlack, fontWeight: FontWeight.bold),),
      ),
      body: Obx(() {
        if (resultController.isLoading.value)
          return  Center(
            child:
            CircularProgressIndicator(strokeWidth: 2, color: colorPrimary),
          );
        if (resultController.allResults.isEmpty) {
          return Center(
            child: Text(
              "No Result",
              style: TextStyle(
                fontSize: 14,
                color: colorBlack,
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: resultController.allResults.length,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (_, index) {
            final result = resultController.allResults[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ResultViewScreen(
                  resultModel: result,
                  userType: widget.userType,
                )));
              },
              child: Container(
                child: ResultCard(
                  resultModel: result,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
