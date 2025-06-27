import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:tubez/screens/home.dart';
import 'package:tubez/widgets/navigation.dart';

class PreviewScreen extends StatelessWidget {
  final pw.Document doc;

  const PreviewScreen({Key? key, required this.doc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Navigate directly to the home screen and remove all previous screens
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      navigationBar()), 
              (route) => false, 
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: const Text("Preview"),
      ),
      body: PdfPreview(
        build: (format) => doc.save(),
        allowSharing: true,
        allowPrinting: true,
        initialPageFormat: PdfPageFormat.a4,
      ),
    );
  }
}