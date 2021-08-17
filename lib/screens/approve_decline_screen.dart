import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/constants/constants.dart';
import 'package:time_tracker/models/timesheet.dart';
import 'package:time_tracker/screens/manager/approve_timesheet.dart';
import 'package:time_tracker/screens/manager/approved_timesheet.dart';
import 'package:time_tracker/screens/manager/home_screen.dart';
import 'package:time_tracker/screens/reason_screen.dart';

class ApproveDeclineScreen extends StatefulWidget {
  final List<String> timesheet;
  const ApproveDeclineScreen({Key  key, this.timesheet}) : super(key: key);

  @override
  _ApproveDeclineScreenState createState() => _ApproveDeclineScreenState();
}

enum BestTutorSite { javatpoint, w3schools, tutorialandexample }

class _ApproveDeclineScreenState extends State<ApproveDeclineScreen> {
  BestTutorSite _site = BestTutorSite.javatpoint;

  bool accept = true;

  CollectionReference _timesheetCollection = FirebaseFirestore.instance.collection('timesheet');


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {


              changeStatus();
            },
            child: Icon(Icons.navigate_next),
          ),
          appBar: AppBar(
            centerTitle: true,
            title: Text("Send To"),
          ),
      body: Container(
        color: appdarkColor,
        child: Column(
          children: [
            ListTile(
              title: const Text('Approve'),
              leading: Radio(
                value: BestTutorSite.javatpoint,
                groupValue: _site,
                onChanged: (BestTutorSite value) {
                  _site = value;
                  setState(() {
                    accept = true;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Reject'),
              leading: Radio(
                value: BestTutorSite.tutorialandexample,
                groupValue: _site,
                onChanged: (BestTutorSite value) {
                  _site = value;
                  setState(() {

                    accept = false;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void changeStatus() async{



      if(accept==true){

        for(int i=0;i<widget.timesheet.length;i++) {
          await _timesheetCollection
              .doc(widget.timesheet[i])
              .set({
            'approved': 1
          }, SetOptions(merge: true));
        }

        Navigator.push(context, MaterialPageRoute(builder: (_)=>HomeScreen()));


      }else{

        for(int i=0;i<widget.timesheet.length;i++) {
          await _timesheetCollection
              .doc(widget.timesheet[i])
              .set({
            'approved': 2
          }, SetOptions(merge: true));
        }


        Navigator.push(context, MaterialPageRoute(builder: (_)=>ReasonScreen(id: widget.timesheet,)));
      }




  }
}
