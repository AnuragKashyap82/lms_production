import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/Model/issue_book_model.dart';
import 'package:eduventure/utils/global_variables.dart';
import 'package:eduventure/widgets/applied_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../utils/colors.dart';
import '../widgets/books_card.dart';

class UserAllAppliedBooksScreen extends StatefulWidget {
  final IssueBookModel issueBookModel;

  const UserAllAppliedBooksScreen({Key? key, required this.issueBookModel})
      : super(key: key);

  @override
  State<UserAllAppliedBooksScreen> createState() =>
      _UserAllAppliedBooksScreenState();
}

bool _isLoading = false;

class _UserAllAppliedBooksScreenState extends State<UserAllAppliedBooksScreen> {
  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.now();
    String timestamp = time.millisecondsSinceEpoch.toString();

    String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
    String tDate = DateFormat("HH:mm").format(DateTime.now());
    String dateTime = date + "  " + tDate;

    void _confirmIssue(final snap1) async {
      setState(() {
        _isLoading = true;
      });
      DocumentReference reference = FirebaseFirestore.instance
          .collection("issueBooks")
          .doc(snap1['issueId']);
      try {
        Map<String, dynamic> data = {
          'issueDate': dateTime,
          'status': "issued",
        };
        await reference.update(data).whenComplete(() {
          Navigator.pop(context);
          setState(() {
            _isLoading = false;
          });
          showSnackBar("done", context);
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
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Text(
                widget.issueBookModel.name,
                style: TextStyle(
                    fontSize: 14, color: colorBlack, fontWeight: FontWeight.w500),
              ),
            ),
            Text(
              widget.issueBookModel.studentId,
              style: TextStyle(
                  fontSize: 14, color: colorBlack, fontWeight: FontWeight.w500),
            ),

          ],
        ),
        actions: [
          widget.issueBookModel.photoUrl != ""?Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.issueBookModel.photoUrl),
            ),
          ):Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: colorWhite,
                  shape: BoxShape.circle
              ),
              child: Center(child: Icon(Icons.person, color: colorPrimary,size: 26,)),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("issueBooks")
              .where("uid", isEqualTo: widget.issueBookModel.uid)
              .where("status", isEqualTo: "applied")
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  Center(
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: colorPrimary),
              );
            }
            return GridView.builder(
              itemCount: snapshot.data!.docs.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, mainAxisExtent: 127),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: colorWhite,
                              alignment: Alignment(0.0, 0.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    20.0,
                                  ),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(
                                top: 10.0,
                              ),
                              insetPadding:
                                  EdgeInsets.symmetric(horizontal: 21),
                              content: Container(
                                  height: 220,
                                  width: 300,
                                  child: SingleChildScrollView(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Issue Book",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 12),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "Book Name:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 42,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(26),
                                              border: Border.all(
                                                  color: Colors.blue.shade100),
                                              color: colorPrimary,
                                            ),
                                            child: Center(
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                    .data()['bookName'],
                                                style: TextStyle(fontSize: 12),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Book Id:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 42,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(26),
                                              border: Border.all(
                                                  color: Colors.blue.shade100),
                                              color: colorPrimary,
                                            ),
                                            child: Center(
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                    .data()['bookId'],
                                                style: TextStyle(fontSize: 12),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                    width: 130,
                                                    height: 42,
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                shape:
                                                                    StadiumBorder()),
                                                        child: Text("Cancel"))),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                SizedBox(
                                                    width: 130,
                                                    height: 42,
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          _confirmIssue(snapshot
                                                              .data!.docs[index]
                                                              .data());
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                shape:
                                                                    StadiumBorder()),
                                                        child:
                                                            Text("Confirm"))),
                                              ]),
                                        ],
                                      ))),
                            );
                          });
                    },
                    child: AppliedCard(snap: snapshot.data!.docs[index].data()),
                  ),
                );
              },
            );
          }),
    );
  }
}
