import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_tracker/constants/constants.dart';
import 'package:time_tracker/models/cso.dart';
import 'package:time_tracker/screens/add_cso_screen.dart';
import 'package:time_tracker/screens/add_timesheet_screen.dart';
import 'package:time_tracker/screens/edit_cso_screen.dart';

class CSOScreen extends StatefulWidget {
  const CSOScreen({Key key}) : super(key: key);

  @override
  _CSOScreenState createState() => _CSOScreenState();
}

class _CSOScreenState extends State<CSOScreen> {


  ScrollController _listScrollController = ScrollController();
  
  String keyword = "";
  
  

  double fixPadding = 10.0;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Size _mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: _mediaQuery.height,
          color: applightColor,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                color: appdarkColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.home,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      "CSO",
                      style: TextStyle(fontSize: 20, color: Colors.blue,fontWeight: FontWeight.bold ),
                    ),
                    SizedBox(
                      width: 30,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: new InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    labelText: "Search",
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  onChanged: (value){
                    setState(() {
                      keyword = value;
                    });
                  },
                ),
              ),
              Expanded(
                  child:keyword==""? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('cso')
                        .orderBy('timestamp',descending: true)
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

                      return ListView.builder(
                        padding: EdgeInsets.all(5),
                        // controller: _listScrollController,
                        // reverse: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          // mention the arrow syntax if you get the time
                          return chatMessageItem(snapshot.data.docs[index]);
                        },
                      );
                    },
                  ): StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('cso')
                        .where('csono',isEqualTo: keyword)
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

                      return ListView.builder(
                        padding: EdgeInsets.all(5),
                        // controller: _listScrollController,
                        // reverse: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          // mention the arrow syntax if you get the time
                          return chatMessageItem(snapshot.data.docs[index]);
                        },
                      );
                    },
                  )),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: FloatingActionButton(
                        heroTag: "btn1",
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>AddCSOScreen()));
                        },
                        child: Icon(Icons.add),),
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
    );
  }

  void _modalBottomSheetMenu(Cso message){
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return new Container(

            height: 410.0,
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
                      title: Text('CSO Details',style:GoogleFonts.lato(textStyle:  TextStyle(
                          fontSize: 18,color: Colors.blue)),),
                      subtitle: Text(message.date,style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 12,color: Colors.black)),),
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
                                            'Csono',
                                            style: GoogleFonts.lato(textStyle: grey14RegularTextStyle),
                                          ),
                                          height5Space,
                                          Text(
                                            '${message.csono}',
                                            style: GoogleFonts.lato(textStyle: black12MediumTextStyle),
                                          ),

                                        ],
                                      ),

                                      VerticalDivider(thickness: 1,),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Mobile',
                                            style: GoogleFonts.lato(textStyle: grey14RegularTextStyle),
                                          ),
                                          height5Space,
                                          Text(
                                            '${message.mobile}',
                                            style: GoogleFonts.lato(textStyle: black12MediumTextStyle),
                                          ),

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
                                            'Reported on',
                                            style: GoogleFonts.lato(textStyle: grey14RegularTextStyle),
                                          ),
                                          height5Space,
                                          Text(
                                            '${message.reportedon}',
                                            style: GoogleFonts.lato(textStyle: black12MediumTextStyle),
                                          ),

                                        ],
                                      ),

                                      VerticalDivider(thickness: 1,),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Email',
                                            style: GoogleFonts.lato(textStyle: grey14RegularTextStyle),
                                          ),
                                          height5Space,
                                          Text(
                                            '${message.email}',
                                            style: GoogleFonts.lato(textStyle: black12MediumTextStyle),
                                          ),

                                        ],
                                      ),

                                      VerticalDivider(thickness: 1,),



                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Engineer',
                                            style: GoogleFonts.lato(textStyle: grey14RegularTextStyle),
                                          ),
                                          height5Space,
                                          Text(
                                            '${message.engineer}',
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
                                            'Start at',
                                            style: GoogleFonts.lato(textStyle: grey14RegularTextStyle),
                                          ),
                                          height5Space,
                                          Text(
                                            '${message.start_at}',
                                            style: GoogleFonts.lato(textStyle: black12MediumTextStyle),
                                          ),

                                        ],
                                      ),
                                      VerticalDivider(thickness: 1,),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'End at',
                                            style: GoogleFonts.lato(textStyle: grey14RegularTextStyle),
                                          ),
                                          height5Space,
                                          Text(
                                            '${message.end_at}',
                                            style: GoogleFonts.lato(textStyle: black12MediumTextStyle),
                                          ),

                                        ],
                                      ),

                                      VerticalDivider(thickness: 1,),



                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Name',
                                            style: GoogleFonts.lato(textStyle: grey14RegularTextStyle),
                                          ),
                                          height5Space,
                                          Text(
                                            '${message.name}',
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
                                            '${message.description}',
                                            style: GoogleFonts.lato(textStyle: black12MediumTextStyle),
                                          ),

                                        ],
                                      ),

                                      VerticalDivider(thickness: 1,),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Resolution',
                                            style: GoogleFonts.lato(textStyle: grey14RegularTextStyle),
                                          ),
                                          height5Space,
                                          Text(
                                            '${message.resolution}',
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

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Cso _message = Cso.fromMap(snapshot.data());

    return ListTile(
      title: Text(
          _message.csono,style: black18MediumTextStyle,),

      subtitle: Text('Engineer : ${_message.engineer}'),
      trailing: GestureDetector(
        child: Icon(Icons.delete),
        onTap: (){

          FirebaseFirestore.instance.collection('cso')
              .doc(_message.id)
              .delete();

          Fluttertoast.showToast(msg: 'CSO Deleted successfully');

        },
      ),
      leading: GestureDetector(
        child: Icon(Icons.edit),
        onTap: (){
          Navigator.push(context,MaterialPageRoute(builder: (_)=>EditCSOScreen(csoitem: _message,)));
        },
      ),
      onTap: () {
        _modalBottomSheetMenu(_message);
        //Navigator.push(context, MaterialPageRoute(builder: (_)=>AnalyticsScreen()));
      },
    );

  }
}

