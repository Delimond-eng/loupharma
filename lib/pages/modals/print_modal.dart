import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';

import '../../services/db_manager.dart';
import 'package:pdf/pdf.dart';

import '../../services/print_service.dart';
import '../../widgets/round_icon_btn.dart';

showPrintViewer(BuildContext context, {factureId}) async {
  var invoice = await DataManager.getFactureInvoice(factureId: factureId);
  if (invoice != null) {
    PdfPageFormat pageFormat = PdfPageFormat.standard;
    PrintingBuilder printPdf = PrintingBuilder(invoice: invoice);
    var bytesPdf = await printPdf.buildPdf(pageFormat);
    showDialog(
        barrierColor: Colors.black12,
        context: context,
        builder: (BuildContext context) {
          return FadeIn(
            child: Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 120.0,
                vertical: 30.0,
              ),
              backgroundColor: Colors.white,
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      color: Colors.grey,
                      height: 60.0,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Impression de la facture",
                              style: GoogleFonts.didactGothic(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            RoundedIconBtn(
                              size: 30.0,
                              iconColor: Colors.pink,
                              color: Colors.white,
                              icon: CupertinoIcons.clear,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Builder(builder: (context) {
                        return PdfPreview(
                          maxPageWidth: 800,
                          build: (format) => bytesPdf,
                          pdfPreviewPageDecoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(.2),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          canChangePageFormat: true,
                          allowPrinting: true,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
