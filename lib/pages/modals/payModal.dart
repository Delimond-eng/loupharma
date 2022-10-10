// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/topbar.dart';
import '../../global/controllers.dart';
import '../../global/utils.dart';
import '../../models/compte.dart';
import '../../models/facture.dart';
import '../../models/operation.dart';
import '../../reports/report.dart';
import '../../services/db_helper.dart';
import '../../utilities/modals.dart';
import '../../widgets/costum_dropdown.dart';
import '../../widgets/round_icon_btn.dart';
import '../../widgets/simple_field_text.dart';

showPayModal(BuildContext context, Facture selectedFac) async {
  Compte _selectedCompte;
  String _selectedMode;
  String _devise = "USD";
  int _datePaie;

  var _textMontant = TextEditingController();
  var lastPayment = await Report.checkLastPay(selectedFac.factureId);
  if (lastPayment != null) {
    var currentAmount = double.parse(selectedFac.factureMontant) - lastPayment;
    _textMontant.text = currentAmount.toStringAsFixed(2);
  } else {
    _textMontant.text = selectedFac.factureMontant;
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
                  color: Colors.green,
                  height: 70.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Paiement facture",
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: SimpleField(
                                iconColor: Colors.pink,
                                icon: Icons.calendar_month_outlined,
                                title: "Date paiement",
                                isDate: true,
                                onDatePicked: (timestamp) {
                                  _datePaie = timestamp;
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            Flexible(
                              child: SimpleField(
                                hintText: "Saisir le montant paiement... ",
                                iconColor: Colors.green,
                                icon: CupertinoIcons.money_dollar_circle_fill,
                                title: "Montant paiement",
                                controller: _textMontant,
                                isCurrency: true,
                                selectedCurrency: _devise,
                                onChangedCurrency: (devise) {
                                  _devise = devise;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: DropField(
                                filledColor: Colors.grey[300],
                                hintText: "Sélectionnez le mode de paiement",
                                icon: CupertinoIcons.creditcard,
                                iconColor: Colors.green,
                                onChanged: (value) {
                                  _selectedMode = value;
                                },
                                data: const [
                                  "Cash",
                                  "Paiement mobile",
                                  "Virement",
                                  "Chèque",
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            Flexible(
                              child: Container(
                                height: 50.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.grey[300],
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 1.0,
                                      color: Colors.black.withOpacity(.1),
                                      offset: const Offset(0, 1),
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // ignore: prefer_const_constructors
                                      Icon(
                                        CupertinoIcons.cube_box,
                                        color: Colors.indigo,
                                        size: 18.0,
                                      ),
                                      const SizedBox(
                                        width: 8.0,
                                      ),
                                      Flexible(
                                        child: StatefulBuilder(
                                            builder: (context, setter) {
                                          return Obx(
                                            () => DropdownButton(
                                              menuMaxHeight: 300,
                                              dropdownColor: Colors.white,
                                              alignment: Alignment.centerLeft,
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              style: GoogleFonts.didactGothic(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              value: _selectedCompte,
                                              underline: const SizedBox(),
                                              hint: Text(
                                                "Sélectionnez un compte...",
                                                style: GoogleFonts.didactGothic(
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              isExpanded: true,
                                              items: dataController.comptes
                                                  .map((e) {
                                                return DropdownMenuItem<Compte>(
                                                  value: e,
                                                  child: Text(
                                                    e.compteLibelle,
                                                    style: GoogleFonts
                                                        .didactGothic(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setter(() {
                                                  _selectedCompte = value;
                                                });
                                              },
                                            ),
                                          );
                                        }),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                          /* check empty fields */
                          if (_textMontant.text.isEmpty) {
                            EasyLoading.showToast(
                                "Vous devez entrer le montant du paiement !");
                            return;
                          }
                          if (_selectedMode == null) {
                            EasyLoading.showToast(
                                "Vous devez sélectionner un mode de paiement !");
                            return;
                          }
                          if (_selectedCompte == null) {
                            XDialog.showMessage(
                              context,
                              message:
                                  "Veuillez sélectionner le compte où le paiement sera stocké !",
                              type: "warning",
                            );
                            return;
                          }
                          /* end check empty fields */

                          /* check last pay */
                          var lastPay =
                              await Report.checkLastPay(selectedFac.factureId);
                          /* end check last pay */

                          var convertedInputAmount =
                              double.parse(_textMontant.text);
                          if (_devise == "CDF") {
                            convertedInputAmount = double.parse(
                              convertCdfToDollars(convertedInputAmount)
                                  .toStringAsFixed(2),
                            );
                          }
                          double checkAmount = 0;
                          double factureAmount =
                              double.parse(selectedFac.factureMontant);
                          if (lastPay == null) {
                            checkAmount = factureAmount - convertedInputAmount;
                            if (checkAmount.isNegative) {
                              XDialog.showMessage(
                                context,
                                message:
                                    "Le montant de paiement saisi dépasse le frais de la facture sélectionnée !",
                                type: "warning",
                              );
                              return;
                            }
                          } else {
                            double c = factureAmount - lastPay;
                            checkAmount = c - convertedInputAmount;
                            if (c == 0) {
                              XDialog.showMessage(
                                context,
                                message:
                                    "Cette facture a été déjà payé à la totalité !",
                                type: "warning",
                              );
                              return;
                            }

                            if (checkAmount.isNegative) {
                              XDialog.showMessage(
                                context,
                                message:
                                    "Le montant de paiement saisi dépasse le frais restant de la facture sélectionnée !",
                                type: "warning",
                              );
                              return;
                            }
                          }
                          /**Creating payment  statment**/
                          Xloading.showLottieLoading(context);
                          var data = Operations(
                            operationCompteId: _selectedCompte.compteId,
                            operationDevise: _devise,
                            operationFactureId: selectedFac.factureId,
                            operationLibelle: "Paiement facture",
                            operationMontant: convertedInputAmount,
                            operationType: "entrée",
                            operationUserId:
                                authController.loggedUser.value.userId,
                            operationMode: _selectedMode,
                            operationTimestamp: _datePaie,
                          );

                          /* Insert data from database */
                          var db = await DbHelper.initDb();
                          await db
                              .insert("operations", data.toMap())
                              .then((resId) async {
                            if (checkAmount == 0) {
                              /* check if payment is all ready */
                              await db.update(
                                "factures",
                                {"facture_statut": "paie"},
                                where: "facture_id= ?",
                                whereArgs: [selectedFac.factureId],
                              );
                              /* end statment */
                            }
                            Xloading.dismiss();

                            Get.back();
                            // ignore: use_build_context_synchronously
                            XDialog.showMessage(
                              context,
                              message: "Paiement effectué avec succès !",
                              type: "success",
                            );
                            dataController.countDaySum();
                            navigatorController.navigateTo('/paiements');
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20.0),
                          backgroundColor: Colors.green,
                        ),
                        child: Text(
                          "Valider le paiement",
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
