import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/Model/classroom_model.dart';
import 'package:eduventure/screens/add_ass_screen.dart';
import 'package:eduventure/screens/ass_view_screen.dart';
import 'package:eduventure/widgets/assignment_card.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class AssignmentScreen extends StatefulWidget {
  final ClassroomModel classroomModel;
  final String userType;
  const  AssignmentScreen({Key? key, required this.classroomModel, required this.userType}) : super(key: key);

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {

  bool _isAdmin = false;
  bool _isTeacher = false;
  bool _isUser = false;

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
        elevation: 0,
        iconTheme: IconThemeData(color: colorBlack),
        centerTitle: true,
        backgroundColor: colorPrimary,
        title: Text("Assignment Section",  style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: colorBlack),),
      ),

      body:
      StreamBuilder(
          stream: FirebaseFirestore.instance.collection("classroom").doc(widget.classroomModel.classCode).collection("assignment").snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  Center(
                child: CircularProgressIndicator(strokeWidth: 2, color: colorPrimary),
              );
            }
            return   ListView.builder(
                itemCount: snapshot.data!.docs.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) =>
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AssignmentViewScreen(
                            snap: snapshot.data!.docs[index].data(),
                          userType: widget.userType
                        )));
                      },
                      child: Container(
                        child:AssignmentCard(
                          snap: snapshot.data!.docs[index].data(),
                        ),
                      ),
                    ));

          }
      ),

      floatingActionButton: _isTeacher? FloatingActionButton(
        backgroundColor: colorPrimary,
        shape: StadiumBorder(),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddAssignmentScreen(classroomModel: widget.classroomModel)));
        },
        child: Icon(Icons.add, color: colorBlack,),
      ):_isAdmin?FloatingActionButton(
        backgroundColor: colorPrimary,
        shape: StadiumBorder(),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddAssignmentScreen(classroomModel: widget.classroomModel)));
        },
        child: Icon(Icons.add, color: colorBlack,),
      ):SizedBox(),

    );
  }
}
