import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../global/controllers.dart';
import '../../models/operation.dart';
import '../../services/db_helper.dart';
import '../../utilities/modals.dart';
import '../../widgets/costum_table.dart';
import '../../widgets/round_icon_btn.dart';

class PaymentDetailsDrawer extends StatelessWidget {
  const PaymentDetailsDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(right: 15.0),
      height: 350.0,
      width: MediaQuery.of(context).size.width / 1.50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.3),
            blurRadius: 10.0,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.indigo,
              ),
              width: double.infinity,
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Détails paiement de la facture n° ${dataController.paiementDetails.first.operationFactureId}",
                    style: GoogleFonts.didactGothic(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
            Expanded(
              child: ListView(
                children: [
                  CostumTable(
                    cols: const [
                      "Date",
                      "Montant",
                      "Paiement",
                      "Mode",
                      "Client",
                      ""
                    ],
                    data: _createRows(context),
                  )
                ],
              ),
            )
          ],
        );
      }),
    );
  }

  List<DataRow> _createRows(BuildContext context) {
    return dataController.paiementDetails
        .map(
          (data) => DataRow(
            cells: [
              DataCell(
                Text(
                  data.operationDate,
                  style: GoogleFonts.didactGothic(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '${data.facture.factureMontant} ${data.operationDevise}',
                  style: GoogleFonts.didactGothic(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '${data.operationMontant} ${data.operationDevise}',
                  style: GoogleFonts.didactGothic(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataCell(
                Text(
                  data.operationMode,
                  style: GoogleFonts.didactGothic(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataCell(
                Text(
                  data.clientNom,
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
                          backgroundColor:
                              authController.loggedUser.value.userRole ==
                                      "admin"
                                  ? Colors.pink
                                  : Colors.grey[600],
                          elevation: 2,
                          padding: const EdgeInsets.all(8.0),
                        ),
                        child: Text(
                          "Supprimer",
                          style: GoogleFonts.didactGothic(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                        onPressed: () {
                          if (authController.loggedUser.value.userRole ==
                              "admin") {
                            _deleteOperation(context, data);
                          }
                        }),
                  ],
                ),
              )
            ],
          ),
        )
        .toList();
  }

  _deleteOperation(BuildContext context, Operations data) async {
    var db = await DbHelper.initDb();
    // ignore: use_build_context_synchronously
    XDialog.show(context,
        message: "Etes-vous sûr de vouloir supprimer ce paiement ?",
        onValidated: () async {
      Xloading.showLottieLoading(context);
      await db
          .update('factures', {'facture_statut': 'en cours'},
              where: 'facture_id = ?', whereArgs: [data.operationFactureId])
          .then((id) async {
        await db.update(
          "operations",
          {"operation_state": "deleted"},
          where: "operation_id=?",
          whereArgs: [data.operationId],
        );
        Xloading.dismiss();
        Navigator.pop(context);
        XDialog.showMessage(context,
            message: "Le paiement a été retiré avec succès !");
        dataController.loadPayments("all");
      });
    }, onFailed: () {});
  }
}
