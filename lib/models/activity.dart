import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  String activity;
  String id;

  ActivityModel({
    this.activity,
    this.id,
  });

  //Will be only called when you wish to send an image
  // named constructor
  ActivityModel.imageMessage({
    this.activity,
    this.id,

  });

  Map toMap() {
    var map = Map<String, dynamic>();
    map['activity'] = this.activity;
    map['id'] = this.id;

    return map;
  }

  Map toImageMap() {
    var map = Map<String, dynamic>();
    map['activity'] = this.activity;
    map['id'] = this.id;
    return map;
  }

  // named constructor
  ActivityModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.activity = map['activity'];

  }
}
