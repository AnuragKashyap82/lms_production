import 'package:eduventure/Controller/user_controller.dart';
import 'package:eduventure/resource/firestore_methods.dart';
import 'package:eduventure/screens/TimeTableScreens/time_table_screen.dart';
import 'package:eduventure/screens/add_student_id_screen.dart';
import 'package:eduventure/screens/classroom_screen.dart';
import 'package:eduventure/screens/library_screen.dart';
import 'package:eduventure/screens/login_screen.dart';
import 'package:eduventure/screens/notice_screen.dart';
import 'package:eduventure/screens/profile_screen.dart';
import 'package:eduventure/screens/result_screen.dart';
import 'package:eduventure/screens/speech_to_text.dart';
import 'package:eduventure/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../Controller/books_controller.dart';
import '../Controller/classroom_controller.dart';
import '../Controller/material_controller.dart';
import '../Controller/notice_controller.dart';
import '../Controller/result_controller.dart';
import '../api/notification_api.dart';
import 'material_screen.dart';

class HomeScreen extends StatefulWidget {
   HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final userController = Get.put(UserController());

  var auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _isAdmin = false;
  bool _isTeacher = false;
  bool _isUser = false;
  bool _isDark = false;

  void updateToken() async {

    String newToken = await NotificationServices().getDeviceToken();
    await FireStoreMethods().updateToken(newToken);
  }

