import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/utils/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../Controller/classroom_controller.dart';
import '../utils/colors.dart';

class CreateClassScreen extends StatefulWidget {
  @override
  State<CreateClassScreen> createState() => _CreateClassScreenState();
}

class _CreateClassScreenState extends State<CreateClassScreen> {
  final classroomController = Get.put(ClassroomController());
  TextEditingController _subName = TextEditingController();
  TextEditingController _className = TextEditingController();
  bool _isLoading = false;
  var userData = {};

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _subName.dispose();
    _className.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();

      userData = userSnap.data()!;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.now();
    String timestamp = time.millisecondsSinceEpoch.toString();

    DocumentReference ref = FirebaseFirestore.instance.collection("classroom").doc(timestamp);

    DocumentReference reference = FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).collection("classroom").doc(timestamp);

    void joinYourSelf() async {
      setState(() {
        _isLoading = true;
      });
      try {
        Map<String, dynamic> data = {
          'classCode': timestamp,
          'className': _className.text,
          'subjectName': _subName.text,
          'uid': FirebaseAuth.instance.currentUser?.uid,
          'name': userData['name'],
        };
        await reference.set(data).whenComplete(() {
          setState(() {
            _isLoading = false;
          });
          classroomController.fetchClassrooms();
          Navigator.pop(context);
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(e.toString(), context);
      }
    }

    void createClass() async {
      setState(() {
        _isLoading = true;
      });
      try {
        Map<String, dynamic> data = {
          'classCode': timestamp,
          'className': _className.text,
          'subjectName': _subName.text,
          'uid': FirebaseAuth.instance.currentUser?.uid,
          'name': userData['name'],
        };
        await ref.set(data).whenComplete(() {
          joinYourSelf();
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(e.toString(), context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: colorPrimary,
          statusBarIconBrightness: Brightness.dark,
          // For Android (dark icons)
          statusBarBrightness: Brightness.dark,
          // For iOS (dark icons)
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: colorBlack),
        title: Text(
          "Create Class",
          style: TextStyle(fontSize: 16, color: colorBlack, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(26),
        margin: EdgeInsets.only(top: 100),
        child: Column(
          children: [
            TextField(
              controller: _subName,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              autofocus: false,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.book_outlined, color: colorPrimary,),
                hintText: "SubjectName",
                filled: true,
                fillColor: gray02,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            TextField(
              controller: _className,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              autofocus: false,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.book_online, color: colorPrimary,),
                hintText: "ClassName/branch/sem",
                fillColor: gray02,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 52,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_subName.text.isEmpty || _className.text.isEmpty) {
                    showSnackBar("Please Fill all the fields!!!", context);
                  } else  {
                    createClass();
                  }
                },
                style: ElevatedButton.styleFrom(shape: StadiumBorder(), backgroundColor: colorPrimary, elevation: 0),
                child: _isLoading
                    ? CircularProgressIndicator(
                  color: colorWhite,
                  strokeWidth: 2,
                )
                    : Text("Create Class".toUpperCase(), style: TextStyle(color: colorWhite),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
