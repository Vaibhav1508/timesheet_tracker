import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String task;
  String id;

  TaskModel({
    this.task,
    this.id,
  });

  //Will be only called when you wish to send an image
  // named constructor
  TaskModel.imageMessage({
    this.task,
    this.id,

  });

  Map toMap() {
    var map = Map<String, dynamic>();
    map['task'] = this.task;
    map['id'] = this.id;

    return map;
  }

  Map toImageMap() {
    var map = Map<String, dynamic>();
    map['task'] = this.task;
    map['id'] = this.id;
    return map;
  }

  // named constructor
  TaskModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.task = map['task'];

  }
}
