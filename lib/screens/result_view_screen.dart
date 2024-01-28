import 'package:eduventure/Model/result_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';

import '../Controller/user_controller.dart';
import '../utils/colors.dart';
import '../utils/global_variables.dart';

class ResultViewScreen extends StatefulWidget {
  final ResultModel resultModel;
  const ResultViewScreen({Key? key, required this.resultModel}) : super(key: key);

  @override
  State<ResultViewScreen> createState() => _ResultViewScreenState();
}

class _ResultViewScreenState extends State<ResultViewScreen> {
  final UserController userController = Get.find();
  bool _isLoading = false;
  late PdfController pdfController;
  late PageController pageController;
  int _currentPage = 0;
  int totalPages = 0;

  Future<void> loadController() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final pdfData = await InternetFile.get(widget.resultModel.resultUrl);
      pdfController = PdfController(document: PdfDocument.openData(pdfData),);
      totalPages = (await pdfController.pagesCount)!;
      print("Anuragd $totalPages");
    } catch (e) {
      // Handle error loading PDF, you can show an error message or take appropriate action
      print('Error loading PDF: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadController();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
         
        elevation: 0,
        iconTheme: IconThemeData(color: colorBlack),
        title: Text(
          "${widget.resultModel.semester} - ${widget.resultModel.branch}",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorBlack),
        ),
        centerTitle: true,
      ),
      body: Center(
        child:  _isLoading
            ? CircularProgressIndicator(
          strokeWidth: 2,
          color: colorPrimary,
        )
            :PdfView(
          controller: pdfController,
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          onPageChanged: (page) {
            setState(() {
              _currentPage = page;
            });
          },
        ),
      ),
      floatingActionButton: SpeedDial(
        direction: SpeedDialDirection.up,
        icon: Icons.add,
        //icon on Floating action button
        activeIcon: Icons.close,
        //icon when menu is expanded on button
        backgroundColor: colorPrimary,
        //background color of button
        foregroundColor: colorWhite,
        //font color, icon color in button
        activeBackgroundColor: colorPrimary,
        //background color when menu is expanded
        activeForegroundColor: colorWhite,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: colorBlack,
        overlayOpacity: 0.1,
        elevation: 12.0,
        //shadow elevation of button
        shape: CircleBorder(),
        //shape of button

        children: [
          userController.userData().userType == "teacher"?
          SpeedDialChild(
            //speed dial child
            child: Icon(Icons.edit_outlined),
            backgroundColor: colorPrimary,
            foregroundColor: colorWhite,
            onTap: (){
              showSnackBar("Teacher", context);
            },
          ): userController.userData().userType == "admin"? SpeedDialChild(
            //speed dial child
            child: Icon(Icons.edit_outlined),
            backgroundColor: colorPrimary,
            foregroundColor: colorWhite,
            onTap: (){
              showSnackBar("Teacher", context);
            },
          ):SpeedDialChild(),

          userController.userData().userType == "teacher"?
          SpeedDialChild(
            //speed dial child
            child: Icon(Icons.delete_outline),
            backgroundColor: colorPrimary,
            foregroundColor: colorWhite,
            onTap: (){

            },
          ): userController.userData().userType == "admin"?
          SpeedDialChild(
            //speed dial child
            child: Icon(Icons.delete_outline),
            backgroundColor: colorPrimary,
            foregroundColor: colorWhite,
            onTap: (){

            },
          ):SpeedDialChild(),

          SpeedDialChild(
            child: Icon(Icons.download_outlined),
            backgroundColor: colorPrimary,
            foregroundColor: colorWhite,
            onTap: () {

            },
          ),

          //add more menu item children here
        ],
      ),
    );
  }
}
