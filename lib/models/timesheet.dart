import 'package:cloud_firestore/cloud_firestore.dart';

class Timesheet {
  String contract;
  String id;
  String activity;
  int aprooved;
  String date;
  String desc;
  String from;
  String task;
  String to;
  String userid;
  String reason;
  String weekid;

  Timesheet({
    this.contract,
    this.id,
    this.reason,
    this.activity,
    this.aprooved,
    this.date,
    this.desc,
    this.from,
    this.task,
    this.to,
    this.userid,
    this.weekid
  });

  //Will be only called when you wish to send an image
  // named constructor


  Map toMap() {
    var map = Map<String, dynamic>();
    map['contract'] = this.contract;
    map['id'] = this.id;
    map['reason'] = this.reason;
    map['activity'] = this.activity;
    map['approved'] = this.aprooved;
    map['date'] = this.date;
    map['description'] = this.desc;
    map['from'] = this.from;
    map['task'] = this.task;
    map['to'] = this.to;
    map['userid'] = this.userid;
    map['weekid'] = this.weekid;


    return map;
  }



  // named constructor
  Timesheet.fromMap(Map<String, dynamic> map) {
     this.contract =  map['contract'] ;
    this.id = map['id'];
    this.activity = map['activity'] ;
    this.aprooved = map['approved'];
    this.date = map['date'];
    this.desc = map['description'] ;
     this.reason = map['reason'] ;
    this.from = map['from'];
    this.task = map['task'];
    this.to = map['to'];
    this.userid = map['userid'];
    this.weekid = map['weekid'];
  }
}
