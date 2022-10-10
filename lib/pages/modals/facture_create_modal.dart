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
import '../../models/client.dart';
import '../../models/facture.dart';
import '../../models/facture_detail.dart';
import '../../services/db_helper.dart';
import '../../services/native_db_helper.dart';
import '../../utilities/modals.dart';
import '../../widgets/costum_table.dart';
import '../../widgets/round_icon_btn.dart';
import '../../widgets/simple_field_text.dart';
import '../../widgets/tot_info_view.dart';
import 'costumer_create_modal.dart';

createFactureModal(BuildContext context,
    {bool showClientList = true, Client client}) async {
  var clients = dataController.clients;
  var selectedClient = client;
  //inputs selectors
  var _title = TextEditingController();
  var _pu = TextEditingController();
  var _qty = TextEditingController();
  var _devise = "USD";
  var _dateCreate;

  //items list
  List<FactureDetail> items = <FactureDetail>[];

  showDialog(
    barrierColor: Colors.black12,
    context: context,
    builder: (BuildContext context) {
      return FadeInDown(
        child: Dialog(
          insetPadding: const EdgeInsets.all(50.0),
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
                          "Création nouvelle facture",
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
                StatefulBuilder(builder: (context, setter) {
                  return Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showClientList) ...[
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              margin: const EdgeInsets.fromLTRB(
                                  10.0, 0, 10.0, 10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(.3),
                                    blurRadius: 10.0,
                                    offset: const Offset(0, 10),
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SimpleField(
                                      icon: CupertinoIcons.search,
                                      hintText: "Rechercher client...",
                                      iconColor: Colors.grey[500],
                                      title: "Recherche",
                                      onChanged: (value) async {
                                        var json = await NativeDbHelper.rawQuery(
                                            "SELECT * FROM clients WHERE NOT client_state='deleted' AND client_nom LIKE '%$value%'");

                                        clients.clear();
                                        json.forEach((e) {
                                          setter(() {
                                            clients.add(Client.fromMap(e));
                                          });
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      padding: const EdgeInsets.all(8.0),
                                      child: (clients.isEmpty)
                                          ? _emptyView(context)
                                          : Column(
                                              children: [
                                                ...clients.map((client) {
                                                  return FactureCostumerCard(
                                                    isSelected:
                                                        (selectedClient != null)
                                                            ? (client
                                                                    .clientId ==
                                                                selectedClient
                                                                    .clientId)
                                                            : false,
                                                    data: client,
                                                    onSelected: () {
                                                      setter(() {
                                                        selectedClient = client;
                                                      });
                                                    },
                                                  );
                                                })
                                              ],
                                            ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                        Expanded(
                          flex: 8,
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
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Facture Items",
                                            style: GoogleFonts.didactGothic(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          if (selectedClient != null) ...[
                                            Text(
                                              "CLIENT : ${selectedClient.clientNom}",
                                              style: GoogleFonts.didactGothic(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ] else ...[
                                            Text(
                                              "Sélectionnez un client !",
                                              style: GoogleFonts.didactGothic(
                                                color: Colors.pink,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ]
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 250,
                                        child: SimpleField(
                                          filledColor: Colors.white,
                                          iconColor: Colors.pink,
                                          icon: Icons.calendar_month_outlined,
                                          title: "Date création",
                                          isDate: true,
                                          onDatePicked: (timestamp) {
                                            _dateCreate = timestamp;
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10.0, 10, 10.0, 10.0),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: SimpleField(
                                              filledColor: Colors.white,
                                              hintText: "Saisir le titre...",
                                              icon: Icons.abc_rounded,
                                              title: "Titre",
                                              iconColor: Colors.blue,
                                              controller: _title,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          Flexible(
                                            child: SimpleField(
                                              filledColor: Colors.white,
                                              hintText:
                                                  "Saisir prix unitaire...",
                                              icon: Icons.monetization_on_sharp,
                                              title: "Prix unitaire",
                                              iconColor: Colors.blue,
                                              controller: _pu,
                                              isCurrency: true,
                                              onChangedCurrency: (value) {
                                                setter(() => _devise = value);
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          Flexible(
                                            child: SimpleField(
                                              filledColor: Colors.white,
                                              hintText: "Saisir quantité...",
                                              icon: Icons
                                                  .stacked_line_chart_outlined,
                                              title: "Quantité",
                                              iconColor: Colors.blue,
                                              controller: _qty,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 25.0,
                                            ),
                                            child: SizedBox(
                                              height: 47.0,
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  if (_title.text.isEmpty ||
                                                      _pu.text.isEmpty ||
                                                      _qty.text.isEmpty) {
                                                    EasyLoading.showToast(
                                                        "Veuillez entrer toutes les informations requises !");
                                                    return;
                                                  }
                                                  try {
                                                    var item = FactureDetail(
                                                      factureDetailLibelle:
                                                          _title.text,
                                                      factureDetailPu: _pu.text
                                                          .replaceAll(',', '.'),
                                                      factureDetailQte: _qty
                                                          .text
                                                          .replaceAll(',', '.'),
                                                      factureDetailDevise:
                                                          _devise,
                                                    );
                                                    setter(() {
                                                      items.add(item);
                                                      _title.text = "";
                                                      _pu.text = "";
                                                      _qty.text = "";
                                                    });
                                                  } catch (e) {
                                                    EasyLoading.showToast(
                                                        "Veuillez verifier les données entrées !");
                                                    return;
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  backgroundColor: Colors.blue,
                                                ),
                                                icon: const Icon(
                                                  Icons.add,
                                                  size: 15.0,
                                                ),
                                                label: Text(
                                                  "ajouter",
                                                  style:
                                                      GoogleFonts.didactGothic(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    _dataTableView(context,
                                        items: items, setter: setter)
                                  ],
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
                                        if (selectedClient == null) {
                                          XDialog.showMessage(
                                            context,
                                            message:
                                                "Veuillez sélectionner un client propriétaire de la facture !",
                                            type: "warning",
                                          );
                                          return;
                                        }
                                        if (items.isEmpty) {
                                          XDialog.showMessage(
                                            context,
                                            message:
                                                "Veuillez créer des items pour la facture avant d'effectuer cette action !",
                                            type: "warning",
                                          );
                                          return;
                                        }
                                        var db = await DbHelper.initDb();
                                        //calculate facture amount //
                                        double total = 0.0;
                                        double currentTot = 0.0;
                                        for (var e in items) {
                                          if (e.factureDetailDevise == "CDF") {
                                            currentTot =
                                                convertCdfToDollars(e.total);
                                          } else {
                                            currentTot = e.total;
                                          }
                                          total += currentTot;
                                        }
                                        // end //

                                        //create facture statment. //
                                        var facture = Facture(
                                          factureClientId:
                                              selectedClient.clientId,
                                          factureDevise: "USD",
                                          factureMontant: total.toString(),
                                          factureTimestamp: _dateCreate,
                                        );
                                        Xloading.showLottieLoading(context);
                                        await db
                                            .insert(
                                          "factures",
                                          facture.toMap(),
                                        )
                                            .then(
                                          (factureId) async {
                                            for (var item in items) {
                                              item.factureId = factureId;
                                              await db.insert(
                                                "facture_details",
                                                item.toMap(),
                                              );
                                            }
                                            Xloading.dismiss();

                                            dataController
                                                .refreshDashboardCounts();
                                            Get.back();
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 500), () {
                                              navigatorController
                                                  .navigateTo("/");
                                            });
                                          },
                                        );

                                        // end //
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(20.0),
                                        backgroundColor: Colors.green,
                                      ),
                                      child: Text(
                                        "Créer facture",
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
                  );
                })
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _emptyView(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Aucun client répertorié \n Veuillez créer un client puis continuer !",
          textAlign: TextAlign.center,
          style: GoogleFonts.didactGothic(
            color: Colors.pink,
            fontSize: 15.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        ElevatedButton.icon(
          onPressed: () {
            createCostumerModal(context);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(18.0),
            backgroundColor: Colors.pink,
          ),
          icon: const Icon(
            Icons.add,
            size: 15.0,
          ),
          label: Text(
            "Créer un client",
            style: GoogleFonts.didactGothic(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    ),
  );
}

_dataTableView(BuildContext context, {List<FactureDetail> items, setter}) {
  double total = 0.0;
  double currentTot = 0.0;
  items.forEach((e) {
    if (e.factureDetailDevise == "CDF") {
      currentTot = convertCdfToDollars(e.total);
    } else {
      currentTot = e.total;
    }
    total += currentTot;
  });
  return Expanded(
    child: ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5.0,
      ),
      children: [
        CostumTable(
          cols: const ["Libellé", "PU", "QTE", "TOTAL", ""],
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
                        '${item.factureDetailPu} ${item.factureDetailDevise}',
                        style: GoogleFonts.didactGothic(
                          fontSize: 16,
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
                    DataCell(Row(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.pink,
                            elevation: 2,
                            padding: const EdgeInsets.all(8.0),
                          ),
                          child: Text(
                            "Effacer",
                            style: GoogleFonts.didactGothic(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                          onPressed: () {
                            setter(() {
                              items.removeWhere((s) =>
                                  s.factureDetailLibelle ==
                                  item.factureDetailLibelle);
                            });
                          },
                        ),
                      ],
                    ))
                  ],
                ),
              )
              .toList(),
        ),
        TotItem(
          title: "Net à payer",
          currency: "USD",
          value: total.toStringAsFixed(2),
        ),
        TotItem(
          title: "Eq. en CDF",
          currency: "CDF",
          value: "${convertDollarsToCdf(total)}",
        ),
      ],
    ),
  );
}

class FactureCostumerCard extends StatelessWidget {
  final bool isSelected;
  final Client data;
  final Function onSelected;
  const FactureCostumerCard({
    Key key,
    this.isSelected = false,
    this.data,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 8.0),
      height: 45.0,
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.grey[50],
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.2),
            offset: const Offset(0, 1),
            blurRadius: 1,
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(4.0),
          onTap: onSelected,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              children: [
                if (isSelected) ...[
                  const Icon(
                    CupertinoIcons.square_arrow_right_fill,
                    color: Colors.white,
                    size: 15.0,
                  ),
                ] else ...[
                  const Icon(
                    CupertinoIcons.square_arrow_right,
                    color: Colors.blue,
                    size: 15.0,
                  ),
                ],
                const SizedBox(
                  width: 8.0,
                ),
                Text(
                  data.clientNom,
                  style: GoogleFonts.didactGothic(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
