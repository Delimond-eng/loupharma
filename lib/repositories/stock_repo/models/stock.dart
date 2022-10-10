import '../../../global/utils.dart';
import 'article.dart';

class Stock {
  dynamic stockId;
  dynamic stockPrixAchat;
  String stockPrixAchatDevise;
  dynamic stockArticleId;
  dynamic stockCreatAt;
  String stockDate;
  String stockStatus;
  String stockState;
  dynamic stockEn;
  dynamic stockSo;
  Article article;

  int get solde =>
      int.parse(stockEn.toString()) - int.parse(stockSo.toString());

  Stock({
    this.stockId,
    this.stockPrixAchat,
    this.stockPrixAchatDevise,
    this.stockArticleId,
    this.stockStatus,
    this.stockCreatAt,
    this.stockState,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};

    if (stockId != null) {
      data["stock_id"] = int.parse(stockId.toString());
    }
    if (stockPrixAchat != null) {
      data["stock_prix_achat"] = double.parse(stockPrixAchat.toString());
    }
    if (stockPrixAchatDevise != null) {
      data["stock_prix_achat_devise"] = stockPrixAchatDevise;
    }
    if (stockStatus != null) {
      data["stock_status"] = stockStatus;
    } else {
      data["stock_status "] = "actif";
    }
    if (stockArticleId != null) {
      data["stock_article_id"] = int.parse(stockArticleId.toString());
    }
    DateTime now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (stockCreatAt == null) {
      data["stock_create_At"] = convertToTimestamp(now);
    } else {
      data["stock_create_At"] = int.parse(stockCreatAt.toString());
    }

    data["stock_state"] = stockState ?? "allowed";
    return data;
  }

  Stock.fromMap(Map<String, dynamic> data) {
    stockId = data["stock_id"];
    stockPrixAchat = data["stock_prix_achat"];
    stockPrixAchatDevise = data["stock_prix_achat_devise"];
    stockArticleId = data["stock_article_id"];
    stockStatus = data["stock_status"];
    stockCreatAt = data["stock_create_At"];
    stockState = data["stock_state"];
    if (data["article_id"] != null) {
      article = Article.fromMap(data);
    }
    if (data["entrees"] != null) {
      stockEn = data["entrees"];
    }
    if (data["sorties"] != null) {
      stockSo = data["sorties"];
    }
    try {
      stockDate = dateToString(parseTimestampToDate(data["stock_create_At"]));
    } catch (err) {}
  }
}
