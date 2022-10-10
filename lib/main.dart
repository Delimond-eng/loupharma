//import 'package:dashui/services/db_helper.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'controllers/auth_controller.dart';
import 'controllers/data_controller.dart';
import 'controllers/navigator_controller.dart';
import 'controllers/stock_controller.dart';
import 'repositories/stock_repo/services/db_stock_helper.dart';
import 'screens/auth/authenticate_screen.dart';
import 'services/db_helper.dart';

/*
apiKey: "AIzaSyB2fmj3T_eIJghf3HElcqBBC5QqgzVUTxI",

  authDomain: "zandodb-d4d9a.firebaseapp.com",

  projectId: "zandodb-d4d9a",

  storageBucket: "zandodb-d4d9a.appspot.com",

  messagingSenderId: "837340987035",

  appId: "1:837340987035:web:82ec155fc28c36aa0ed03e"

*/

const _apiKey = "AIzaSyB2fmj3T_eIJghf3HElcqBBC5QqgzVUTxI";
const _projectId = "zandodb-d4d9a";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.initDbLibrary();
  await DbHelper.initDb();
  await DbStockHelper.initDb();

  Get.put(NavigatorController());
  Get.put(DataController());
  Get.put(AuthController());
  Get.put(StockController());
  Firestore.initialize(_projectId);
  runApp(const MyApp());
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 30.0
    ..radius = 5.0
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'zando graphics app by G-Numerics',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Didact Gothic',
      ),
      // ignore: prefer_const_literals_to_create_immutables
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [Locale('fr', 'FR')],
      home: Builder(
        builder: (context) {
          return const AuthenticateScreen();
        },
      ),
      builder: EasyLoading.init(),
    );
  }
}
