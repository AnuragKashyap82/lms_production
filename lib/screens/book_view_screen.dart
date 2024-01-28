import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/Model/books_model.dart';
import 'package:eduventure/utils/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import '../Controller/user_controller.dart';
import '../utils/colors.dart';

class BookViewScreen extends StatefulWidget {
  final BooksModel booksModel;

  const BookViewScreen({Key? key, required this.booksModel}) : super(key: key);

  @override
  State<BookViewScreen> createState() => _BookViewScreenState();
}

class _BookViewScreenState extends State<BookViewScreen> {
  bool _isAvailable = true;
  bool _isButtonDisabled = false;
  bool _isLoading = false;
  bool _alreadyIssued = false;

  FirebaseAuth _auth = FirebaseAuth.instance;
  final UserController userController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAvailable();
    hasUserIssuedBook();
  }

  void checkAvailable() {
    if (widget.booksModel.bookQty == "" || widget.booksModel.bookQty == "0") {
      setState(() {
        _isAvailable = false;
        _isButtonDisabled = true;
      });
    } else {
      setState(() {
        _isAvailable = true;
        _isButtonDisabled = false;
      });
    }
  }

  Future<void> hasUserIssuedBook() async {

    // Reference to the Firestore collection
    CollectionReference issuesCollection = FirebaseFirestore.instance.collection('issueBooks');

    // Query to check if the user has already issued the book
    QuerySnapshot querySnapshot = await issuesCollection
        .where('timestamp', isEqualTo: widget.booksModel.timestamp)
        .where('uid', isEqualTo: _auth.currentUser!.uid)
        .get();

    // Check if any documents match the query
    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        _alreadyIssued = true;
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.now();

    String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
    String tDate = DateFormat("HH:mm").format(DateTime.now());
    String dateTime = date + "  " + tDate;

    int qtyCount = int.parse(widget.booksModel.bookQty);
    String newQtyCount = (qtyCount - 1).toString();

    DocumentReference ref = FirebaseFirestore.instance
        .collection("books")
        .doc(widget.booksModel.timestamp);

    DocumentReference reference = FirebaseFirestore.instance
        .collection("issueBooks")
        .doc(time.millisecondsSinceEpoch.toString());


    void decreaceBookCount() async {
      setState(() {
        _isLoading = true;
      });
      try {
        Map<String, dynamic> data = {
          'bookQty': newQtyCount,
        };
        await ref.update(data).whenComplete(() {
          setState(() {
            _isLoading = false;
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

    void ApplyForIssueBook() async {
      setState(() {
        _isLoading = true;
      });
      try {
        Map<String, dynamic> data = {
          'authorName': widget.booksModel.authorName,
          'bookId': widget.booksModel.bookId,
          'bookName':widget.booksModel.bookName,
          'subjectName': widget.booksModel.subjectName,
          'appliedDate': dateTime,
          'status': "applied",
          'issueId': time.millisecondsSinceEpoch.toString(),
          'timestamp': widget.booksModel.timestamp,
          'uid': FirebaseAuth.instance.currentUser?.uid,
          'name': userController.userData().name,
          'studentId': userController.userData().studentId,
          'photoUrl': userController.userData().photoUrl,
          'email': userController.userData().email,
        };
        await reference.set(data).whenComplete(() {
          setState(() {
            _isLoading = false;
          });
          decreaceBookCount();
          showSnackBar(newQtyCount, context);
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
        systemOverlayStyle:  SystemUiOverlayStyle(
          statusBarColor: colorPrimary,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: colorBlack),
        title: Text(widget.booksModel.subjectName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorBlack)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BookWidget(heading: "Subject Name:", name: "${widget.booksModel.subjectName}", enabled: true, iconData: Icons.menu_book_rounded),
          BookWidget(heading: "Book Name:", name: "${widget.booksModel.bookName}", enabled: true, iconData: Icons.menu_book_rounded),
          BookWidget(heading: "Author Name:", name: "${widget.booksModel.authorName}", enabled: true, iconData: Icons.person),
          BookWidget(heading: "Book Id:", name: "${widget.booksModel.bookId}", enabled: true, iconData: Icons.pin_outlined),
          BookWidget(heading: "Quantity Available:", name: "${widget.booksModel.bookQty}", enabled: true, iconData: Icons.pin_outlined),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  if (_isButtonDisabled) {
                    showSnackBar("Book Not Available", context);
                  } else if(_alreadyIssued){
                    showSnackBar("Already Issued!!", context);
                  }else{
                    ApplyForIssueBook();
                  }
                },
                style: ElevatedButton.styleFrom(shape: StadiumBorder(), backgroundColor: colorPrimary, elevation: 0),
                child: _isLoading
                    ? CircularProgressIndicator(
                  color: colorWhite, strokeWidth: 2,
                )
                    : Text(_alreadyIssued?"Already Issued":"Issue", style: TextStyle(color: colorWhite),),
              ),
            ),
          )
        ],
      ),
    );
  }
}


class BookWidget extends StatelessWidget {
  final String heading;
  final String name;
  final bool enabled;
  final IconData iconData;

  const BookWidget(
      {Key? key, required this.heading, required this.name, required this.enabled, required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(heading, style: TextStyle(color: colorBlack, fontWeight: FontWeight.w500),),
      trailing: enabled?SizedBox():Icon(Icons.verified_user_outlined, color: colorPrimary,size: 24,),
      subtitle: Text(name),
      leading: Icon(iconData, color: colorPrimary,),
    );
  }
}