import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../global/controllers.dart';
import '../../models/compte.dart';
import '../../services/db_helper.dart';
import '../../utilities/modals.dart';
import '../../widgets/costum_dropdown.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/round_icon_btn.dart';
import '../../widgets/simple_field_text.dart';

class AddAccountDrawer extends StatelessWidget {
  const AddAccountDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _libelle = TextEditingController();
    var _devise;
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(right: 15.0),
      height: 270.0,
      width: 400.0,
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
                  "Nouveau compte de trésorerie",
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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SimpleField(
                    hintText: "Saisir libellé du compte... ",
                    iconColor: Colors.indigo,
                    icon: Icons.abc,
                    title: "Libellé",
                    controller: _libelle,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  DropField(
                    data: const ["USD", "CDF"],
                    hintText: "Sélectionnez une devise...",
                    icon: CupertinoIcons.money_dollar_circle_fill,
                    iconColor: Colors.indigo,
                    onChanged: (value) {
                      _devise = value;
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomBtn(
                    icon: CupertinoIcons.add,
                    color: Colors.green,
                    label: "Créer compte",
                    onPressed: () async {
                      if (_libelle.text.isEmpty) {
                        EasyLoading.showToast("Libellé du compte requis !");
                        return;
                      }
                      if (_devise == null) {
                        EasyLoading.showToast(
                            "Veuillez sélectionner une devise !");
                        return;
                      }
                      var db = await DbHelper.initDb();
                      var compte = Compte(
                        compteDevise: _devise,
                        compteLibelle: _libelle.text,
                      );
                      await db.insert("comptes", compte.toMap()).then(
                        (id) {
                          dataController.loadAllComptes();
                          dataController.loadActivatedComptes();
                          Navigator.pop(context);
                          XDialog.showMessage(
                            context,
                            type: "success",
                            message: "Compte créé avec succès !",
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
