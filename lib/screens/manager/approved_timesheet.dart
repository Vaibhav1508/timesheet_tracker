import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_tracker/constants/constants.dart';
import 'package:time_tracker/models/timesheet.dart';
import 'package:time_tracker/screens/manager/home_screen.dart';
import 'package:time_tracker/screens/view_timesheet.dart';
import 'package:time_tracker/services/firestore_services.dart';

import '../approve_decline_screen.dart';
class ApprovedTimesheetScreen extends StatefulWidget {
  const ApprovedTimesheetScreen({Key  key}) : super(key: key);

  @override
  _ApprovedTimesheetScreenState createState() => _ApprovedTimesheetScreenState();
}

class _ApprovedTimesheetScreenState extends State<ApprovedTimesheetScreen> {

  FirestoreService firestoreService = new FirestoreService();

  String uid;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUid();
    print(uid);
  }

  void getUid() async{

    final prefs = await SharedPreferences.getInstance();

    setState(() {

      uid = prefs.getString('user');
    });
  }



  @override
  Widget build(BuildContext context) {
    Size _mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: _mediaQuery.height,
          child: SingleChildScrollView(
            child: Container(
              height: _mediaQuery.height,
              color: appdarkColor,
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>HomeScreen())),
                        child: Icon(Icons.home,size: 40,color: Colors.blue,),
                      ),
                      Text("Approved Timesheet",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),),
                      SizedBox(width: 10,)
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(child:StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('timesheet')
                        .where('approved',isEqualTo: 1)
                        .where('userid',isEqualTo: uid)
                    // .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data == null) {
                        return Center(child: CircularProgressIndicator());
                      }

                      // SchedulerBinding.instance.addPostFrameCallback((_) {
                      //   _listScrollController.animateTo(
                      //     _listScrollController.position.minScrollExtent,
                      //     duration: Duration(milliseconds: 250),
                      //     curve: Curves.easeInOut,
                      //   );
                      // });
                    print(uid);
                      return snapshot.data.docs.length>0?ListView.builder(
                        padding: EdgeInsets.all(5),
                        // controller: _listScrollController,
                        // reverse: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          // mention the arrow syntax if you get the time


                          return chatMessageItem(snapshot.data.docs[index],index);
                        },
                      ):Center(child: Text('No Timesheet Found'),);
                    },
                  ) ),
                 
                  SizedBox(height: 50,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot,int index) {
    Timesheet _message = Timesheet.fromMap(snapshot.data());


    return  ListTile(
      leading: Icon(Icons.watch_later_outlined),
      title:FutureBuilder<DocumentSnapshot>(
        future: firestoreService.getWeek(_message.weekid), // async work
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return Text('Loading....');
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return Text(' ${snapshot.data.data()['title'].toString()} on ${_message.date} \n From - ${_message.from} , To - ${
                    _message.to
                } ',style: TextStyle(fontSize: 14,color: Colors.black),);
          }
        },
      ),
      onTap: (){

        _modalBottomSheetMenu(_message);



        // setState(() {
        //   checked[index] = !checked[index];
        // });

        //Navigator.of(context).pushNamed("your_route_name");
      } ,
    );

  }

  void _modalBottomSheetMenu(Timesheet message){
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return new Container(

            height: 450.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                width: MediaQuery.of(context).size.width,
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(18.0),
                        topRight: const Radius.circular(18.0))),
                child: ListView(
                  children: [

                    ListTile(
                      title: Text('Timesheet Details',style:GoogleFonts.lato(textStyle:  TextStyle(
                          fontSize: 18,color: Colors.blue)),),
                      // subtitle: Text(message.date,style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 12,color: Colors.black)),),
                      trailing: GestureDetector(
                        child: Icon(Icons.close,size: 25,),
                        onTap: (){
                          Navigator.pop(context);
                        },
                      ),
                    ),

                    Divider(),

                    GestureDetector(
                      child: Container(
                          margin: EdgeInsets.fromLTRB(
                            fixPadding * 1.0,
                            fixPadding,
                            fixPadding*1.0,
                            fixPadding,
                          ),

                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: fixPadding,
                                  vertical: fixPadding,
                                ),
                                child: IntrinsicHeight(
                                  child: Row(

                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Week',
                                            style: GoogleFonts.lato(textStyle: grey14RegularTextStyle),
                                          ),
                                          height5Space,
                                          FutureBuilder<DocumentSnapshot>(
                                            future: firestoreService.getWeek(message.weekid), // async work
                                            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                              switch (snapshot.connectionState) {
                                                case ConnectionState.waiting: return Text('Loading....');
                                                default:
                                                  if (snapshot.hasError)
                                                    return Text('Error: ${snapshot.error}');
                                                  else
                                                    return Text(' ${snapshot.data.data()['title'].toString().substring(10)
                                                    } ',style: GoogleFonts.lato(textStyle: black12MediumTextStyle));
                                              }
                                            },
                                          )

                                        ],
                                      ),

                                      VerticalDivider(thickness: 1,),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Contract',
                                            style: GoogleFonts.lato(textStyle: grey14RegularTextStyle),
                                          ),
                                          height5Space,
                                          Text(
                                            '${message.contract}',
                                            style: GoogleFonts.lato(textStyle: black12MediumTextStyle),
                                          ),

                                        ],
                                      ),



                                    ],
                                  ),
                                ),
                              ),

                              Divider(),

                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: fixPadding,
                                  vertical: fixPadding,
                                ),
                                child: IntrinsicHeight(
                                  child: Row(

                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [


                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Activity',
                                            style: GoogleFonts.lato(textStyle: grey14RegularTextStyle),
                                          ),
                                          height5Space,
                                          Text(
                                            '${message.activity}',
                                            style: GoogleFonts.lato(textStyle: black12MediumTextStyle),
                                          ),

                                        ],
                                      ),


                                      VerticalDivider(thickness: 1,),


                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Task',
                                            style: GoogleFonts.lato(textStyle: grey14RegularTextStyle),
                                          ),
                                          height5Space,
                                          Text(
                                            '${message.task}',
                                            style: GoogleFonts.lato(textStyle: black12MediumTextStyle),
                                          ),

                                        ],
                                      ),






                                    ],
                                  ),
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: fixPadding,
                                  vertical: fixPadding,
                                ),
                                child: IntrinsicHeight(
                                  child: Row(

                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Date',
                                            style: GoogleFonts.lato(textStyle: grey14RegularTextStyle),
                                          ),
                                          height5Space,
                                          Text(
                                            '${message.date}',
                                            style: GoogleFonts.lato(textStyle: black12MediumTextStyle),
                                          ),

                                        ],
                                      ),

                                      VerticalDivider(thickness: 1,),



                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'User',
                                            style: GoogleFonts.lato(textStyle: grey14RegularTextStyle),
                                          ),
                                          height5Space,
                                          FutureBuilder<DocumentSnapshot>(
                                            future: firestoreService.getUser(message.userid), // async work
                                            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                              switch (snapshot.connectionState) {
                                                case ConnectionState.waiting: return Text('Loading....');
                                                default:
                                                  if (snapshot.hasError)
                                                    return Text('Error: ${snapshot.error}');
                                                  else
                                                    return Text(' ${snapshot.data.data()['name'].toString()
                                                    } ',style: GoogleFonts.lato(textStyle: black12MediumTextStyle));
                                              }
                                            },
                                          )

                                        ],
                                      ),


                                    ],
                                  ),
                                ),
                              ),

                              Divider(),

                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: fixPadding,
                                  vertical: fixPadding,
                                ),
                                child: IntrinsicHeight(
                                  child: Row(

                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'From',
                                            style: GoogleFonts.lato(textStyle: grey14RegularTextStyle),
                                          ),
                                          height5Space,
                                          Text(
                                            '${message.from}',
                                            style: GoogleFonts.lato(textStyle: black12MediumTextStyle),
                                          ),

                                        ],
                                      ),
                                      VerticalDivider(thickness: 1,),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'To',
                                            style: GoogleFonts.lato(textStyle: grey14RegularTextStyle),
                                          ),
                                          height5Space,
                                          Text(
                                            '${message.to}',
                                            style: GoogleFonts.lato(textStyle: black12MediumTextStyle),
                                          ),

                                        ],
                                      ),







                                    ],
                                  ),
                                ),
                              ),

                              Divider(),

                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: fixPadding,
                                  vertical: fixPadding,
                                ),
                                child: IntrinsicHeight(
                                  child: Row(

                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Description',
                                            style: GoogleFonts.lato(textStyle: grey14RegularTextStyle),
                                          ),
                                          height5Space,
                                          Text(
                                            '${message.desc}',
                                            style: GoogleFonts.lato(textStyle: black12MediumTextStyle),
                                          ),

                                        ],
                                      ),








                                    ],
                                  ),
                                ),
                              ),


                              SizedBox(height: 5,)
                            ],
                          )
                      ),
                      onTap: (){
                        // Navigator.push(context,MaterialPageRoute(builder: (_)=>OrderDetail(order: item,)));
                      },
                    )
                  ],
                )),
          );
        }
    );
  }

}
