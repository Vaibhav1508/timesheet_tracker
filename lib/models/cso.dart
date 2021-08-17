import 'package:cloud_firestore/cloud_firestore.dart';

class Cso {
  String csono;
  String date;
  String email;
  String name;
  Timestamp timestamp;
  String uid;
  String id;
  String reportedon;
  String mobile;
  String contract;
  String engineer;
  String contractid;
  String start_at;
  String end_at;
  String description;
  String resolution;

  Cso({
    this.csono,
    this.date,
    this.email,
    this.contractid,
    this.name,
    this.timestamp,
    this.id,
    this.reportedon,
    this.mobile,
    this.contract,
    this.engineer,
    this.start_at,
    this.uid,
    this.end_at,
    this.description,
    this.resolution
  });

  //Will be only called when you wish to send an image
  // named constructor
  Cso.imageMessage({
    this.csono,
    this.date,
    this.email,
    this.name,
    this.timestamp,
    this.reportedon,
    this.mobile,
    this.uid,
    this.contract,
    this.id,
    this.engineer,
    this.contractid,
    this.start_at,
    this.end_at,
    this.description,
    this.resolution
  });

  Map toMap() {
    var map = Map<String, dynamic>();
    map['csono'] = this.csono;
    map['date'] = this.date;
    map['email'] = this.email;
    map['name'] = this.name;
    map['timestamp'] = this.timestamp;
    map['reportedon'] = this.reportedon;
    map['mobile'] = this.mobile;
    map['contract'] = this.contract;
    map['uid'] = this.uid;
    map['engineer'] = this.engineer;
    map['start_at'] = this.start_at;
    map['end_at'] = this.end_at;
    map['contractid'] = this.contractid;
    map['description'] = this.description;
    map['resolution'] = this.resolution;
    map['id'] = this.id;
    return map;
  }

  Map toImageMap() {
    var map = Map<String, dynamic>();
    map['csono'] = this.csono;
    map['date'] = this.date;
    map['email'] = this.email;
    map['name'] = this.name;
    map['uid'] = this.uid;
    map['id'] = this.id;
    map['timestamp'] = this.timestamp;
    map['reportedon'] = this.reportedon;
    map['mobile'] = this.mobile;
    map['contract'] = this.contract;
    map['contractid'] = this.contractid;
    map['engineer'] = this.engineer;
    map['start_at'] = this.start_at;
    map['end_at'] = this.end_at;
    map['description'] = this.description;
    map['resolution'] = this.resolution;
    return map;
  }

  // named constructor
  Cso.fromMap(Map<String, dynamic> map) {
    this.csono = map['csono'];
    this.date = map['date'];
    this.email = map['email'];
    this.name = map['name'];
    this.timestamp = map['timestamp'];
    this.reportedon = map['reportedon'];
    this.mobile = map['mobile'];
    this.contract = map['contract'];
    this.contractid = map['contractid'];
    this.engineer = map['engineer'];
    this.id = map['id'];
    this.start_at = map['start_at'];
    this.end_at = map['end_at'];
    this.description = map['description'];
    this.resolution = map['resolution'];
  }
}
