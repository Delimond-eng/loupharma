import 'compte.dart';
import 'facture.dart';
import 'facture_detail.dart';
import 'operation.dart';
import 'user.dart';
import 'client.dart';

class SyncModel {
  List<User> users;
  List<Client> clients;
  List<Compte> comptes;
  List<Facture> factures;
  List<FactureDetail> factureDetails;
  List<Operations> operations;

  SyncModel.fromMap(Map<String, dynamic> json) {
    if (json['data']['clients'] != null) {
      clients = <Client>[];
      json['data']['clients'].forEach((v) {
        clients.add(Client.fromMap(v));
      });
    }
    if (json['data']['comptes'] != null) {
      comptes = <Compte>[];
      json['data']['comptes'].forEach((v) {
        comptes.add(Compte.fromMap(v));
      });
    }
    if (json['data']['factures'] != null) {
      factures = <Facture>[];
      json['data']['factures'].forEach((v) {
        factures.add(Facture.fromMap(v));
      });
    }
    if (json['data']['facture_details'] != null) {
      factureDetails = <FactureDetail>[];
      json['data']['facture_details'].forEach((v) {
        factureDetails.add(FactureDetail.fromMap(v));
      });
    }

    if (json['data']['operations'] != null) {
      operations = <Operations>[];
      json['data']['operations'].forEach((v) {
        operations.add(Operations.fromMap(v));
      });
    }

    if (json['data']['users'] != null) {
      users = <User>[];
      json['data']['users'].forEach((v) {
        users.add(User.fromMap(v));
      });
    }
  }
}
