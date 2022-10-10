import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/topbar.dart';
import '../../global/controllers.dart';
import '../../models/operation.dart';
import '../../widgets/costum_table.dart';
import '../../widgets/round_icon_btn.dart';
import 'facture_details_modal.dart';

inventoryDetailsModal(BuildContext context, {Operations data}) {
  showDialog(
    barrierColor: Colors.black12,
    context: context,
    builder: (BuildContext context) {
      return FadeInUp(
        child: Dialog(
          insetPadding: const EdgeInsets.all(50.0),
          backgroundColor: Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ), //this right here
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                TopBar(
                  color: Colors.blue,
                  height: 70.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Inventaire détails",
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Date : ${data.operationDate}",
                              style: GoogleFonts.didactGothic(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "Compte : ${data.compte.compteLibelle}",
                              style: GoogleFonts.didactGothic(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Obx(() {
                          return ListView(
                            padding: const EdgeInsets.all(10.0),
                            children: [
                              CostumTable(
                                cols: const [
                                  "N° Fac.",
                                  "Date",
                                  "Montant",
                                  "Paiement",
                                  "Reste",
                                  "Mode",
                                  "Client",
                                  ""
                                ],
                                data: _createRows(context),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

List<DataRow> _createRows(BuildContext context) {
  return dataController.paiements
      .map(
        (p) => DataRow(
          cells: [
            DataCell(
              Text(
                p.operationFactureId.toString().padLeft(2, "0"),
                style: GoogleFonts.didactGothic(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            DataCell(
              Text(
                p.operationDate,
                style: GoogleFonts.didactGothic(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            DataCell(
              Text(
                p.facture.factureMontant,
                style: GoogleFonts.didactGothic(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            DataCell(
              Text(
                p.totalPayment.toStringAsFixed(2),
                style: GoogleFonts.didactGothic(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            DataCell(
              Text(
                (double.parse(p.facture.factureMontant) - (p.totalPayment))
                    .toStringAsFixed(2),
                style: GoogleFonts.didactGothic(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            DataCell(
              Text(
                p.operationMode,
                style: GoogleFonts.didactGothic(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            DataCell(
              Text(
                p.clientNom,
                style: GoogleFonts.didactGothic(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            DataCell(
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      elevation: 2,
                      padding: const EdgeInsets.all(8.0),
                    ),
                    child: Text(
                      "Voir détals",
                      style: GoogleFonts.didactGothic(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                      factureDetailsModal(context, p.facture);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      )
      .toList();
}
