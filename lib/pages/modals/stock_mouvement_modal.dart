import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/topbar.dart';
import '../../repositories/stock_repo/models/article.dart';
import '../../repositories/stock_repo/models/mouvement.dart';
import '../../repositories/stock_repo/models/stock.dart';
import '../../repositories/stock_repo/services/db_stock_helper.dart';
import '../../utilities/modals.dart';
import '../../widgets/round_icon_btn.dart';
import '../../widgets/simple_field_text.dart';

showStokMouvementModal(BuildContext context, String title,
    {Function onReload, Article a, Stock s, bool isEn = false, Color color}) {
  var _textQte = TextEditingController();
  var _textPrix = TextEditingController();
  int _dateMouvt;
  var _selectedCurrency = "";

  if (isEn) {
    _textPrix.text = s.stockPrixAchat.toString();
    _selectedCurrency = s.stockPrixAchatDevise;
  }

  showDialog(
    barrierColor: Colors.black12,
    context: context,
    builder: (BuildContext context) {
      return FadeInRight(
        child: Dialog(
          insetPadding: const EdgeInsets.all(20.0),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ), //this right here
          child: Container(
            color: Colors.white,
            height: 350.0,
            width: MediaQuery.of(context).size.width / 1.80,
            child: Column(
              children: [
                TopBar(
                  color: color ?? Colors.indigo,
                  height: 70.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.didactGothic(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        RoundedIconBtn(
                          size: 30.0,
                          iconColor: color ?? Colors.indigo,
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: SimpleField(
                                iconColor: color ?? Colors.indigo,
                                icon: Icons.calendar_month_outlined,
                                title: "Date mouvement",
                                isDate: true,
                                onDatePicked: (timestamp) {
                                  _dateMouvt = timestamp;
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            Flexible(
                              child: SimpleField(
                                hintText: s == null
                                    ? "Saisir la quantité à entrer... "
                                    : "Saisir la quantité à sortir...",
                                iconColor: color ?? Colors.indigo,
                                icon: Icons.backpack_rounded,
                                title: s == null
                                    ? "Quantité sortie"
                                    : "Quantité sortie",
                                controller: _textQte,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        if (isEn) ...[
                          SimpleField(
                            hintText: "Saisir prix d'achat... ",
                            iconColor: color ?? Colors.indigo,
                            icon: CupertinoIcons.money_dollar_circle_fill,
                            title: "Prix achat",
                            controller: _textPrix,
                            isCurrency: true,
                            selectedCurrency: _selectedCurrency,
                            onChangedCurrency: (val) {
                              _selectedCurrency = val;
                            },
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20.0),
                          backgroundColor: Colors.grey[800],
                        ),
                        child: Text(
                          "Annuler",
                          style: GoogleFonts.didactGothic(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (!_textQte.text.isNum) {
                            EasyLoading.showToast(
                                "veuillez saisir une quantité en chiffre !");
                            return;
                          }

                          /* check empty fields */
                          if (_textQte.text.isEmpty) {
                            EasyLoading.showToast(
                                "Quantité stock entrée requise !");
                            return;
                          }
                          var db = await DbStockHelper.initDb();
                          if (isEn) {
                            if (!_textPrix.text.isNum) {
                              EasyLoading.showToast(
                                  "veuillez saisir le prix d'achat en chiffre !");
                              return;
                            }
                            if ((_selectedCurrency == s.stockPrixAchatDevise) &&
                                (double.parse(s.stockPrixAchat.toString()) ==
                                    double.parse(_textPrix.text))) {
                              var m = MouvementStock(
                                mouvtQteEn: int.parse(_textQte.text),
                                mouvtTimestamp: _dateMouvt,
                                mouvtStockId: s.stockId,
                              );
                              await db
                                  .insert("mouvements", m.toMap())
                                  .then((vid) {
                                XDialog.showMessage(context,
                                    message: "Stock mis à jour avec succès !");
                                Future.delayed(const Duration(seconds: 3), () {
                                  onReload();
                                });
                              });
                            } else {
                              XDialog.show(context,
                                  message:
                                      "En changeant le prix d'achat vous créez un autre stock de l'article ${a.articleLibelle} !",
                                  onValidated: () async {
                                var stock = Stock(
                                  stockArticleId: a.articleId,
                                  stockPrixAchat: double.parse(_textPrix.text),
                                  stockPrixAchatDevise: _selectedCurrency,
                                );

                                await db
                                    .insert("stocks", stock.toMap())
                                    .then((stockId) async {
                                  var ms = MouvementStock(
                                    mouvtQteEn: int.parse(_textQte.text),
                                    mouvtTimestamp: _dateMouvt,
                                    mouvtStockId: stockId,
                                  );
                                  await db
                                      .insert("mouvements", ms.toMap())
                                      .then((res) {
                                    XDialog.showMessage(context,
                                        message:
                                            "Stock mis à jour avec succès !");
                                    Future.delayed(const Duration(seconds: 3),
                                        () {
                                      onReload();
                                    });
                                  });
                                });
                              }, onFailed: () {});
                            }
                          } else {
                            var ms = MouvementStock(
                              mouvtQteSo: int.parse(_textQte.text),
                              mouvtTimestamp: _dateMouvt,
                              mouvtStockId: s.stockId,
                            );
                            int last = s.solde;
                            int n = int.parse(_textQte.text);

                            if (n > last) {
                              EasyLoading.showToast("stock insuffisant !");
                              return;
                            }
                            if (s.solde <= 0) {
                              EasyLoading.showToast("stock inactif !");
                              return;
                            }
                            await db
                                .insert("mouvements", ms.toMap())
                                .then((resId) {
                              XDialog.showMessage(context,
                                  message:
                                      "Sortie stock effectuée avec succès !");
                              Future.delayed(const Duration(seconds: 3), () {
                                onReload();
                              });
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20.0),
                          backgroundColor: Colors.green,
                        ),
                        child: Text(
                          "Valider l'opération",
                          style: GoogleFonts.didactGothic(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
