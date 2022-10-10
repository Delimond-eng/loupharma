import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/controllers.dart';
import '../models/client.dart';
import '../services/db_helper.dart';
import '../services/native_db_helper.dart';
import '../utilities/modals.dart';
import '../widgets/costum_table.dart';
import '../widgets/custom_page.dart';
import '../widgets/empty_table.dart';
import '../widgets/search_input.dart';
import 'modals/facture_create_modal.dart';

class Clients extends StatefulWidget {
  const Clients({Key key}) : super(key: key);

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  final GlobalKey<NavigatorState> _key = GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
  }

  List<DataRow> _createRows() {
    return dataController.clients
        .map(
          (client) => DataRow(
            cells: [
              DataCell(
                Text(
                  client.clientCreatAt,
                  style: GoogleFonts.didactGothic(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataCell(
                Text(
                  client.clientNom,
                  style: GoogleFonts.didactGothic(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataCell(
                Text(
                  client.clientTel,
                  style: GoogleFonts.didactGothic(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataCell(
                Text(
                  client.clientAdresse,
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
                      backgroundColor:
                          authController.loggedUser.value.userRole == "admin"
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
                    onPressed: authController.loggedUser.value.userRole ==
                            "admin"
                        ? () async {
                            var db = await DbHelper.initDb();
                            var c = await db.query("clients");
                            if (c.length == 1) {
                              return;
                            }
                            XDialog.show(context,
                                message:
                                    "Etes-vous sûr de vouloir supprimér ce client ?",
                                onValidated: () async {
                              await db
                                  .update(
                                      "clients", {"client_state": "deleted"},
                                      where: "client_id=?",
                                      whereArgs: [client.clientId])
                                  .then(
                                (id) {
                                  dataController.loadClients();
                                  XDialog.showMessage(
                                    context,
                                    message: "client supprimé avec succès !",
                                    type: "success",
                                  );
                                },
                              );
                            }, onFailed: () {});
                          }
                        : null,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      elevation: 2,
                      padding: const EdgeInsets.all(8.0),
                    ),
                    child: Text(
                      "Créer facture",
                      style: GoogleFonts.didactGothic(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                    onPressed: () {
                      createFactureModal(
                        context,
                        showClientList: false,
                        client: client,
                      );
                    },
                  ),
                ],
              ))
            ],
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerScrimColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      key: _key,
      body: CustomPage(
        title: "Clients",
        icon: CupertinoIcons.group_solid,
        child: LayoutBuilder(
          builder: (context, constraint) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Liste des clients",
                    style: GoogleFonts.didactGothic(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: SearchInput(
                          spacedLeft: 0,
                          hintText: "Recherche client...",
                          onChanged: (kWord) async {
                            await searchClient(kWord);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    return (dataController.clients.isEmpty)
                        ? const EmptyTable()
                        : FadeInUp(
                            child: ListView(
                              padding: const EdgeInsets.all(10.0),
                              children: [
                                CostumTable(
                                  cols: const [
                                    "Date création",
                                    "Nom",
                                    "Téléphone",
                                    "Adresse",
                                    ""
                                  ],
                                  data: _createRows(),
                                )
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

  searchClient(String kword) async {
    try {
      var allClients = await NativeDbHelper.rawQuery(
          "SELECT * FROM clients WHERE NOT client_state='deleted' AND client_nom LIKE '%$kword%'");
      if (allClients != null) {
        dataController.clients.clear();
        allClients.forEach((e) {
          dataController.clients.add(Client.fromMap(e));
        });
      }
    } catch (e) {}
  }
}
