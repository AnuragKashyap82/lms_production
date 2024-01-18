import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/Controller/classroom_controller.dart';
import 'package:eduventure/Controller/time_table_controller.dart';
import 'package:eduventure/Controller/time_table_faculty_controller.dart';
import 'package:eduventure/screens/edit_profile_screen.dart';
import 'package:eduventure/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../Controller/user_controller.dart';
import '../utils/global_variables.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;
  bool _isLogout = false;
  final userController = Get.put(UserController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoading = true;
    });
    loadUserDetails();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void loadUserDetails() async {
    if(userController.isLoading.value){
      setState(() {
        _isLoading = true;
      });
    }else{
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> clearControllers() async{
    Get.delete<UserController>();
    Get.delete<ClassroomController>();
    Get.delete<FacultyTimeTableControllerController>();
    Get.delete<TimeTableController>();
  }

  DocumentReference reference = FirebaseFirestore.instance.collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid);

  Future<void> clearToken() async {
    try {
      Map<String, dynamic> data = {
        'token': "",
      };
      await reference.update(data).whenComplete(() {
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(52.0),
        child: AppBar(
          // systemOverlayStyle: SystemUiOverlayStyle(
          //   statusBarColor: colorPrimary,
          //   statusBarIconBrightness: Brightness.dark,
          //   statusBarBrightness: Brightness.dark,
          // ),
          elevation: 0,
          iconTheme: IconThemeData(
            color: colorBlack,
          ),
          centerTitle: true,
          backgroundColor: colorPrimary,
          title: Text(
            "Profile",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorBlack,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.edit, color: colorBlack),
              ),
            )
          ],
        ),
      ),
      backgroundColor: colorWhite,
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: colorPrimary,
          strokeWidth: 2,
        ),
      )
          : Align(
        alignment: Alignment.topCenter,
        child: Container(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 122,
                    width: 122,
                    decoration: BoxDecoration(
                        border: Border.all(color: colorPrimary, width: 4),
                        shape: BoxShape.circle
                    ),
                    child: userController.userData().photoUrl != "" ?CircleAvatar(
                      radius: 58,
                      backgroundImage: NetworkImage(userController.userData().photoUrl),
                    ):CircleAvatar(
                      radius: 60,
                      backgroundColor: colorWhite,
                      child: Icon(Icons.person_pin, color: colorPrimary, size: 24,),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        userController.userData().name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: colorBlack,
                        ),
                      ),
                      userController.userData().userType == "admin"?
                          Icon(Icons.verified_user_outlined, color: Colors.green, size: 16,):userController.userData().userType == "teacher"?
                          Icon(Icons.verified_user_outlined, color: colorPrimary, size: 16,):SizedBox()
                    ],
                  ),
                  Text(userController.userData().email),
                  Text(userController.userData().studentId),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Country",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "India",
                            style: TextStyle(),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "State",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Jharkhand",
                            style: TextStyle(),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "City",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "---",
                            style: TextStyle(),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 0.4,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: colorBlack,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        userController.userData().completeAddress,
                        maxLines: 1,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    height: 0.4,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: colorBlack,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 120,
                            child: Text(
                              "Registration No: ",
                              style:
                              TextStyle(fontWeight: FontWeight.bold),
                            )),
                        Text(userController.userData().regNo),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 120,
                            child: Text(
                              "DOB: ",
                              style:
                              TextStyle(fontWeight: FontWeight.bold),
                            )),
                        Text(userController.userData().dob),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 120,
                            child: Text(
                              "Branch:",
                              style:
                              TextStyle(fontWeight: FontWeight.bold),
                            )),
                        Text(userController.userData().branch),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 120,
                            child: Text(
                              "Semester: ",
                              style:
                              TextStyle(fontWeight: FontWeight.bold),
                            )),
                        Text(userController.userData().semester),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 120,
                            child: Text(
                              "Session: ",
                              style:
                              TextStyle(fontWeight: FontWeight.bold),
                            )),
                        Text(userController.userData().session),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 120,
                            child: Text(
                              "Seat Type: ",
                              style:
                              TextStyle(fontWeight: FontWeight.bold),
                            )),
                        Text(userController.userData().seatType),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: StadiumBorder(),
        backgroundColor: colorPrimary,
        onPressed: () async {
          setState(() {
            _isLogout = true;
          });
          await clearControllers();
          await clearToken();
          await FirebaseAuth.instance.signOut().then((value) async{
            setState(() {
              _isLogout = false;
            });
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => LoginScreen()));
          });
        },
        child: _isLogout?CircularProgressIndicator(strokeWidth: 2, color: colorBlack,):Icon(Icons.logout, color: colorBlack,),
      ),
    );
  }
}
