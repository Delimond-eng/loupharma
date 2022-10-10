import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../repositories/stock_repo/models/article.dart';
import '../../repositories/stock_repo/models/mouvement.dart';
import '../../repositories/stock_repo/models/stock.dart';
import '../../repositories/stock_repo/services/db_stock_helper.dart';
import '../../utilities/modals.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/round_icon_btn.dart';
import '../../widgets/simple_field_text.dart';

class StockCreateDrawer extends StatelessWidget {
  final Function onReload;
  const StockCreateDrawer({Key key, this.onReload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _productLabel = TextEditingController();
    var _productPrixAchat = TextEditingController();
    var _stockQte = TextEditingController();
    var _prixDevise = "USD";
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(right: 15.0),
      height: 300.0,
      width: 600.0,
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
      child: Column(
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
                  "Nouveau stock",
                  style: GoogleFonts.didactGothic(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                RoundedIconBtn(
                  size: 30.0,
                  iconColor: Colors.indigo,
                  color: Colors.white,
                  icon: CupertinoIcons.clear,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
          StatefulBuilder(builder: (context, setter) {
            return Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SimpleField(
                      hintText: "Saisir libellé de l'article... ",
                      iconColor: Colors.indigo,
                      icon: Icons.abc,
                      title: "Libellé article",
                      controller: _productLabel,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: SimpleField(
                            hintText: "Saisir prix d'achat article... ",
                            iconColor: Colors.indigo,
                            icon: Icons.monetization_on_outlined,
                            title: "Prix d'achat article",
                            controller: _productPrixAchat,
                            isCurrency: true,
                            onChangedCurrency: (value) {
                              _prixDevise = value;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Flexible(
                          child: SimpleField(
                            hintText: "Saisir qté stock... ",
                            iconColor: Colors.indigo,
                            icon: Icons.backpack_outlined,
                            title: "Quantité stock",
                            controller: _stockQte,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    CustomBtn(
                      icon: CupertinoIcons.add,
                      color: Colors.green,
                      label: "Créer compte",
                      onPressed: () async {
                        if (_productLabel.text.isEmpty) {
                          EasyLoading.showToast(
                              "Libellé de l'article requis !");
                          return;
                        }
                        if (_stockQte.text.isEmpty) {
                          EasyLoading.showToast("Quantité du stock requis !");
                          return;
                        }

                        var article = Article(
                          articleLibelle: _productLabel.text,
                        );

                        Xloading.showLottieLoading(context);
                        var db = await DbStockHelper.initDb();
                        await db
                            .insert("articles", article.toMap())
                            .then((articleId) async {
                          var stock = Stock(
                            stockPrixAchat: _productPrixAchat.text,
                            stockPrixAchatDevise: _prixDevise,
                            stockArticleId: articleId,
                          );
                          var stockId =
                              await db.insert("stocks", stock.toMap());
                          var mouvt = MouvementStock(
                            mouvtQteEn: _stockQte.text,
                            mouvtStockId: stockId,
                          );
                          await db
                              .insert("mouvements", mouvt.toMap())
                              .then((res) {
                            Xloading.dismiss();
                            XDialog.showMessage(context,
                                message: "stock crée avec succès",
                                type: "success");
                            Future.delayed(const Duration(seconds: 3), () {
                              onReload();
                            });
                          });
                        }).catchError((err) {
                          Xloading.dismiss();
                        });
                      },
                    )
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
