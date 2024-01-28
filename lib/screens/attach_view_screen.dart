import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import '../Controller/user_controller.dart';
import '../utils/colors.dart';

class AttachmentViewScreen extends StatefulWidget {
  final String url;
  const AttachmentViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  State<AttachmentViewScreen> createState() => _AttachmentViewScreenState();
}

class _AttachmentViewScreenState extends State<AttachmentViewScreen> {

  bool _isLoading = false;
  late PdfController pdfController;
  late PageController pageController;
  int _currentPage = 0;
  int totalPages = 0;

  Future<void> loadController() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final pdfData = await InternetFile.get(widget.url);
      pdfController = PdfController(document: PdfDocument.openData(pdfData),);
      totalPages = (await pdfController.pagesCount)!;
      print("Anuragd $totalPages");
    } catch (e) {
      // Handle error loading PDF, you can show an error message or take appropriate action
      print('Error loading PDF: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadController();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: colorBlack),
        centerTitle: true,
        backgroundColor: colorPrimary,
        title: Text(
         "Attachment",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorBlack),
        ),
      ),
      body: PdfView(
        controller: pdfController,
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            _currentPage = page;
          });
        },
      ),
    );
  }
}
