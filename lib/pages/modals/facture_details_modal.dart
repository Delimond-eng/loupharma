import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/topbar.dart';
import '../../global/utils.dart';
import '../../models/client.dart';
import '../../models/facture.dart';
import '../../models/facture_detail.dart';
import '../../reports/report.dart';
import '../../services/db_helper.dart';
import '../../widgets/costum_table.dart';
import '../../widgets/round_icon_btn.dart';
import '../../widgets/tot_info_view.dart';
import 'print_modal.dart';

factureDetailsModal(BuildContext context, Facture facture) async {
  List<FactureDetail> _items = <FactureDetail>[];
  var _client = Client();
  var db = await DbHelper.initDb();

  await db.query("clients",
      where: "client_id=?", whereArgs: [facture.factureClientId]).then(
    (res) {
      _client = Client.fromMap(res.first);
    },
  );
  await db.query("facture_details",
      where: "facture_id=?", whereArgs: [facture.factureId]).then(
    (res) {
      for (var item in res) {
        _items.add(FactureDetail.fromMap(item));
      }
    },
  );

  /* LAST PAYMENT */

  double _lastAmount = 0;
  var lastPayment =
      await Report.checkLastPay(int.parse(facture.factureId.toString()));
  if (lastPayment != null) {
    _lastAmount = lastPayment;
  }
  /* END CHECKING */

  showDialog(
    barrierColor: Colors.black12,
    context: context,
    builder: (BuildContext context) {
      return FadeInRight(
        child: Dialog(
          insetPadding: const EdgeInsets.all(100.0),
          backgroundColor: Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ), //this right here
          child: SizedBox(
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
                          "Facture détails",
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                    flex: 6,
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(.1),
                                            blurRadius: 5,
                                            offset: const Offset(0, 1),
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Client infos",
                                              style: GoogleFonts.didactGothic(
                                                color: Colors.indigo,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            _clientInfoField(
                                              title: "Nom",
                                              value: _client.clientNom,
                                            ),
                                            _clientInfoField(
                                              title: "Téléphone",
                                              value: _client.clientTel,
                                            ),
                                            _clientInfoField(
                                              title: "Adresse",
                                              value: _client.clientAdresse,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Flexible(
                                    flex: 6,
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(.1),
                                            blurRadius: 5,
                                            offset: const Offset(0, 1),
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Paiement infos",
                                                  style:
                                                      GoogleFonts.didactGothic(
                                                    color: Colors.indigo,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                _statusBuilder(facture)
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            TotItem(
                                              alignment:
                                                  MainAxisAlignment.start,
                                              title: "Montant en USD",
                                              value: facture.factureMontant,
                                              currency: facture.factureDevise,
                                            ),
                                            TotItem(
                                              alignment:
                                                  MainAxisAlignment.start,
                                              title: "Eq. en CDF",
                                              value:
                                                  '${convertDollarsToCdf(double.parse(facture.factureMontant))}',
                                              currency: "CDF",
                                            ),
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: TotItem(
                                                    alignment:
                                                        MainAxisAlignment.start,
                                                    title: "Montant payé",
                                                    value:
                                                        _lastAmount.toString(),
                                                    fSize: 25.0,
                                                    currency:
                                                        facture.factureDevise,
                                                    color: Colors.green[800],
                                                  ),
                                                ),
                                                const Text("|"),
                                                Flexible(
                                                  child: TotItem(
                                                    alignment:
                                                        MainAxisAlignment.start,
                                                    title: "Montant restant",
                                                    value: (double.parse(facture
                                                                .factureMontant) -
                                                            _lastAmount)
                                                        .toStringAsFixed(2)
                                                        .toString(),
                                                    color: Colors.pink[700],
                                                    fSize: 25.0,
                                                    currency:
                                                        facture.factureDevise,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            _dataTableView(context, items: _items)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(20.0),
                                backgroundColor: Colors.grey[800],
                              ),
                              child: Text(
                                "Fermer",
                                style: GoogleFonts.didactGothic(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                showPrintViewer(
                                  context,
                                  factureId: facture.factureId,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(20.0),
                                backgroundColor: Colors.blue,
                              ),
                              icon: const Icon(CupertinoIcons.printer_fill,
                                  size: 15.0),
                              label: Text(
                                "Imprimer facture",
                                style: GoogleFonts.didactGothic(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
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

Widget _statusBuilder(Facture facture) {
  return Row(
    children: [
      Text(
        "Status : ",
        style: GoogleFonts.didactGothic(
          color: Colors.black,
          fontSize: 15.0,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(
        width: 5.0,
      ),
      Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: (facture.factureStatut == "paie")
              ? Colors.green[200]
              : Colors.pink[100],
          borderRadius: BorderRadius.circular(3.0),
        ),
        child: Text(
          facture.factureStatut,
          style: GoogleFonts.didactGothic(
            fontWeight: FontWeight.w600,
            fontSize: 12.0,
            color: (facture.factureStatut == "paie")
                ? Colors.green[700]
                : Colors.pink,
          ),
        ),
      ),
    ],
  );
}

Widget _clientInfoField({String title, String value}) {
  return Container(
    height: 40.0,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(bottom: BorderSide(color: Colors.grey[300])),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$title : ",
                    style: GoogleFonts.didactGothic(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: "$value ",
                    style: GoogleFonts.didactGothic(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

_dataTableView(BuildContext context, {List<FactureDetail> items}) {
  return Expanded(
    child: ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5.0,
      ),
      children: [
        CostumTable(
          cols: const ["Libellé", "PU", "QTE", "TOTAL"],
          data: items
              .map(
                (item) => DataRow(
                  cells: [
                    DataCell(
                      Text(
                        item.factureDetailLibelle,
                        style: GoogleFonts.didactGothic(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.factureDetailPu.toString()} ${item.factureDetailDevise}',
                        style: GoogleFonts.didactGothic(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        item.factureDetailQte.toString(),
                        style: GoogleFonts.didactGothic(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.total} ${item.factureDetailDevise}',
                        style: GoogleFonts.didactGothic(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    ),
  );
}
