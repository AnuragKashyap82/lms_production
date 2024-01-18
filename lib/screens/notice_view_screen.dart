import 'package:eduventure/Model/notice_model.dart';
import 'package:eduventure/utils/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';

import '../utils/colors.dart';

class NoticeViewScreen extends StatefulWidget {
  final NoticeModel noticeModel;
  final String userType;
  const NoticeViewScreen({Key? key, required this.noticeModel, required this.userType}) : super(key: key);

  @override
  State<NoticeViewScreen> createState() => _NoticeViewScreenState();
}

class _NoticeViewScreenState extends State<NoticeViewScreen> {

  bool _isAdmin = false;
  bool _isTeacher = false;
  bool _isUser = false;

  late PdfController pdfController;
  loadController(){
    pdfController = PdfController(document: PdfDocument.openData(InternetFile.get(widget.noticeModel.noticeUrl)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadController();
  }

  @override
  Widget build(BuildContext context) {

    if(widget.userType == "admin"){
      setState(() {
        _isAdmin = true;
      });
    }else if(widget.userType == "teacher"){
      setState(() {
        _isTeacher = true;
      });
    }else{
      setState(() {
        _isUser = true;
      });
    }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
         
        elevation: 0,
        iconTheme: IconThemeData(color: colorBlack),
        title: Text("${widget.noticeModel.noticeTitle}\n${widget.noticeModel.noticeNo}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorBlack),),
        centerTitle: true,
      ),

      body:Center(
        child: PdfView(controller: pdfController,scrollDirection: Axis.vertical),
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
          _isTeacher?
          SpeedDialChild(
            //speed dial child
            child: Icon(Icons.edit_outlined),
            backgroundColor: colorPrimary,
            foregroundColor: colorWhite,
            onTap: (){
              showSnackBar("Teacher", context);
            },
          ):_isAdmin? SpeedDialChild(
            //speed dial child
            child: Icon(Icons.edit_outlined),
            backgroundColor: colorPrimary,
            foregroundColor: colorWhite,
            onTap: (){
              showSnackBar("Teacher", context);
            },
          ):SpeedDialChild(),

          _isTeacher?
          SpeedDialChild(
            //speed dial child
            child: Icon(Icons.delete_outline),
            backgroundColor: colorPrimary,
            foregroundColor: colorWhite,
            onTap: (){

            },
          ):_isAdmin?
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
