import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tubez/entity/Film.dart';
import 'package:tubez/screens/previewScreen.dart';
import 'package:tubez/model/pdfItem.dart';
import 'package:intl/intl.dart';
import 'package:tubez/screens/payment.dart';
import 'package:barcode/barcode.dart';

Future<void> createPDF(
  Film film,
  double price,
  BuildContext context,
  String datePayment,
  Set<String> mySeats,
  int idStudio,
) async {
  final qrImage = Barcode.qrCode();

  final gambarFilm = pw.MemoryImage(
    (await rootBundle.load('assets${film.fotoFilm}')).buffer.asUint8List(),
  );

  final doc = pw.Document();

  pw.ImageProvider pdfImageProvider(Uint8List imageBytes) {
    return pw.MemoryImage(imageBytes);
  }

  // Define your page theme here
  final pdfTheme = pw.PageTheme(
    pageFormat: PdfPageFormat.a4,
    buildBackground: (pw.Context context) {
      return pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColor.fromHex('#000000'), width: 1),
          color: PdfColor.fromHex('#232323'),
        ),
      );
    },
  );

  // Add a page to the document
  doc.addPage(
    pw.Page(
      pageTheme: pdfTheme,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Column(
            children: [
              pw.Container(
                width: 400,
                height: 180,
                margin: pw.EdgeInsets.all(16),
                padding: pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                      color: PdfColor.fromHex('#000000'), width: 1),
                  borderRadius: pw.BorderRadius.circular(10),
                  color: PdfColor.fromHex('#3A3838'),
                ),
                child: pw.Row(children: [
                  pw.Container(
                      child: pw.Image(gambarFilm),
                      width: 90,
                      height: 120,
                      margin: pw.EdgeInsets.only(right: 16),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#ffffff'),
                      )),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.SizedBox(height: 20),
                        pw.Text(
                          film.judul,
                          style: pw.TextStyle(
                              fontSize: 16,
                              color: PdfColor.fromHex('#ffffff'),
                              fontWeight: pw.FontWeight.bold),
                          softWrap: true,
                          overflow: pw.TextOverflow.clip,
                        ),
                        pw.SizedBox(height: 20),
                        pw.Text(
                          "Atma Cinema",
                          style: pw.TextStyle(
                              fontSize: 12,
                              color: PdfColor.fromHex('#ffffff'),
                              fontWeight: pw.FontWeight.bold),
                          softWrap: true,
                          overflow: pw.TextOverflow.clip,
                        ),
                        pw.SizedBox(height: 20),
                        pw.Text(
                          "Universitas Atma Jaya Cinema",
                          style: pw.TextStyle(
                              fontSize: 12,
                              color: PdfColor.fromHex('#ffffff'),
                              fontWeight: pw.FontWeight.bold),
                          softWrap: true,
                          overflow: pw.TextOverflow.clip,
                        ),
                        pw.SizedBox(height: 20),
                        pw.Text(
                          datePayment,
                          style: pw.TextStyle(
                              fontSize: 12,
                              color: PdfColor.fromHex('#ffffff'),
                              fontWeight: pw.FontWeight.bold),
                          softWrap: true,
                          overflow: pw.TextOverflow.clip,
                        ),
                      ])
                ]),
              ),
              pw.Text("Your Ticket",
                  style: pw.TextStyle(color: PdfColor.fromHex('#ffffff'))),
              pw.SizedBox(height: 20),
              pw.Container( 
                child: pw.BarcodeWidget(
                  data: '${film.judul} - ${price.toString()} - ${mySeats.join(', ')}',
                  barcode: qrImage,
                  width: 200,
                  height: 200,
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#ebebeb'),
                  )
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                margin: pw.EdgeInsets.only(left: 20, right: 20),
                child: pw.Column(
                  children: [
                    pw.Row(children: [
                      pw.Text(
                        "Tickets",
                        style: pw.TextStyle(
                            color: PdfColor.fromHex('#ffffff'),
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Spacer(),
                      pw.Text(
                          "${mySeats.length} x ${currencyFormatter.format(getHargaKursi(idStudio))}",
                          style: pw.TextStyle(
                              color: PdfColor.fromHex('#ffffff'),
                              fontSize: 16)
                              ,overflow: pw.TextOverflow.clip,
                              maxLines: 3),
                    ]),
                    pw.SizedBox(height: 4),
                    pw.Row(
                      children: [
                        pw.Text(
                          " ${mySeats.join(', ')}",
                          style: pw.TextStyle(
                              color: PdfColor.fromHex('#ffffff'),
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold),
                          overflow: pw.TextOverflow.clip,
                          maxLines: 1, // Ensure text is on a single line
                        ),
                        pw.Spacer(),
                        pw.Text(
                          currencyFormatter.format(price),
                          style: pw.TextStyle(
                              color: PdfColor.fromHex('#ffffff'), fontSize: 16),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              pw.SizedBox(height: 40),
              pw.Container(
                margin: pw.EdgeInsets.symmetric(horizontal: 20),
                child: pw.Row(
                  children: [
                    pw.Text(
                      "SubTotal",
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontSize: 20,
                      ),
                    ),
                    pw.Spacer(),
                    pw.Text(
                      currencyFormatter.format(price),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                margin: pw.EdgeInsets.symmetric(horizontal: 20),
                child: pw.Row(
                  children: [
                    pw.Text(
                      "OrderFees",
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontSize: 20,
                      ),
                    ),
                    pw.Spacer(),
                    pw.Text(
                      "Rp 0",
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                margin: pw.EdgeInsets.symmetric(horizontal: 20),
                child: pw.Row(
                  children: [
                    pw.Text(
                      "Total Payment",
                      style: pw.TextStyle(
                          color: PdfColor.fromHex('#ffffff'),
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Spacer(),
                    pw.Text(
                      currencyFormatter.format(price),
                      style: pw.TextStyle(
                          color: PdfColor.fromHex('#ffffff'),
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    ),
  );
// Navigate to the preview screen only after the document is generated
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PreviewScreen(doc: doc),
    ),
  );
}
