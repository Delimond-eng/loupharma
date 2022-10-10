import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/controllers.dart';
import '../responsive/base_widget.dart';
import '../services/db_helper.dart';
import '../widgets/costum_table.dart';
import '../widgets/custom_page.dart';
import '../widgets/empty_table.dart';
import 'components/add_user_drawer.dart';

class Users extends StatefulWidget {
  const Users({Key key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    dataController.loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerScrimColor: Colors.transparent,
      endDrawer: const AddUserDrawer(),
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: CustomPage(
        title: "Utilisateurs",
        icon: Icons.manage_accounts,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Responsive(
              builder: (context, responsive) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Liste des utilisateurs",
                            style: GoogleFonts.didactGothic(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              _scaffoldKey.currentState.openEndDrawer();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(20.0),
                              backgroundColor: Colors.indigo,
                            ),
                            icon: const Icon(
                              Icons.add,
                              size: 15.0,
                            ),
                            label: Text(
                              "Nouveau utilisateur",
                              style: GoogleFonts.didactGothic(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _dataTableViewer(context)
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _dataTableViewer(BuildContext context) {
    return Expanded(
      child: FadeInUp(
        child: Obx(() {
          return dataController.users.isEmpty
              ? const EmptyTable()
              : ListView(
                  padding: const EdgeInsets.all(10.0),
                  children: [
                    CostumTable(
                      cols: const ["N°", "Nom", "Rôle", "Status", ""],
                      data: _createRows(),
                    ),
                  ],
                );
        }),
      ),
    );
  }

  List<DataRow> _createRows() {
    return dataController.users.map(
      (user) {
        return DataRow(
          cells: [
            DataCell(
              Text(
                user.userId.toString(),
                style: GoogleFonts.didactGothic(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            DataCell(
              Text(
                user.userName,
                style: GoogleFonts.didactGothic(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            DataCell(
              Text(
                user.userRole,
                style: GoogleFonts.didactGothic(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            DataCell(
              Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: (user.userAccess == "allowed")
                      ? Colors.green[200]
                      : Colors.red[100],
                  borderRadius: BorderRadius.circular(3.0),
                ),
                child: Text(
                  user.accessStr,
                  style: GoogleFonts.didactGothic(
                    fontWeight: FontWeight.w800,
                    fontSize: 11.0,
                    letterSpacing: 1.0,
                    color: (user.userAccess == "allowed")
                        ? Colors.green[700]
                        : Colors.red[700],
                  ),
                ),
              ),
            ),
            DataCell(
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: user.userAccess == "allowed"
                          ? Colors.pink
                          : Colors.green,
                      elevation: 2,
                      padding: const EdgeInsets.all(8.0),
                    ),
                    child: Text(
                      user.userAccess == "allowed" ? "Désactiver" : "Activer",
                      style: GoogleFonts.didactGothic(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                    onPressed: () async {
                      var db = await DbHelper.initDb();
                      var map;
                      if (user.userAccess == "allowed") {
                        map = {'user_access': 'denied'};
                      } else {
                        map = {'user_access': 'allowed'};
                      }
                      await db.update('users', map,
                          where: 'user_id=?',
                          whereArgs: [user.userId]).then((id) {
                        dataController.loadUsers();
                      });
                    },
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      elevation: 2,
                      padding: const EdgeInsets.all(8.0),
                    ),
                    child: Text(
                      "Modifier",
                      style: GoogleFonts.didactGothic(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                    onPressed: () async {
                      authController.selectedEditUser.value = user;
                      authController.isUpdated.value = true;
                      _scaffoldKey.currentState.openEndDrawer();
                    },
                  ),
                ],
              ),
            )
          ],
        );
      },
    ).toList();
  }
}
