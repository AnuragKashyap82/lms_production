import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/Model/material_model.dart';
import 'package:eduventure/screens/material_read_screen.dart';
import 'package:eduventure/utils/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/colors.dart';

class MaterialDetailsScreen extends StatefulWidget {
  final MaterialModel materialModel;
  final userType;
  const MaterialDetailsScreen({Key? key, required this.materialModel, required this.userType}) : super(key: key);

  @override
  State<MaterialDetailsScreen> createState() => _MaterialDetailsScreenState();
}

class _MaterialDetailsScreenState extends State<MaterialDetailsScreen> {
  bool _isLoading = false;
  bool _alreadyExists = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAlreadyExists();
  }

  void checkAlreadyExists() async {
    try {
      var submittedSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("Favourites")
          .doc(widget.materialModel.materialId)
          .get();
      if (submittedSnap.exists) {
        setState(() {
          _alreadyExists = true;
        });
      } else {
        setState(() {
          _alreadyExists = false;
        });
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  Future<void> downloadFileExample() async {
    //First you get the documents folder location on the device...
    Directory appDocDir = await getApplicationDocumentsDirectory();
    //Here you'll specify the file it should be saved as
    File downloadToFile =
        File('${appDocDir.path}/${widget.materialModel.subTopic}.pdf');
    //Here you'll specify the file it should download from Cloud Storage
    String fileToDownload = 'Materials/${widget.materialModel.materialId}';

    //Now you can try to download the specified file, and write it to the downloadToFile.
    try {
      await FirebaseStorage.instance
          .ref(fileToDownload)
          .writeToFile(downloadToFile);
      showSnackBar("Downloaded", context);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print('Download error: $e');
      showSnackBar("failed", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    DocumentReference reference = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("Favourites")
        .doc(widget.materialModel.materialId);

    void addToFavourites() async {
      setState(() {
        _isLoading = true;
      });
      try {
        Map<String, dynamic> data = {
          'material': widget.materialModel.materialId,
          // Updating Document Reference// Updating Document Reference
        };
        await reference.set(data).whenComplete(() {
          setState(() {
            _isLoading = false;
            _alreadyExists = true;
          });
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

    void removeFromFav() async {
      setState(() {
        _isLoading = true;
      });
      try {
        Map<String, dynamic> data = {
          'material': widget.materialModel.materialId,
          // Updating Document Reference// Updating Document Reference
        };
        await reference.delete().whenComplete(() {
          setState(() {
            _isLoading = false;
            _alreadyExists = false;
          });
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
         
        elevation: 0,
        iconTheme: IconThemeData(color: colorBlack),
        title: Text(widget.materialModel.subName,style: TextStyle(fontSize: 16, color: colorBlack, fontWeight: FontWeight.bold),),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.my_library_books,
                          size: 95,
                          color: colorPrimary,
                        )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.materialModel.subName,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        Row(
                          children: [
                            Container(
                                width: 80,
                                child: Text(
                                  "Topic:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                )),
                            Text(
                              widget.materialModel.subTopic,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Container(
                                width: 80,
                                child: Text(
                                  "Date:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                )),
                            Text(
                              widget.materialModel.dateTime,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Container(
                                width: 80,
                                child: Text(
                                  "Size:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                )),
                            Text(
                              "239 kb",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Container(
                                width: 80,
                                child: Text(
                                  "Views:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                )),
                            Text(
                              "0",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Container(
                                width: 80,
                                child: Text(
                                  "Downloads:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                )),
                            Text(
                              "0",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Container(
                                width: 80,
                                child: Text(
                                  "Pages:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                )),
                            Text(
                              "N/A",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Container(
                  height: 0.7,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: colorBlack,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "Comments",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.add_comment),
              ),
            ),
          ),
          Container(
            width: size.width,
            height: 60,
            decoration: BoxDecoration(
              color: colorWhite,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, //New
                    blurRadius: 8,
                    offset: Offset(0, 1))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MaterialReadScreen(
                                  materialModel: widget.materialModel,
                              userType: widget.userType,
                                )));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        color: colorPrimary,
                      ),
                      Text(
                        "Read",
                        style: TextStyle(fontSize: 12, color: colorPrimary),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    downloadFileExample();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.download,
                        color: colorPrimary,
                      ),
                      Text(
                        "Dowload",
                        style: TextStyle(fontSize: 12, color: colorPrimary),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _alreadyExists ? removeFromFav() : addToFavourites();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _alreadyExists
                          ? Icon(
                              Icons.favorite,
                              color: Colors.redAccent,
                            )
                          : Icon(
                              Icons.favorite_border,
                              color: colorPrimary,
                            ),
                      Text(
                        "Add Favourites",
                        style: TextStyle(fontSize: 12, color: colorPrimary),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
