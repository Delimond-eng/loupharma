import 'dart:io';
//import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common/sqlite_api.dart';
import '../global.dart' as db_path;

class DbStockHelper {
  static Future<Database> initDb() async {
    var databaseFactory = databaseFactoryFfi;
    final scriptDir = File(Platform.script.toFilePath()).parent;
    String appDocPath = scriptDir.path;
    String path = join(appDocPath, db_path.databaseName);
    var db = await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        onCreate: _onCreate,
        version: 1,
      ),
    );
    return db;
  }

  static _onCreate(Database db, int version) async {
    try {
      await db.execute(
          "CREATE TABLE IF NOT EXISTS articles(article_id INTEGER NOT NULL PRIMARY KEY, article_libelle TEXT, article_create_At INTEGER, article_state TEXT)");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS stocks(stock_id INTEGER NOT NULL PRIMARY KEY, stock_prix_achat REAL, stock_prix_achat_devise TEXT,stock_article_id INTEGER, stock_status TEXT, stock_create_At INTEGER, stock_state TEXT)");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS mouvements(mouvt_id INTEGER NOT NULL PRIMARY KEY, mouvt_qte_en INTEGER DEFAULT 0, mouvt_qte_so INTEGER DEFAULT 0, mouvt_stock_id INTEGER, mouvt_create_At INTEGER, mouvt_state TEXT)");
    } catch (err) {
      print("error from transaction");
    }
  }
}
