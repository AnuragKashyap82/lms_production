import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/resource/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import '../Controller/user_controller.dart';
import '../utils/colors.dart';
import '../utils/global_variables.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isLoading = false;
  Uint8List? _image;
  String photoUrl = "";
  final UserController userController = Get.find();

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected!!');
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

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
    if (userController.isLoading.value) {
      setState(() {
        _isLoading = true;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _name =
        TextEditingController(text: userController.userData().name);
    TextEditingController _email =
        TextEditingController(text: userController.userData().email);
    TextEditingController _phoneNo =
        TextEditingController(text: userController.userData().phoneNo);
    TextEditingController _completeAddress =
        TextEditingController(text: userController.userData().completeAddress);
    TextEditingController _dob =
        TextEditingController(text: userController.userData().dob);
    TextEditingController _regNo =
        TextEditingController(text: userController.userData().regNo);
    TextEditingController _session =
        TextEditingController(text: userController.userData().session);
    TextEditingController _seatType =
        TextEditingController(text: userController.userData().seatType);

    DocumentReference reference = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid);

    void updateUser(String photoUrl) async {
      setState(() {
        _isLoading = true;
      });
      try {
        Map<String, dynamic> data = {
          'name': _name.text,
          'email': _email.text,
          'completeAddress': _completeAddress.text,
          'dob': _dob.text,
          'regNo': _regNo.text,
          'branch': userController.userData().branch,
          'semester': userController.userData().semester,
          'session': _session.text,
          'seatType': _seatType.text,
          'photoUrl': photoUrl,
        };
        await reference.update(data).whenComplete(() {
          setState(() {
            _isLoading = false;
          });
          userController.fetchUserData();
          showSnackBar("updated", context);
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(e.toString(), context);
        setState(() {
          _isLoading = false;
        });
      }
    }

    void uploadPhoto() async {
      setState(() {
        _isLoading = true;
      });
      photoUrl = await Storage().uploadImageToStorage(_image!);
      updateUser(photoUrl);
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(52.0),
        child: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: colorBlack),
          centerTitle: true,
          backgroundColor: colorPrimary,
          title: Text(
            "Update Profile",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: colorBlack),
          ),
        ),
      ),
      backgroundColor: colorWhite,
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: GestureDetector(
                    onTap: selectImage,
                    child: _image != null
                        ? Container(
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: colorPrimary, width: 2),
                                shape: BoxShape.circle),
                            child: CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            ),
                          )
                        : Container(
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: colorPrimary, width: 2),
                                shape: BoxShape.circle),
                            child: CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  "${userController.userData().photoUrl}"),
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                ProfileWidget(
                    heading: "Name",
                    name: _name,
                    enabled: true,
                    iconData: Icons.person_pin),
                ProfileWidget(
                    heading: "Email",
                    name: _email,
                    enabled: false,
                    iconData: Icons.email_outlined),
                ProfileWidget(
                    heading: "Complete Address",
                    name: _completeAddress,
                    enabled: true,
                    iconData: Icons.location_on_outlined),
                ProfileWidget(
                    heading: "DOB",
                    name: _dob,
                    enabled: true,
                    iconData: Icons.date_range_sharp),
                ProfileWidget(
                    heading: "Registration No",
                    name: _regNo,
                    enabled: true,
                    iconData: Icons.pin_outlined),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      showDragHandle: true,
                      enableDrag: true,
                      barrierColor: Colors.transparent,
                      backgroundColor: colorWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                        ),
                      ),
                      context: context,
                      builder: (context) => Container(
                        padding:
                        const EdgeInsets.all(16.0).copyWith(top: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Select Department",
                                style:  TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: colorPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Provide marks to this student according to their submitted Assignment",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  userController.userData().branch = "CSE";
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 52,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: gray02,
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                child: Center(
                                  child: Text(
                                    "CSE",
                                    style: TextStyle(color: colorBlack),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  userController.userData().branch = "ECE";
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 52,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: gray02,
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                child: Center(
                                  child: Text(
                                    "ECE",
                                    style: TextStyle(color: colorBlack),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  userController.userData().branch = "ME";
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 52,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: gray02,
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                child: Center(
                                  child: Text(
                                    "ME",
                                    style: TextStyle(color: colorBlack),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  userController.userData().branch = "EE";
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 52,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: gray02,
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                child: Center(
                                  child: Text(
                                    "EE",
                                    style: TextStyle(color: colorBlack),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  userController.userData().branch = "CE";
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 52,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: gray02,
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                child: Center(
                                  child: Text(
                                    "CE",
                                    style: TextStyle(color: colorBlack),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("Branch"),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            userController.userData().branch,
                            style: TextStyle(
                                color: colorBlack, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        leading: Icon(
                          Icons.trending_up_sharp,
                          color: colorPrimary,
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      showDragHandle: true,
                      enableDrag: true,
                      barrierColor: Colors.transparent,
                      backgroundColor: colorWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                      ),
                      context: context,
                      builder: (context) => Container(
                        padding: const EdgeInsets.all(16.0).copyWith(top: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Select Semester",
                                style:  TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: colorPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Provide marks to this student according to their submitted Assignment",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  userController.userData().semester = "1st Sem";
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 52,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: gray02,
                                    borderRadius: BorderRadius.circular(26)),
                                child: Center(
                                    child: Text(
                                      "1st Sem",
                                      style: TextStyle(color: colorBlack),
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  userController.userData().semester = "2nd Sem";
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 52,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: gray02,
                                    borderRadius: BorderRadius.circular(26)),
                                child: Center(
                                    child: Text(
                                      "2nd Sem",
                                      style: TextStyle(color: colorBlack),
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {

                                  userController.userData().semester = "3rd Sem";
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 52,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: gray02,
                                    borderRadius: BorderRadius.circular(26)),
                                child: Center(
                                    child: Text(
                                      "3rd Sem",
                                      style: TextStyle(color: colorBlack),
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  userController.userData().semester = "4th Sem";
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 52,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: gray02,
                                    borderRadius: BorderRadius.circular(26)),
                                child: Center(
                                    child: Text(
                                      "4th Sem",
                                      style: TextStyle(color: colorBlack),
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  userController.userData().semester = "5th Sem";
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 52,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: gray02,
                                    borderRadius: BorderRadius.circular(26)),
                                child: Center(
                                    child: Text(
                                      "5th Sem",
                                      style: TextStyle(color: colorBlack),
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  userController.userData().semester = "6th Sem";
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 52,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: gray02,
                                    borderRadius: BorderRadius.circular(26)),
                                child: Center(
                                    child: Text(
                                      "6th Sem",
                                      style: TextStyle(color: colorBlack),
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  userController.userData().semester = "7th Sem";
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 52,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: gray02,
                                    borderRadius: BorderRadius.circular(26)),
                                child: Center(
                                    child: Text(
                                      "7th Sem",
                                      style: TextStyle(color: colorBlack),
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  userController.userData().semester = "8th Sem";
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 52,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: gray02,
                                    borderRadius: BorderRadius.circular(26)),
                                child: Center(
                                    child: Text(
                                      "8th Sem",
                                      style: TextStyle(color: colorBlack),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("Semester"),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            userController.userData().semester,
                            style: TextStyle(
                                color: colorBlack, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        leading: Icon(
                          Icons.class_outlined,
                          color: colorPrimary,
                        ),
                      )
                    ],
                  ),
                ),
                ProfileWidget(
                    heading: "Session",
                    name: _session,
                    enabled: true,
                    iconData: Icons.calendar_month),
                ProfileWidget(
                    heading: "Seat Type",
                    name: _seatType,
                    enabled: true,
                    iconData: Icons.accessible),
                SizedBox(
                  height: 25,
                ),
                Center(
                  child: SizedBox(
                    width: 250,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_image != null) {
                          uploadPhoto();
                        } else {
                          updateUser("${userController.userData().photoUrl}");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: colorPrimary,
                          elevation: 0),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: colorWhite, strokeWidth: 2)
                          : Text(
                              "Update",
                              style: TextStyle(color: colorWhite),
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final String heading;
  final TextEditingController name;
  final bool enabled;
  final IconData iconData;

  const ProfileWidget(
      {Key? key,
      required this.heading,
      required this.name,
      required this.enabled,
      required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(heading),
      trailing: heading != "Email"
          ? SizedBox()
          : Icon(
              Icons.verified_user_outlined,
              color: colorPrimary,
              size: 24,
            ),
      subtitle: TextField(
        controller: name,
        enabled: enabled,
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none),
        style: TextStyle(
            color: colorBlack, fontSize: 12, fontWeight: FontWeight.bold),
      ),
      leading: Icon(
        iconData,
        color: colorPrimary,
      ),
    );
  }
}
