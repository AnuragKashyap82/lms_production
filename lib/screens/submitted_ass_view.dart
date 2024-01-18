import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/utils/colors.dart';
import 'package:eduventure/utils/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';

class SubmittedAssViewScreen extends StatefulWidget {
  final snap;

  const SubmittedAssViewScreen({Key? key, required this.snap})
      : super(key: key);

  @override
  State<SubmittedAssViewScreen> createState() => _SubmittedAssViewScreenState();
}

class _SubmittedAssViewScreenState extends State<SubmittedAssViewScreen> {
  bool _isLoading = false;
  TextEditingController _obtainedMarks = TextEditingController();

  late PdfController pdfController;

  loadController() {
    pdfController = PdfController(
      document: PdfDocument.openData(InternetFile.get(widget.snap['url'])),
    );
  }

  @override
  void initState() {
    super.initState();
    loadController();
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference reference = FirebaseFirestore.instance
        .collection("classroom")
        .doc(widget.snap["classCode"])
        .collection("assignment")
        .doc(widget.snap["assignmentId"])
        .collection("submission")
        .doc(widget.snap["uid"]);

    void uploadMarks() async {
      setState(() {
        _isLoading = true;
      });
      try {
        Map<String, dynamic> data = {
          'marksObtained': _obtainedMarks.text,
        };
        await reference.update(data).whenComplete(() {
          setState(() {
            _isLoading = false;
          });
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
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: colorPrimary,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        elevation: 0,
        iconTheme:  IconThemeData(color: colorBlack),
        title: Text(
          widget.snap['assignmentName'],
          style:  TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorBlack,
          ),
        ),
      ),
      body: PdfView(
        controller: pdfController,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            context: context,
            builder: (context) => Container(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back),
                      ),
                      Expanded(
                        child: Text(
                          "Obtained Marks",
                          style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: colorPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
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
                  TextField(
                    controller: _obtainedMarks,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.assignment_outlined),
                      hintText: "Enter Obtained Marks",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: colorPrimary),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colorPrimary),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colorPrimary),
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_obtainedMarks.text.isEmpty) {
                          showSnackBar("Enter Marks Obtained", context);
                        } else {
                          uploadMarks();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          elevation: 0,
                          backgroundColor: colorPrimary),
                      child: _isLoading
                          ?  CircularProgressIndicator(
                              color: colorWhite,
                            )
                          :  Text(
                              "Submit",
                              style: TextStyle(color: colorWhite),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.edit_note_outlined),
      ),
    );
  }
}
