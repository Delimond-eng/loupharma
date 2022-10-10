import '../global/utils.dart';

class Compte {
  dynamic compteId;
  dynamic compteTimestamp;
  String compteLibelle;
  String compteDevise;
  String compteStatus;
  String compteState;
  String compteDate;

  bool isSelected = false;
  Compte({
    this.compteId,
    this.compteLibelle,
    this.compteDevise,
    this.compteStatus,
    this.compteState,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};

    if (compteId != null) {
      data["compte_id"] = int.parse(compteId.toString());
    }

    if (compteLibelle != null) {
      data["compte_libelle"] = compteLibelle;
    }
    if (compteDevise != null) {
      data["compte_devise"] = compteDevise;
    }
    data["compte_status"] = compteStatus ?? "actif";
    DateTime now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (compteTimestamp == null) {
      data["compte_create_At"] = convertToTimestamp(now);
    } else {
      data["compte_create_At"] = int.parse(compteTimestamp.toString());
    }
    data["compte_state"] = compteState ?? "allowed";
    return data;
  }

  Compte.fromMap(Map<String, dynamic> data) {
    compteId = int.parse(data["compte_id"].toString());
    compteLibelle = data["compte_libelle"];
    compteDevise = data["compte_devise"];
    compteStatus = data["compte_status"];
    compteTimestamp = data["compte_create_At"];
    compteState = data["compte_state"];
    DateTime date = parseTimestampToDate(int.parse(data["compte_create_At"].toString()));
    compteDate = dateToString(date);
  }
}
