import 'package:cloud_firestore/cloud_firestore.dart';

class WeekModel {
  String title;
  String id;

  WeekModel({
    this.title,
    this.id,
  });

  //Will be only called when you wish to send an image
  // named constructor
  WeekModel.imageMessage({
    this.title,
    this.id,

  });

  Map toMap() {
    var map = Map<String, dynamic>();
    map['title'] = this.title;
    map['id'] = this.id;

    return map;
  }

  Map toImageMap() {
    var map = Map<String, dynamic>();
    map['title'] = this.title;
    map['id'] = this.id;
    return map;
  }

  // named constructor
  WeekModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];

  }
}
