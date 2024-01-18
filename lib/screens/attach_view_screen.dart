import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import '../utils/colors.dart';

class AttachmentViewScreen extends StatefulWidget {
  final String url;
  const AttachmentViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  State<AttachmentViewScreen> createState() => _AttachmentViewScreenState();
}

class _AttachmentViewScreenState extends State<AttachmentViewScreen> {

  late PdfController pdfController;

  loadController() {
    pdfController = PdfController(
        document: PdfDocument.openData(InternetFile.get(widget.url)));
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
      ),
    );
  }
}
