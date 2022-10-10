import 'package:firedart/firedart.dart';

import '../../global/controllers.dart';
import 'services/db_stock_helper.dart';

class SyncStock {
  static Future syncOut() async {
    authController.isSyncIn.value = true;
    var db = await DbStockHelper.initDb();
    var stocks = await db.query("stocks");
    var mouvts = await db.query("mouvements");
    var articles = await db.query("articles");

    if (stocks.isNotEmpty) {
      for (var e in stocks) {
        var isEmpty = await checkIn("stocks",
            id: "stock_id", value: e["stock_id"].toString());

        if (isEmpty) {
          Firestore.instance.collection('stocks').add(e);
        }
      }
    }
    if (mouvts.isNotEmpty) {
      for (var e in mouvts) {
        var isEmpty = await checkIn("mouvements",
            id: "mouvt_id", value: e["mouvt_id"].toString());
        if (isEmpty) {
          Firestore.instance.collection('mouvements').add(e);
        }
      }
    }
    if (articles.isNotEmpty) {
      for (var e in articles) {
        var isEmpty = await checkIn("articles",
            id: "article_id", value: e["article_id"].toString());
        if (isEmpty) {
          Firestore.instance.collection('articles').add(e);
        }
      }
    }
    authController.isSyncIn.value = false;
    return "end";
  }

  static Future syncIn() async {
    authController.isSyncIn.value = true;
    var db = await DbStockHelper.initDb();
    final batch = db.batch();
    try {
      await Firestore.instance
          .collection("mouvements")
          .get()
          .then((result) async {
        for (var e in result) {
          var s = await db.query("mouvements",
              where: "mouvt_id=?", whereArgs: [e["mouvt_id"]]);
          if (s.isEmpty && e["mouvt_state"] != "deleted") {
            batch.insert("mouvements", e.map);
          }
        }
      });
    } catch (e) {}
    try {
      await Firestore.instance
          .collection("articles")
          .get()
          .then((result) async {
        for (var e in result) {
          var s = await db.query("articles",
              where: "article_id=?", whereArgs: [e["article_id"]]);
          if (s.isEmpty && e["article_state"] != "deleted") {
            batch.insert("articles", e.map);
          }
        }
      });
    } catch (e) {}
    try {
      await Firestore.instance.collection("stocks").get().then((result) async {
        for (var e in result) {
          var s = await db
              .query("stocks", where: "stock_id=?", whereArgs: [e["stock_id"]]);
          if (s.isEmpty && e["stock_state"] != "deleted") {
            batch.insert("stocks", e.map);
          }
        }
      });
    } catch (e) {}

    await batch.commit();
    await stockController.reloadData();
    authController.isSyncIn.value = false;
    return "end";
  }

  static Future<bool> checkIn(String col, {String id, String value}) async {
    var data = await Firestore.instance
        .collection(col)
        .where(id, isEqualTo: int.parse(value))
        .get();
    return data.isEmpty;
  }
}
