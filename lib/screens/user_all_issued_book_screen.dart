import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/Model/issue_book_model.dart';
import 'package:eduventure/utils/global_variables.dart';
import 'package:eduventure/widgets/applied_card.dart';
import 'package:eduventure/widgets/issued_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../utils/colors.dart';

class UserAllIssuedBooksScreen extends StatefulWidget {
  final IssueBookModel issueBookModel;

  const UserAllIssuedBooksScreen({Key? key, required this.issueBookModel})
      : super(key: key);

  @override
  State<UserAllIssuedBooksScreen> createState() =>
      _UserAllIssuedBooksScreenState();
}
bool _isLoading = false;

class _UserAllIssuedBooksScreenState extends State<UserAllIssuedBooksScreen> {
  @override
  Widget build(BuildContext context) {

    var _qtyCountData  = {};

    DateTime time = DateTime.now();

    void increaseBookCount(String bookQty, String timestamp) async {
      setState(() {
        _isLoading = true;
      });
      int qtyCount = int.parse(bookQty);
      String newQtyCount = (qtyCount + 1).toString();
      DocumentReference ref = FirebaseFirestore.instance
          .collection("books")
          .doc(timestamp);
      try {
        Map<String, dynamic> data = {
          'bookQty': newQtyCount,
        };
        await ref.update(data).whenComplete(() {
          setState(() {
            _isLoading = true;
            Navigator.pop(context);
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

    String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
    String tDate = DateFormat("HH:mm").format(DateTime.now());
    String dateTime = date + "  " + tDate;

    void checkQtyCount(String timestamp) async {
        try {
          var qtyCountSnap = await FirebaseFirestore.instance
              .collection("books")
              .doc(timestamp)
              .get();
          if(qtyCountSnap.exists){
            setState(() {
              _qtyCountData = qtyCountSnap.data()!;
            });
            increaseBookCount(_qtyCountData['bookQty'], timestamp);

          }else{

          }
          setState(() {});
        } catch (e) {
          showSnackBar(e.toString(), context);
        }
        setState(() {
          _isLoading = false;
        });
    }



    void _confirnReturn(final snap1) async {
      setState(() {
        _isLoading = true;
      });
      DocumentReference reference = FirebaseFirestore.instance
          .collection("issueBooks")
          .doc(snap1['issueId']);
      try {
        Map<String, dynamic> data = {
          'returnedDate': dateTime,
          'status': "returned",
        };
        await reference.update(data).whenComplete(() {
          setState(() {
            _isLoading = true;
          });
          checkQtyCount(snap1['timestamp']);
          showSnackBar("done", context);
          Navigator.pop(context);
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
              .where("status", isEqualTo: "issued")
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  Center(
                child: CircularProgressIndicator(strokeWidth: 2, color: colorPrimary),
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
                  child:  GestureDetector(
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
                                                  "Return Book",
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w800,
                                                      fontSize: 12),
                                                  textAlign:
                                                  TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "Book Name:",
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
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
                                                BorderRadius.circular(
                                                    26),
                                                border: Border.all(
                                                    color: Colors
                                                        .blue.shade100),
                                                color: colorPrimary,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  snapshot.data!.docs[index]
                                                      .data()['bookName'],
                                                  style: TextStyle(
                                                      fontSize: 12),
                                                  textAlign:
                                                  TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Book Id:",
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
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
                                                BorderRadius.circular(
                                                    26),
                                                border: Border.all(
                                                    color: Colors
                                                        .blue.shade100),
                                                color: colorPrimary,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  snapshot.data!.docs[index]
                                                      .data()['bookId'],
                                                  style: TextStyle(
                                                      fontSize: 12),
                                                  textAlign:
                                                  TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
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
                                                          child: Text(
                                                              "Cancel"))),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  SizedBox(
                                                      width: 130,
                                                      height: 42,
                                                      child: ElevatedButton(
                                                          onPressed: () {
                                                            _confirnReturn(
                                                                snapshot
                                                                    .data!
                                                                    .docs[
                                                                index]
                                                                    .data());
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                              shape:
                                                              StadiumBorder()),
                                                          child: _isLoading ? CircularProgressIndicator(color: colorWhite,):
                                                          Text("Confirm"))

                                                  ),
                                                ]),
                                          ],
                                        ))),
                              );
                            });
                      },
                      child: IssuedCard(
                          snap: snapshot.data!.docs[index].data()))
                );
              },
            );
          }),
    );
  }
}
