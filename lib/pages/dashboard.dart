import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/controllers.dart';
import '../models/facture.dart';
import '../services/db_helper.dart';
import '../services/native_db_helper.dart';
import '../utilities/modals.dart';
import '../widgets/costum_table.dart';
import '../widgets/custom_page.dart';
import '../widgets/dash_card.dart';
import '../widgets/empty_table.dart';
import '../widgets/search_input.dart';
import 'components/edit_currency_drawer.dart';
import 'modals/facture_details_modal.dart';
import 'modals/payModal.dart';
import 'modals/selling_info_modal.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    dataController.countDaySum();
    dataController.refreshDashboardCounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const EditCurrencyDrawer(),
      drawerScrimColor: Colors.transparent,
      body: CustomPage(
        title: "Tableau de bord",
        child: LayoutBuilder(
          builder: (context, constraint) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dashContent(context),
                const SizedBox(
                  height: 10.0,
                ),
                _currencyContent(context),
                _searchPart(),
                Expanded(
                  child: Obx(() {
                    return FadeInUpBig(
                      child: dataController.factures.isEmpty
                          ? const EmptyTable()
                          : ListView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 5.0,
                              ),
                              children: [
                                CostumTable(
                                  cols: const [
                                    "N° Fac.",
                                    "Date",
                                    "Montant",
                                    "Status",
                                    "Client",
                                    ""
                                  ],
                                  data: _createRows(),
                                ),
                              ],
                            ),
                    );
                  }),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _searchPart() {
    return FadeInUp(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Liste des facture en cours",
              style: GoogleFonts.didactGothic(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            Flexible(
              child: SearchInput(
                hintText: "Recherche facture par nom du client ...",
                onChanged: (value) async {
                  var json = await NativeDbHelper.rawQuery(
                      "SELECT * FROM factures INNER JOIN clients ON factures.facture_client_id = clients.client_id WHERE factures.facture_statut = 'en cours' AND NOT factures.facture_state='deleted' AND clients.client_nom LIKE '%$value%'");
                  dataController.factures.clear();
                  json.forEach((e) {
                    dataController.factures.add(Facture.fromMap(e));
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _currencyContent(BuildContext context) {
    return FadeInUp(
      child: Row(
        children: [
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 5.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(color: Colors.blue, width: .3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.1),
                    blurRadius: 5.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 5.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Paiements journaliers",
                          style: GoogleFonts.didactGothic(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Obx(() {
                          return RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: dataController.daySellCount.value
                                      .toStringAsFixed(2),
                                  style: GoogleFonts.staatliches(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 25.0,
                                  ),
                                ),
                                TextSpan(
                                  text: " USD",
                                  style: GoogleFonts.didactGothic(
                                    color: Colors.blue,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          );
                        })
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.all(20.0),
                      ),
                      onPressed: () {
                        sellingInfoModal(context);
                      },
                      label: Text(
                        "Voir détails",
                        style: GoogleFonts.didactGothic(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      icon: const Icon(
                        Icons.remove_red_eye,
                        size: 15.0,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 5.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(color: Colors.pink, width: .3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.1),
                    blurRadius: 5.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 5.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Taux du jour",
                          style: GoogleFonts.didactGothic(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Obx(
                          () => RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: dataController
                                      .currency.value.currencyValue,
                                  style: GoogleFonts.staatliches(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 25.0,
                                  ),
                                ),
                                TextSpan(
                                  text: " CDF",
                                  style: GoogleFonts.didactGothic(
                                    color: Colors.pink,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            authController.loggedUser.value.userRole == "admin"
                                ? Colors.pink
                                : Colors.grey[600],
                        padding: const EdgeInsets.all(20.0),
                      ),
                      onPressed: () async {
                        if (authController.loggedUser.value.userRole ==
                            "admin") {
                          _scaffoldKey.currentState.openEndDrawer();
                        }
                      },
                      label: Text(
                        "Mettre à jour",
                        style: GoogleFonts.didactGothic(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      icon: const Icon(
                        Icons.edit,
                        size: 15.0,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dashContent(BuildContext context) {
    return Obx(() {
      return FadeInUp(
        child: GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 2.5,
            crossAxisCount: 4,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: dataController.dashboardCounts.length,
          itemBuilder: ((context, index) {
            var count = dataController.dashboardCounts[index];
            return DashCard(
              icon: count.icon,
              title: count.title,
              value: count.countValue.toString(),
              color: count.color,
            );
          }),
        ),
      );
    });
  }

  List<DataRow> _createRows() {
    return dataController.factures
        .map(
          (fac) => DataRow(
            cells: [
              DataCell(
                Text(
                  fac.factureId.toString(),
                  style: GoogleFonts.didactGothic(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataCell(
                Text(
                  fac.factureDateCreate.toString(),
                  style: GoogleFonts.didactGothic(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '${fac.factureMontant}  ${fac.factureDevise}',
                  style: GoogleFonts.didactGothic(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataCell(
                Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: Text(
                    fac.factureStatut,
                    style: GoogleFonts.didactGothic(
                      fontWeight: FontWeight.w600,
                      fontSize: 10.0,
                      color: Colors.red[700],
                    ),
                  ),
                ),
              ),
              DataCell(
                Text(
                  fac.client.clientNom,
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
                        "Voir détails",
                        style: GoogleFonts.didactGothic(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),
                      onPressed: () async {
                        await factureDetailsModal(context, fac);
                      },
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        elevation: 2,
                        padding: const EdgeInsets.all(8.0),
                      ),
                      child: Text(
                        "Payer",
                        style: GoogleFonts.didactGothic(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),
                      onPressed: () async {
                        showPayModal(context, fac);
                      },
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.pink,
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
                        _deleteFacture(context, fac);
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

  _deleteFacture(BuildContext context, Facture fac) async {
    print(fac.factureId);
    var db = await DbHelper.initDb();
    XDialog.show(context,
        message: "Etes-vous sûr de vouloir supprimer cette facture ?",
        onValidated: () async {
      await db
          .update(
        "facture_details",
        {"facture_detail_state": "deleted"},
        where: "facture_id=?",
        whereArgs: [int.parse(fac.factureId.toString())],
      )
          .then((res) async {
        await db
            .update("factures", {"facture_state": "deleted"},
                where: "facture_id=?",
                whereArgs: [int.parse(fac.factureId.toString())])
            .then((id) async {
          print(id);
          dataController.loadFacturesEnAttente();
          dataController.refreshDashboardCounts();
        });
      });
    }, onFailed: () {});
  }
}

class StatusBtn extends StatelessWidget {
  const StatusBtn(
      {Key key,
      this.color,
      this.onPressed,
      this.icon,
      this.label,
      this.isActive = false})
      : super(key: key);
  final MaterialColor color;
  final Function onPressed;
  final IconData icon;
  final bool isActive;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? color.shade400 : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            blurRadius: 10.0,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 10, 6),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive ? Colors.white : color.shade900,
                  size: 15.0,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Text(
                  label,
                  style: GoogleFonts.didactGothic(
                    color: isActive ? Colors.white : color.shade900,
                    fontWeight: FontWeight.w500,
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
