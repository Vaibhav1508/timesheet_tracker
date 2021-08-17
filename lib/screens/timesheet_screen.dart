import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_tracker/constants/constants.dart';
import 'package:time_tracker/screens/home_screen2.dart';
import 'package:time_tracker/screens/manager/analytics_screen.dart';
import 'package:time_tracker/screens/manager/approved_timesheet.dart';
import 'package:time_tracker/screens/manager/home_screen.dart';
import 'package:time_tracker/screens/own_timesheet.dart';
import 'package:time_tracker/screens/weeklylog_screen.dart';

import 'manager/approve_timesheet.dart';

class TimesheetScreen extends StatefulWidget {
  final String user;
  const TimesheetScreen({Key key, this.user}) : super(key: key);

  @override
  _TimesheetScreenState createState() => _TimesheetScreenState();
}

class _TimesheetScreenState extends State<TimesheetScreen> {

  bool isManager = false;

  List<bool> checked = new List();
  List<String> ids = new List();


  List<String> items = new List();

  String user="2b8cd434-e3df-48b2-b4e3-5b8242b07300";


  CollectionReference _timesheetCollection = FirebaseFirestore.instance.collection('timesheet');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getManager();
    print(widget.user);
    updateItems();
  }
  @override
  Widget build(BuildContext context) {
    Size _mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: _mediaQuery.height,
          child: Container(
            height: _mediaQuery.height,
            color: appdarkColor,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                    Center(
                      widthFactor: 3,
                      child: Text(
                        "Timesheet",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: isManager==true?StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('weeks')
                        .where('id',whereIn: items)
                    // .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data == null) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return snapshot.data.docs.length>0?ListView.builder(
                        padding: EdgeInsets.all(10),
                        // controller: _listScrollController,
                        // reverse: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          // mention the arrow syntax if you get the time
                          return ManagerWeekItem(snapshot.data.docs[index],index);
                        },
                      ):Center(child: Text('No timesheet found'),);
                    },
                  ):StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('weeks')
                        .where('id',whereIn: items)
                    // .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data == null) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return snapshot.data.docs.length>0?ListView.builder(
                        padding: EdgeInsets.all(10),
                        // controller: _listScrollController,
                        // reverse: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          // mention the arrow syntax if you get the time
                          return WeekItem(snapshot.data.docs[index],index);
                        },
                      ):Center(child: Text('No timesheet found'),);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: FloatingActionButton(
                          heroTag: "btn1",
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => WeeklyLogScreen()));
                          },
                          child: Icon(Icons.add),
                        ),
                      ),
                      isManager?Container():Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          heroTag: "btn2",
                          onPressed: ()async {
                            if(ids.length>0){

                              for(int i=0;i<ids.length;i++) {
                                
                                FirebaseFirestore.instance.collection('timesheet')
                                    .where('weekid',isEqualTo: ids[i])
                                    .where('userid',isEqualTo: widget.user)
                                    .get().then((snapshot) {

                                      if(snapshot.docs.length>0){
                                        Fluttertoast.showToast(msg: 'Timesheet sent to Manager');
                                      }else{
                                        Fluttertoast.showToast(msg: 'No timesheet found in this week');
                                      }

                                   snapshot.docs.forEach((timesheet) async{

                                     await _timesheetCollection
                                         .doc(timesheet.id)
                                         .set({
                                       'isSent': 1
                                     }, SetOptions(merge: true));

                                   });
                                });
                                
                                
                              }

                              Navigator.push(context, MaterialPageRoute(builder: (_)=>HomeScreen2()));

                            }else{
                              Fluttertoast.showToast(msg: 'Select atleast 1 week to proceed');
                            }
                          },
                          child: Icon(Icons.navigate_next),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget WeekItem(QueryDocumentSnapshot doc,int index) {

    checked.add(false);



    return ListTile(
      leading:  Checkbox(



        value: checked[index],
        onChanged: (val) {
          setState(() {
            checked[index]= !checked[index];

            if(val==true){

              ids.add(doc['id']);

            }else{

              ids.remove(doc['id']);

            }

            // _isChecked = val;
            // if (val == true) {
            //   _currText = t;
            // }
          });

          print(ids);
        },
      ),
      title: Text(doc['title']),
      trailing: GestureDetector(
        child: Icon(Icons.delete),
        onTap: (){

          FirebaseFirestore.instance.collection('timesheet')
              .where('weekid',isEqualTo: doc['id'])
              .where('userid',isEqualTo: widget.user)
              .get().then((snapshot) {

                snapshot.docs.forEach((element) {

                  FirebaseFirestore.instance.collection('timesheet')
                      .doc(element.id)
                      .delete();


                });

          });

          if(isManager){
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=>HomeScreen()));
          }else{
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=>HomeScreen2()));
          }


          Fluttertoast.showToast(msg: 'Timesheets Deleted successfully');

        },
      ),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => OwnTimesheetScreen(weekid: doc['id'],)));
      },
    );
  }

  Widget ManagerWeekItem(QueryDocumentSnapshot doc,int index) {

    checked.add(false);



    return ListTile(

      title: Text(doc['title']),
      trailing: Icon(Icons.delete),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => OwnTimesheetScreen(weekid: doc['id'],)));
      },
    );
  }

  void getManager() async{
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isManager = prefs.getBool('isManager');
      // user = prefs.getString('user');

    });
  }


  void updateItems() {

    items.add('ab4545sjs');

    print("userid is"+user);
    FirebaseFirestore.instance
        .collection('timesheet')
        .where('userid',isEqualTo: widget.user)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        print(doc.data());

        setState(() {
          items.add(doc.data()['weekid']);
        });


        print(items);

      });
    });

  }

  void getUid() async{

    final prefs = await SharedPreferences.getInstance();

    setState(() {

      user = prefs.getString('user');
    });
  }
}