import 'package:flutter/material.dart';

import '../global/controllers.dart';
import 'router.dart';

Navigator localNavigator() => Navigator(
      key: navigatorController.navigationKey,
      initialRoute: "/",
      onGenerateRoute: generateRoute,
    );
