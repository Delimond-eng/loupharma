class Currency {
  int currencyId;
  String currencyValue;

  Currency({this.currencyId, this.currencyValue});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (currencyId != null) {
      data["cid"] = currencyId;
    }
    data["cvalue"] = currencyValue;
    return data;
  }

  Currency.fromMap(Map<String, dynamic> data) {
    currencyId = data["cid"];
    currencyValue = data["cvalue"];
  }
}
