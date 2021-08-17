import 'package:cloud_firestore/cloud_firestore.dart';

class ContractModel {
   String contract;
  String id;

  ContractModel({
    this.contract,
    this.id,
  });

  //Will be only called when you wish to send an image
  // named constructor
  ContractModel.imageMessage({
    this.contract,
    this.id,

  });

  Map toMap() {
    var map = Map<String, dynamic>();
    map['contract'] = this.contract;
    map['id'] = this.id;

    return map;
  }

  Map toImageMap() {
    var map = Map<String, dynamic>();
    map['contract'] = this.contract;
    map['id'] = this.id;
    return map;
  }

  // named constructor
  ContractModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.contract = map['contract'];

  }
}
