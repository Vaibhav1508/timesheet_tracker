import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:time_tracker/models/cso.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference _csoCollection = FirebaseFirestore.instance.collection('cso');
  CollectionReference _weekCollection = FirebaseFirestore.instance.collection('weeks');

  Future<void> addUser(String userid, String email, String password,
      bool isManager, String name, String emp) {
    // Call the user's CollectionReference to add a new user
    return users.doc(userid).set({
      'uid': userid,
      'email': email, // John Doe
      'password': password, // Stokes and Sons
      'isManager': isManager,
      'name': name,
      "emp_id": emp // 42
    }).then((value) {
      Fluttertoast.showToast(msg: "user created please login");
    }).catchError((error) => print("Failed to add user: $error"));
  }


  Future<DocumentSnapshot> getWeek(String id)async{


   return await _weekCollection.doc(id).get();


  }


  Future<DocumentSnapshot> getUser(String id)async{


    return await users.doc(id).get();


  }

  void setCSO(String csono,String name,String contact,String email,String date,
      String description,String end_at,String start_at,String engineer,String mobile,
      String reportedon,String resolution,String contactid) async {
    Cso cso;

    var v4 = Uuid().v4();

    cso = Cso.imageMessage(
      csono: csono,
      name: name,
      contract: contact,
      contractid: contactid,
      email: email,
      date: date,
      id:v4.toString(),
      description: description,
      end_at: end_at,
      engineer: engineer,
      mobile: mobile,
      reportedon: reportedon,
      resolution: resolution,
      start_at: start_at,
      timestamp: Timestamp.now(),
    );

    // create imagemap
    var map = cso.toImageMap();

    // var map = Map<String, dynamic>();
    await _csoCollection
        .doc(v4)
        .set(map);
  }

  void updateCSO(String id,String csono,String name,String contact,String email,String date,
      String description,String end_at,String start_at,String engineer,String mobile,
      String reportedon,String resolution,String contactid) async {
    Cso cso;

    cso = Cso.imageMessage(
      csono: csono,
      name: name,
      contract: contact,
      contractid: contactid,
      email: email,
      date: date,
      description: description,
      end_at: end_at,
      id:id,
      engineer: engineer,
      mobile: mobile,
      reportedon: reportedon,
      resolution: resolution,
      start_at: start_at,
      timestamp: Timestamp.now(),
    );

    // create imagemap
    var map = cso.toImageMap();

    // var map = Map<String, dynamic>();
    await _csoCollection
        .doc(id)
        .set(map);
  }

}
