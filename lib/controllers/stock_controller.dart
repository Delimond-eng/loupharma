import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../global/controllers.dart';
import '../repositories/stock_repo/models/stock.dart';
import '../repositories/stock_repo/services/db_stock_helper.dart';
import '../repositories/stock_repo/sync.dart';

class StockController extends GetxController {
  static StockController instance = Get.find();

  /* My variables */
  var stocks = <Stock>[].obs;

  reloadData({String seachWord}) async {
    var db = await DbStockHelper.initDb();
    var query;
    if (seachWord == null) {
      query = await db.rawQuery(
          "SELECT SUM(mouvements.mouvt_qte_en) AS entrees,SUM(mouvements.mouvt_qte_so) AS sorties, * FROM stocks INNER JOIN articles ON stocks.stock_article_id = articles.article_id INNER JOIN mouvements ON stocks.stock_id = mouvements.mouvt_stock_id WHERE NOT stocks.stock_state = 'deleted' AND NOT mouvements.mouvt_state='deleted' AND NOT articles.article_state = 'deleted' GROUP BY stocks.stock_id, stocks.stock_create_At ORDER BY mouvements.mouvt_create_At DESC");
    } else {
      query = await db.rawQuery(
          "SELECT SUM(mouvements.mouvt_qte_en) AS entrees,SUM(mouvements.mouvt_qte_so) AS sorties, * FROM stocks INNER JOIN articles ON stocks.stock_article_id = articles.article_id INNER JOIN mouvements ON stocks.stock_id = mouvements.mouvt_stock_id WHERE NOT stocks.stock_state = 'deleted' AND NOT mouvements.mouvt_state='deleted' AND NOT articles.article_state = 'deleted' AND articles.article_libelle LIKE '%$seachWord%' GROUP BY stocks.stock_id,stocks.stock_create_At ORDER BY mouvements.mouvt_create_At DESC");
    }

    stocks.clear();
    var s = <Stock>[];
    for (var e in query) {
      await Future.delayed(const Duration(microseconds: 1000));
      s.add(Stock.fromMap(e));
    }
    stocks.addAll(s);
    dataController.dataLoading.value = false;
    var result = await (Connectivity().checkConnectivity());
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      await SyncStock.syncOut();
    }
  }
}
