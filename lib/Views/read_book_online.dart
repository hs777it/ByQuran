import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:welivewithquran/constant.dart';

class ReadOnlineScreen extends StatefulWidget {
  final String fileURL;

  const ReadOnlineScreen({super.key, required this.fileURL});

  @override
  State<ReadOnlineScreen> createState() => _ReadOnlineScreenState();
}

class _ReadOnlineScreenState extends State<ReadOnlineScreen> {
  bool showWidget = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBlueDarkColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: SfPdfViewer.network(
            widget.fileURL,
            // onDocumentLoaded: (doc) {
            //   setState(() {
            //     showWidget = true;
            //   });
            // },
          ),
        ),
      ),
    );
  }
}
