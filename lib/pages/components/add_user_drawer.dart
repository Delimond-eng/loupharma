import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../global/controllers.dart';
import '../../models/user.dart';
import '../../services/db_helper.dart';
import '../../utilities/modals.dart';
import '../../widgets/costum_dropdown.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/round_icon_btn.dart';
import '../../widgets/simple_field_text.dart';

class AddUserDrawer extends StatelessWidget {
  const AddUserDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _userName = TextEditingController();
    var _userPass = TextEditingController();
    var _userRole;
    var user = User();
    var isUpdated = authController.isUpdated.value;
    if (isUpdated) {
      user = authController.selectedEditUser.value;
      if (user != null) {
        _userName.text = user.userName;
      }
    }
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(right: 15.0),
      height: 350.0,
      width: 420.0,
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
                  "Nouveau utilisateur",
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
                    hintText: "Saisir nom d'utilisateur... ",
                    iconColor: Colors.indigo,
                    icon: CupertinoIcons.person,
                    title: "Nom d'utilisateur",
                    controller: _userName,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SimpleField(
                    hintText: "Saisir mot de passe...",
                    iconColor: Colors.indigo,
                    icon: Icons.lock_outline,
                    title: "Mot de passe",
                    controller: _userPass,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  DropField(
                    data: const ["admin", "utilisateur", "gestionnaire stock"],
                    hintText: "Sélectionnez un rôle...",
                    iconColor: Colors.indigo,
                    icon: Icons.manage_accounts_outlined,
                    onChanged: (value) {
                      _userRole = value;
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomBtn(
                    icon: !isUpdated ? CupertinoIcons.add : Icons.edit,
                    color: !isUpdated ? Colors.green : Colors.blue,
                    label: !isUpdated
                        ? "Créer utilisateur"
                        : "Modifier utilisateur",
                    onPressed: () async {
                      if (_userName.text.isEmpty && _userPass.text.isEmpty) {
                        EasyLoading.showToast(
                            "Veuillez entrer le mom d'utilisateur & mot de passe !");
                        return;
                      }
                      if (_userRole == null) {
                        EasyLoading.showToast(
                          "Veuillez sélectionner un rôle d'utilisateur !",
                        );
                        return;
                      }
                      var db = await DbHelper.initDb();
                      var user = User(
                        userName: _userName.text,
                        userPass: _userPass.text,
                        userRole: _userRole,
                      );
                      if (!isUpdated) {
                        db.insert("users", user.toMap()).then((id) {
                          dataController.loadUsers();
                          Navigator.pop(context);
                          XDialog.showMessage(
                            context,
                            message: "Utilisateur créé avec succès !",
                            type: "success",
                          );
                        });
                      } else {
                        await db.update(
                          "users",
                          user.toMap(),
                          where: "user_id=?",
                          whereArgs: [user.userId],
                        ).then((id) {
                          dataController.loadUsers();
                          Navigator.pop(context);
                          XDialog.showMessage(
                            context,
                            message: "Utilisateur modifié avec succès !",
                            type: "success",
                          );
                        });
                      }
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
