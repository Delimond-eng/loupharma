import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../global/controllers.dart';
import '../../global/data_crypt.dart';
import '../../models/user.dart';
import '../../responsive/base_widget.dart';
import '../../responsive/enum_screens.dart';
import '../../services/db_helper.dart';
import '../../utilities/modals.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/auth_field.dart';
import '../home_screen.dart';

class AuthenticateScreen extends StatefulWidget {
  const AuthenticateScreen({Key key}) : super(key: key);

  @override
  State<AuthenticateScreen> createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  final _textUsername = TextEditingController();
  final _textPassword = TextEditingController();
  final GlobalKey<NavigatorState> _key = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    insertUser();
  }

  insertUser() async {
    var db = await DbHelper.initDb();
    var users = await db.query("users");
    if (users.isEmpty) {
      var user = User(
        userName: "admin",
        userPass: "12345",
        userRole: "admin",
      );
      var userId = await db.insert(
        "users",
        user.toMap(),
      );
      debugPrint("latest user : $userId");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Responsive(
            builder: (context, screenSize) {
              return Container(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/bg/bg_4.jpg"),
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100].withOpacity(.7),
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FadeInDown(
                              child: AppLogo(
                            secondaryColor: Colors.yellow[900],
                          )),
                          const SizedBox(
                            height: 20.0,
                          ),
                          ZoomIn(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: screenSize.deviceScreenType ==
                                        DeviceScreenType.Mobile
                                    ? 10.0
                                    : 0.0,
                              ),
                              padding: const EdgeInsets.all(15.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.white.withOpacity(.8),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 8,
                                    color: Colors.grey.withOpacity(.2),
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              height: 200.0,
                              width: 420.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: AuthField(
                                      hintText:
                                          "Entrez le nom d'utilisateur...",
                                      icon: CupertinoIcons.person,
                                      controller: _textUsername,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  Flexible(
                                    child: AuthField(
                                      hintText: "Entrez le mot de passe...",
                                      icon: CupertinoIcons.lock,
                                      isPassWord: true,
                                      controller: _textPassword,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  Flexible(
                                    child: SizedBox(
                                      height: 50.0,
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.indigo,
                                        ),
                                        onPressed: () => loggedIn(context),
                                        icon: const Icon(
                                          Icons.lock_open_rounded,
                                          size: 15.0,
                                        ),
                                        label: Text(
                                          "Connecter".toUpperCase(),
                                          style: GoogleFonts.didactGothic(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 2.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> loggedIn(BuildContext context) async {
    var db = await DbHelper.initDb();
    if (_textUsername.text.isEmpty) {
      EasyLoading.showToast(
          "le nom d'utilisateur est requis pour se connecter ! ex. gaston");
      return;
    }

    if (_textPassword.text.isEmpty) {
      EasyLoading.showToast("le mot de passe est requis pour se connecter !");
      return;
    }

    try {
      String userName = _textUsername.text;
      String userPass = Cryptage.encrypt(_textPassword.text);
      var checkedUser = await db.rawQuery(
          "SELECT * FROM users WHERE user_name=? AND user_pass=?",
          [userName, userPass]);
      if (checkedUser != null && checkedUser.isNotEmpty) {
        User connected = User.fromMap(checkedUser[0]);
        if (connected.userAccess == "allowed") {
          authController.loggedUser.value = connected;
          Xloading.showLottieLoading(context);
          dataController.editCurrency();
          dataController.refreshDatas();
          navigatorController.activeItem.value = "/";
          Future.delayed(const Duration(milliseconds: 100), () async {
            Xloading.dismiss();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          });
        } else {
          EasyLoading.showToast(
              "l'accès à ce compte est restreint, l'administrateur doit activer le compte pour vous connecter !");
          return;
        }
      } else {
        EasyLoading.showToast("Mot de passe ou nom utilisateur invalide !");
        return;
      }
    } catch (err) {
      print("error from connect user statment: $err");
    }
  }
}
