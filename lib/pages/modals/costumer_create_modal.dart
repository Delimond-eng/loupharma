import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/topbar.dart';
import '../../global/controllers.dart';
import '../../models/client.dart';
import '../../services/db_helper.dart';
import '../../utilities/modals.dart';
import '../../widgets/round_icon_btn.dart';
import '../../widgets/simple_field_text.dart';

createCostumerModal(BuildContext context) {
  final _textNom = TextEditingController();
  final _textPhone = TextEditingController();
  final _textAdresse = TextEditingController();
  showDialog(
    barrierColor: Colors.black12,
    context: context,
    builder: (BuildContext context) {
      return FadeInUp(
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
                  color: Colors.indigo,
                  height: 70.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nouveau client",
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
                                hintText: "Saisir nom du client... ",
                                iconColor: Colors.pink,
                                icon: CupertinoIcons.person_fill,
                                title: "Nom client",
                                controller: _textNom,
                              ),
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            Flexible(
                              child: SimpleField(
                                hintText:
                                    "Saisir le n° de téléphone du client... ",
                                iconColor: Colors.pink,
                                icon: CupertinoIcons.phone,
                                title: "N° Téléphone",
                                controller: _textPhone,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        SimpleField(
                          hintText: "Saisir l'adresse du client(optionnel)... ",
                          iconColor: Colors.pink,
                          icon: CupertinoIcons.location_solid,
                          title: "Adresse du client",
                          controller: _textAdresse,
                        )
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
                          var db = await DbHelper.initDb();
                          if (_textNom.text.isEmpty) {
                            EasyLoading.showToast("Nom d'utilisateur requis !");
                            return;
                          }
                          var client = Client(
                            clientNom: _textNom.text,
                            clientAdresse: _textAdresse.text,
                            clientTel: _textPhone.text,
                          );
                          await db.insert("clients", client.toMap()).then((id) {
                            Get.back();
                            if (navigatorController.activeItem.value ==
                                "/clients") {
                              dataController.loadClients();
                            } else {
                              navigatorController.navigateTo("/clients");
                            }
                            XDialog.showMessage(
                              context,
                              message: "client créé avec succès !",
                              type: "success",
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20.0),
                          backgroundColor: Colors.green,
                        ),
                        child: Text(
                          "Créer le nouveau client",
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
