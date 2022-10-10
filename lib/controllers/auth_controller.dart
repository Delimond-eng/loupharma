import 'package:get/get.dart';
import '../models/user.dart';
import '../services/db_helper.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  var loggedUser = User().obs;
  var selectedEditUser = User().obs;
  var isUpdated = false.obs;
  var isSyncIn = false.obs;

  bool get checkUser {
    if (loggedUser.value.userRole.contains("admin")) {
      return true;
    }
    if (loggedUser.value.userRole.contains("utilisateur")) {
      return true;
    }
    return false;
  }

  Future<void> registerUser() async {
    var db = await DbHelper.initDb();
    var users = await db.query("users");
    if (users.isEmpty) {
      var user = User(
        userName: "Delimond",
        userPass: "12345",
        userAccess: "allowed",
        userRole: "admin",
      );
      await db.insert("users", user.toMap());
    }
  }
}
