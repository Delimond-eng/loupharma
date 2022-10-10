import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../global/utils.dart';
import '../services/db_helper.dart';
import 'models/daily_count.dart';
import 'models/dashboard_count.dart';
import 'models/month.dart';

class Report {
  static Future<int> _count(String keyword) async {
    final DateTime now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    int date = convertToTimestamp(now);
    var db = await DbHelper.initDb();
    switch (keyword) {
      case "costumers":
        var res = await db.rawQuery(
            "SELECT COUNT(*) as costumers FROM clients WHERE NOT client_state='deleted'");
        return res.isEmpty ? 0.0 : res.first['costumers'];
      case "daily":
        var res = await db.rawQuery(
            "SELECT COUNT(*) as daily FROM factures INNER JOIN clients ON factures.facture_client_id = clients.client_id WHERE factures.facture_create_At LIKE '%$date%' AND NOT factures.facture_state='deleted' AND NOT clients.client_state='deleted'");
        return res.isEmpty ? 0.0 : res.first['daily'];
      case "pending":
        var res = await db.rawQuery(
            "SELECT COUNT(*) as pending FROM factures INNER JOIN clients ON factures.facture_client_id = clients.client_id WHERE factures.facture_statut='en cours' AND NOT factures.facture_state='deleted' AND NOT clients.client_state='deleted'");
        return res.isEmpty ? 0.0 : res.first['pending'];
      case "completed":
        var res = await db.rawQuery(
            "SELECT COUNT(*) as completed FROM factures INNER JOIN clients ON factures.facture_client_id = clients.client_id WHERE factures.facture_statut='paie' AND NOT factures.facture_state='deleted' AND NOT clients.client_state='deleted'");
        return res.isEmpty ? 0.0 : res.first['completed'];
      default:
        return 0;
    }
  }

  static Future<double> _daySum(String mode) async {
    var date = DateTime.now();
    var dateConverted = DateTime(date.year, date.month, date.day);
    var ms = dateConverted.microsecondsSinceEpoch;
    var timesmp = (ms / 1000).round();
    var db = await DbHelper.initDb();
    var query = await db.rawQuery(
        "SELECT SUM(operation_montant) AS daySum FROM operations WHERE operation_mode = '$mode' AND operation_create_At='$timesmp' AND NOT operation_state='deleted'");
    return query.first["daySum"] ?? 0;
  }

  static Future<double> dayAll() async {
    var date = DateTime.now();
    var dateConverted = DateTime(date.year, date.month, date.day);
    var ms = dateConverted.microsecondsSinceEpoch;
    var timesmp = (ms / 1000).round();
    var db = await DbHelper.initDb();
    var query = await db.rawQuery(
        "SELECT SUM(operation_montant) AS daySum FROM operations WHERE operation_create_At='$timesmp' AND NOT operation_state='deleted'");
    return query.first["daySum"] ?? 0;
  }

  static Future<List<DailyCount>> getDayAccountSums() async {
    final List<DailyCount> data = <DailyCount>[];

    var sum1 = await _daySum("Cash");
    var cashData = DailyCount(
      icon: Icons.date_range_rounded,
      sum: sum1,
      title: "Paiement cash",
    );
    data.add(cashData);

    var sum2 = await _daySum("Paiement mobile");
    var mobiData = DailyCount(
      icon: Icons.mobile_friendly,
      sum: sum2,
      title: "Paiement mobile",
    );
    data.add(mobiData);

    var sum3 = await _daySum("Virement");
    var vData = DailyCount(
      icon: CupertinoIcons.arrow_right_arrow_left_circle_fill,
      sum: sum3,
      title: "Virement bancaire",
    );
    data.add(vData);

    var sum4 = await _daySum("Chèque");
    var chequeData = DailyCount(
      icon: CupertinoIcons.doc_append,
      sum: sum4,
      title: "P. par Chèque",
    );
    data.add(chequeData);

    return data;
  }

  static Future<List<DashboardCount>> getCount() async {
    final List<DashboardCount> counts = <DashboardCount>[];

    /*count daily factures*/

    var dailyFac = await _count("daily");
    var dailyFacData = DashboardCount(
      countValue: dailyFac,
      icon: CupertinoIcons.calendar_today,
      title: "Factures journalières",
      color: Colors.indigo,
    );
    counts.add(dailyFacData);

    /* end & push data */

    /*pending factures count */

    var pendingCount = await _count("pending");
    var pendingData = DashboardCount(
      countValue: pendingCount,
      icon: CupertinoIcons.doc_circle_fill,
      title: "Factures en cours",
      color: Colors.brown,
    );
    counts.add(pendingData);

    /*end & push data*/

    /* count costumers */
    var costumers = await _count("costumers");
    var costumersData = DashboardCount(
      countValue: costumers,
      icon: CupertinoIcons.group_solid,
      title: "Clients",
      color: Colors.blue,
    );
    counts.add(costumersData);

    /*en & push data to list*/

    /* count completed factures */

    var completedCount = await _count("completed");
    var completedCountData = DashboardCount(
      countValue: completedCount,
      icon: CupertinoIcons.doc_checkmark_fill,
      title: "Factures réglées",
      color: Colors.green,
    );
    counts.add(completedCountData);
    /*end & push data*/

    /*return list completed */
    return counts;
  }

  static Future<double> checkLastPay(int factureId) async {
    var db = await DbHelper.initDb();
    var query = await db.rawQuery(
      "SELECT SUM(operation_montant) AS lastAmount FROM operations INNER JOIN factures ON operations.operation_facture_id = factures.facture_id WHERE operations.operation_facture_id = $factureId",
    );
    return query.isEmpty ? null : query.first['lastAmount'];
  }

  //**get List of months**//
  static Future<List<Month>> getMonths() async {
    List<Month> data = <Month>[];
    List<String> months = [
      "Janv.",
      "Fév.",
      "Mars",
      "Avril",
      "Mai",
      "Juin",
      "Juil.",
      "Août",
      "Sept.",
      "Oct.",
      "Nov.",
      "Déc.",
    ];
    var dateNow = DateTime.now();
    for (int i = 0; i < months.length; i++) {
      var m = months[i];
      var t = Month(
          label: m,
          value: "${(i + 1).toString().padLeft(2, "0")}-${dateNow.year}");
      data.add(t);
    }
    return data;
  }
}
