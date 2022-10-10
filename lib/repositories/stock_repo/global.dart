import 'dart:io';

String get databaseName {
  if (Platform.isWindows) {
    return "zando_stock_db.dll";
  } else {
    return "zando_stock_db.so";
  }
}