  Future<void> initController() async{
    Get.put(UserController());
    Get.put(NoticeController());
    Get.put(ClassroomController());
    Get.put(MaterialController());
    Get.put(ResultController());
    Get.put(BooksController());
    // Get.put(IssueBookController());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initController();
    updateToken();
    NotificationServices().requestPermission();
    NotificationServices().initNotification();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void checkUserType() {
    if (!userController.isLoading.value) {
      if (userController.userData().userType == "admin") {
        setState(() {
          _isAdmin = true;
        });
      } else if (userController.userData().userType == "teacher") {
        setState(() {
          _isTeacher = true;
        });
      } else {
        setState(() {
          _isUser = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userController.userData().userType == "admin") {
      setState(() {
        _isAdmin = true;
      });
    } else if (userController.userData().userType == "teacher") {
      setState(() {
        _isTeacher = true;
      });
    } else {
      setState(() {
        _isUser = true;
      });
    }

    return Scaffold(
        backgroundColor: colorWhite,
        appBar: PreferredSize(
          preferredSize:  const Size.fromHeight(0),
          child: AppBar(
            iconTheme:  IconThemeData(color: colorBlack),
            elevation: 0,
            backgroundColor: colorPrimary,
          ),
        ),
        body: Obx(() {
                if (userController.isLoading.value)
                  return  Center(
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: colorPrimary),
                  );
                Future.delayed(Duration.zero, () {
                  checkUserType(); // Call the function here after the build phase
                });
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:  const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                         const ProfileScreen()));
                                          },
                                          child: Text(
                                            "Hello, ${userController.userData().name}",
                                            style:  TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: colorBlack),
                                          ),
                                        ),
                                         const Text(
                                          "Have a great day",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   onTap: (){
                                  // if(_isDark){
                                  //   setState(() {
                                  //     _isDark = false;
                                  //      colorWhite = Colors.white;
                                  //      colorBlack = Colors.black;
                                  //      gray02 =     const Color(0xffededed);
                                  //      colorPrimary =     const Color(0xfff66a67);
                                  //   });
                                  // }else{
                                  //   setState(() {
                                  //     _isDark = true;
                                  //     colorWhite = Colors.black87;
                                  //     colorBlack = Colors.white.withOpacity(0.8);
                                  //     gray02 =     const Color(0xff2A2A2C);
                                  //     colorPrimary =  const Color(0xff171717);
                                  //     gray02 =     const Color(0xff424242);
                                  //   });
                                  // }
                                  //   },
                                  //   child: Padding(
                                  //     padding:  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                                  //     child: _isDark?Icon(Icons.dark_mode_rounded, color: colorPrimary,size: 24,):Icon(Icons.light_mode_rounded, color: colorPrimary,size: 24,),
                                  //   ),
                                  // ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                     const ProfileScreen()));
                                      },
                                      child: Container(
                                        height: 46,
                                        width: 46,
                                        decoration: BoxDecoration(
                                            color: colorPrimary,
                                            shape: BoxShape.circle),
                                        child: Center(
                                          child: userController
                                                      .userData()
                                                      .photoUrl !=
                                                  ""
                                              ? CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: NetworkImage(
                                                      userController
                                                          .userData()
                                                          .photoUrl),
                                                )
                                              : Icon(
                                                  Icons.person_pin,
                                                  color: colorWhite,
                                                  size: 20,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                        Padding(
                        padding: EdgeInsets.only(left: 18, top: 8, bottom: 4),
                        child: Text(
                          "Dashboard Section",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: colorBlack, fontSize: 20),
                        ),
                      ),
                       const SizedBox(
                        height: 8,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NoticeScreen(
                                              userType: userController
                                                  .userData()
                                                  .userType,
                                            )));
                              },
                              child: Container(
                                margin:  const EdgeInsets.only(left: 12),
                                padding:  const EdgeInsets.all(32),
                                height: 220,
                                width: 220,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  color: colorPrimary,
                                ),
                                child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      (Icons.school_rounded),
                                      size: 30,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const Text(
                                      "Notice",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const Text(
                                      "All official notice are here",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "See all notice",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Icon(
                                          Icons.arrow_back_outlined,
                                          size: 24,
                                          color: colorBlack,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                             const SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ClassroomScreen(
                                              userType: userController
                                                  .userData()
                                                  .userType,
                                            )));
                              },
                              child: Container(
                                padding:  const EdgeInsets.all(32),
                                height: 220,
                                width: 220,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  color: colorPrimary,
                                ),
                                child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      (Icons.class_outlined),
                                      size: 30,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const Text(
                                      "Classroom",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const Text(
                                      "You can create or join class",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "See all classes",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Icon(
                                          Icons.arrow_back_outlined,
                                          size: 24,
                                          color: colorBlack,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                             const SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LibraryScreen(
                                              userType: userController
                                                  .userData()
                                                  .userType,
                                            )));
                              },
                              child: Container(
                                margin:  const EdgeInsets.only(right: 12),
                                padding:  const EdgeInsets.all(32),
                                height: 220,
                                width: 220,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  color: colorPrimary,
                                ),
                                child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      (Icons.library_add),
                                      size: 30,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const Text(
                                      "Library",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const Text(
                                      "Here all books are available for issue or reading",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "See all books",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Icon(
                                          Icons.arrow_back_outlined,
                                          size: 24,
                                          color: colorBlack,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                       const Padding(
                              padding:
                                  EdgeInsets.only(left: 18, top: 18, bottom: 4),
                              child: Text(
                                "Admin Section",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),

                       const SizedBox(
                              height: 8,
                            ),


                      SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                              child: Row(
                                children: [
                                  _isAdmin
                                      ?
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                   const AddStudentIdScreen()));
                                    },
                                    child: Container(
                                      margin:  const EdgeInsets.only(left: 12),
                                      padding:  const EdgeInsets.all(32),
                                      height: 220,
                                      width: 220,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(26),
                                        color: colorPrimary,
                                      ),
                                      child:  Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            (Icons.add_circle_outlined),
                                            size: 30,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          const Text(
                                            "Add Student Id",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          const Text(
                                            "Add student id of newly admitted students",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "Add student Id",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              Icon(
                                                Icons.arrow_back_outlined,
                                                size: 24,
                                                color: colorBlack,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ):const SizedBox(),
                                  _isAdmin
                                      ?
                                   const SizedBox(
                                    width: 8,
                                  ): const SizedBox(
                                    width: 0,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                               const TimeTableScreen()));
                                      // showSnackBar("Under Development", context);
                                    },
                                    child: Container(
                                      margin:  const EdgeInsets.only(left: 12),
                                      padding:  const EdgeInsets.all(32),
                                      height: 220,
                                      width: 220,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(26),
                                        color: colorPrimary,
                                      ),
                                      child:  Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            (Icons.add_circle_outlined),
                                            size: 30,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          const Text(
                                            "Update Time Table",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          const Text(
                                            "Add Time Table for the All Branch and year",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "Add time table",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              Icon(
                                                Icons.arrow_back_outlined,
                                                size: 24,
                                                color: colorBlack,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        Padding(
                        padding: EdgeInsets.only(left: 18, top: 18, bottom: 4),
                        child: Text(
                          "Result Section",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: colorBlack, fontSize: 20),
                        ),
                      ),
                       const SizedBox(
                        height: 8,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ResultScreen(
                                              userType: userController
                                                  .userData()
                                                  .userType,
                                            )));
                              },
                              child: Container(
                                margin:  const EdgeInsets.only(left: 12),
                                padding:  const EdgeInsets.all(32),
                                height: 220,
                                width: 220,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  color: colorPrimary,
                                ),
                                child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      (Icons.school_outlined),
                                      size: 30,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const Text(
                                      "Result",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const Text(
                                      "Here you can see all your results",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "See all Results",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Icon(
                                          Icons.arrow_back_outlined,
                                          size: 24,
                                          color: colorBlack,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                             const SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MaterialsScreen(
                                              userType: userController
                                                  .userData()
                                                  .userType,
                                            )));
                              },
                              child: Container(
                                margin:  const EdgeInsets.only(left: 12),
                                padding:  const EdgeInsets.all(32),
                                height: 220,
                                width: 220,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  color: colorPrimary,
                                ),
                                child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      (Icons.my_library_books_outlined),
                                      size: 30,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const Text(
                                      "Materials",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const Text(
                                      "All materials are available here",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "See all Materials",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Icon(
                                          Icons.arrow_back_outlined,
                                          size: 24,
                                          color: colorBlack,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                             const SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const SpeechToTextScreen()));
                              },
                              child: Container(
                                margin:  const EdgeInsets.only(left: 12),
                                padding:  const EdgeInsets.all(32),
                                height: 220,
                                width: 220,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  color: colorPrimary,
                                ),
                                child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      (Icons.mic_none_outlined),
                                      size: 30,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const Text(
                                      "Speech to Text",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const Text(
                                      "Here you can translate your speech to text",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Explore this STT",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Icon(
                                          Icons.arrow_back_outlined,
                                          size: 24,
                                          color: colorBlack,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10,)
                          ],
                        ),
                      ),

                      const SizedBox(height: 10,)

                    ],
                  ),
                );
              }));
  }

  void signOut() {
    FirebaseAuth.instance.signOut().then((value) => navigate());
  }

  void navigate() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) =>  const LoginScreen()));
  }
}
