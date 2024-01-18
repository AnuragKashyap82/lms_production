import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/utils/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class ClassPostMsgCard extends StatefulWidget {
  final snap;

  const ClassPostMsgCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<ClassPostMsgCard> createState() => _ClassPostMsgCardState();
}

class _ClassPostMsgCardState extends State<ClassPostMsgCard> {
  var userData = {};
  var isLoading = false;
  bool _isOwnMsg = true;
  bool _attachment = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      var userSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.snap['uid'])
          .get();

      userData = userSnap.data()!;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (widget.snap['uid'] == FirebaseAuth.instance.currentUser?.uid) {
        _isOwnMsg = true;
      } else {
        _isOwnMsg = false;
      }
    });

    if (widget.snap['attachment'] == "") {
      setState(() {
        _attachment = false;
      });
    } else {
      setState(() {
        _attachment = true;
      });
    }

    return Padding(
      padding: const EdgeInsets.all(4),
      child: isLoading
          ? Container()
          : Container(
        height: 80,
        width: 600,
        decoration: BoxDecoration(
          border: Border.all(color: colorWhite),
          borderRadius: BorderRadius.circular(26),
          color: colorWhite,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(userData["photoUrl"]),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData['name'],
                          style: TextStyle(
                              fontSize: 16,
                              color: colorBlack,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.snap['classMsg'],
                          style: TextStyle(
                            color: colorBlack,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16),
                            shrinkWrap: true,
                            children: [
                              'Delete',
                            ]
                                .map((e) => InkWell(
                              onTap: () async {
                                if (_isOwnMsg) {
                                  FirebaseFirestore.instance
                                      .collection("classroom")
                                      .doc(widget.snap['classCode'])
                                      .collection("postMsg")
                                      .doc(widget.snap['timestamp'])
                                      .delete()
                                      .then((value) => {
                                    Navigator.pop(context)
                                  });
                                } else {
                                  Navigator.pop(context);
                                  print(
                                      "Tu khud teacher hai lowde ....q dellete kar rha bsdk");
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                child: Text(e),
                              ),
                            ))
                                .toList(),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.more_vert),
                    color: colorBlack,
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _attachment
                        ? Container(
                      height: 26,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Center(
                        child:  Text(
                          "Attachment",
                          style: TextStyle(
                              color: colorWhite,
                              fontSize: 12,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    )
                        : SizedBox(),
                    Text(
                      widget.snap['dateTime'],
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
