import 'dart:io';

String get databaseName {
  if (Platform.isWindows) {
    return "zandodb.dll";
  } else {
    return "zandodb.so";
  }
}
