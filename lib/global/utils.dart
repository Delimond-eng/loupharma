import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'controllers.dart';

int convertToTimestamp(DateTime date) {
  var ms = date.microsecondsSinceEpoch;
  return (ms / 1000).round();
}

DateTime parseTimestampToDate(int timestamp) {
  DateTime date;
  if (timestamp.toString().length >= 16) {
    date = DateTime.fromMicrosecondsSinceEpoch(timestamp);
  } else {
    date = DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
  }
  return date;
}

String dateFromString(DateTime date) {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  String formatted = formatter.format(date);
  return formatted;
}

String formatCurrency(double amount) {
  return '${amount.toStringAsFixed(2)} USD';
}

String formatDate(DateTime date) {
  final format = DateFormat.yMMMd('fr_FR');
  return format.format(date);
}

DateTime strTodate(String date) {
  final DateFormat formatter = (date.contains("-"))
      ? DateFormat('dd-MM-yyyy')
      : DateFormat('dd/MM/yyyy');
  DateTime d = formatter.parse(date);
  return d;
}

String strDateLong(String value) {
  var date = strTodate(value);
  String converted = DateFormat.yMMMd().format(date);
  return converted;
}

String strDateLongFr(String value) {
  var date = strTodate(value);
  String converted = DateFormat.yMMMd("fr_FR").format(date);
  return converted;
}

String dateToString(DateTime date) {
  String converted = DateFormat("dd-MM-yyyy").format(date);
  return converted;
}

Future<int> showDatePicked(BuildContext context) async {
  var date = await showDatePicker(
    locale: const Locale("fr", "FR"),
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1950),
    lastDate: DateTime(2050),
  );
  if (date != null) {
    DateTime dateConverted = DateTime(date.year, date.month, date.day);
    var ms = dateConverted.microsecondsSinceEpoch;
    return (ms / 1000).round();
  }
  return null;
}

double convertCdfToDollars(double cdf) {
  double tauxCDF = double.parse(dataController.currency.value.currencyValue);
  double dollars = cdf / tauxCDF;
  return dollars;
}

double convertDollarsToCdf(double dollars) {
  double tauxCDF = double.parse(dataController.currency.value.currencyValue);
  double cdf = dollars * tauxCDF;
  return cdf;
}

String lastChars(String s, int n) => s.substring(s.length - n);

Future<bool> checkConnection() async {
  var result = await (Connectivity().checkConnectivity());
  if (result == ConnectivityResult.mobile ||
      result == ConnectivityResult.wifi) {
    return true;
  } else {
    return false;
  }
}
