import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/controllers.dart';
import '../pages/modals/costumer_create_modal.dart';
import '../pages/modals/facture_create_modal.dart';
import '../responsive/base_widget.dart';
import '../responsive/enum_screens.dart';
import '../widgets/app_logo.dart';
import '../widgets/sidebar_item.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Responsive(
      builder: (context, responsiveInfo) {
        return Container(
          margin: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
          width: responsiveInfo.deviceScreenType == DeviceScreenType.Desktop
              ? screenSize.width
              : 250,
          height: screenSize.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.3),
                blurRadius: 10.0,
                offset: const Offset(0, 10),
              )
            ],
          ),
          padding: const EdgeInsets.only(top: 10.0),
          child: Obx(() {
            return Column(
              children: [
                if (responsiveInfo.deviceScreenType !=
                    DeviceScreenType.Desktop) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 25.0),
                    child: Center(
                      child: AppLogo(
                        size: 25.0,
                      ),
                    ),
                  )
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (authController.checkUser) ...[
                        SidebarMenuItem(
                          icon: Icons.dashboard_sharp,
                          itemName: "/",
                          label: "Tableau de bord",
                          onTap: () {
                            navigatorController.navigateTo("/");
                          },
                        ),
                        SidebarMenuItem(
                          icon: Icons.group_rounded,
                          itemName: "/clients",
                          label: "Clients",
                          onTap: () {
                            navigatorController.navigateTo("/clients");
                          },
                        ),
                        SidebarMenuItem(
                          icon: CupertinoIcons.doc_on_doc_fill,
                          itemName: "/factures",
                          label: "Factures",
                          onTap: () {
                            navigatorController.navigateTo("/factures");
                          },
                        ),
                        SidebarMenuItem(
                          icon: CupertinoIcons.doc_checkmark_fill,
                          itemName: "/paiements",
                          label: "Paiements",
                          onTap: () {
                            navigatorController.navigateTo("/paiements");
                          },
                        ),
                        SidebarMenuItem(
                          icon: CupertinoIcons.cube_box_fill,
                          disabled: authController.loggedUser.value.userRole !=
                              "admin",
                          itemName: "/treasures",
                          label: "Trésoreries",
                          onTap: () {
                            navigatorController.navigateTo("/treasures");
                          },
                        ),
                        SidebarMenuItem(
                          icon: CupertinoIcons.doc_chart_fill,
                          disabled: authController.loggedUser.value.userRole !=
                              "admin",
                          itemName: "/inventories",
                          label: "Inventaires",
                          onTap: () {
                            navigatorController.navigateTo("/inventories");
                          },
                        ),
                      ],
                      SidebarMenuItem(
                        icon: Icons.backpack_rounded,
                        disabled: authController.loggedUser.value.userRole ==
                            "utilisateur",
                        itemName: authController.checkUser ? '/stocks' : '/',
                        label: "Stockage",
                        onTap: () {
                          if (authController.checkUser) {
                            navigatorController.navigateTo("/stocks");
                          } else {
                            navigatorController.navigateTo("/");
                          }
                        },
                      ),
                      if (authController.checkUser) ...[
                        SidebarMenuItem(
                          icon: Icons.manage_accounts,
                          disabled: authController.loggedUser.value.userRole !=
                              "admin",
                          itemName: "/users",
                          label: "Utilisateurs",
                          onTap: () {
                            navigatorController.navigateTo("/users");
                          },
                        ),
                      ]
                    ],
                  ),
                ),
                if (authController.checkUser) ...[
                  FadeInDown(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 20.0,
                                ),
                                backgroundColor: Colors.black,
                              ),
                              onPressed: () {
                                createCostumerModal(context);
                              },
                              label: Text(
                                "Nouveau client",
                                style: GoogleFonts.didactGothic(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              icon: const Icon(
                                Icons.person_add_alt,
                                size: 15.0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 20.0,
                                ),
                                backgroundColor: Colors.black,
                              ),
                              onPressed: () {
                                createFactureModal(context);
                              },
                              label: Text(
                                "Nouvelle facture",
                                style: GoogleFonts.didactGothic(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              icon: const Icon(
                                Icons.add,
                                size: 15.0,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ]
              ],
            );
          }),
        );
      },
    );
  }
}
