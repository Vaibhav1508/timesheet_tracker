import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker/constants/constants.dart';
import 'package:time_tracker/models/contract.dart';
import 'package:time_tracker/screens/add_timesheet_screen.dart';
import 'package:time_tracker/constants/constants.dart';
import 'package:time_tracker/services/firestore_services.dart';

class AddCSOScreen extends StatefulWidget {

  @override
  _AddCSOScreenState createState() => _AddCSOScreenState();
}

class _AddCSOScreenState extends State<AddCSOScreen> {

  List<ContractModel> contract = new List();
  final dateController = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  TextEditingController timeinput2 = TextEditingController();
  TextEditingController csono = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController reported = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController contactid = TextEditingController();
  TextEditingController engineer = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController resolution = TextEditingController();

  ContractModel selected;

  FirestoreService _firestoreService = new FirestoreService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcontracts();
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
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('cso')
                    .orderBy('timestamp', descending: true)
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

                  // return ListView.builder(
                  //   padding: EdgeInsets.all(5),
                  //   // controller: _listScrollController,
                  //   // reverse: true,
                  //   itemCount: snapshot.data.docs.length,
                  //   itemBuilder: (context, index) {
                  //     // mention the arrow syntax if you get the time
                  //     return chatMessageItem(snapshot.data.docs[index]);
                  //   },
                  // );

                  return Container();
                },
              ),


              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                color: appdarkColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      "CSO",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 30,
                    )
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                flex: 5,
                                child: TextField(
                                  controller: csono,
                                  readOnly: false,
                                  decoration: InputDecoration(
                                    hintText: 'CSO No.',
                                    icon: Icon(Icons.calendar_today_outlined),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                flex: 5,
                                child: TextField(

                                  readOnly: true,
                                  controller: dateController,
                                  decoration: InputDecoration(
                                    hintText: 'Pick your Date',
                                    icon: Icon(Icons.calendar_today_outlined),
                                  ),
                                  onTap: () async {
                                    var date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100));
                                    dateController.text =
                                        date.toString().substring(0, 10);
                                  },
                                ),
                              ),
                            ],
                          ),SizedBox(height: 20,),
                          Row(
                            children: [
                              Flexible(
                                flex: 5,
                                child:TextField(
                                  controller: email,
                                  readOnly: false,
                                  decoration: InputDecoration(
                                    hintText: 'Email ID',
                                    icon: Icon(Icons.email_sharp),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                flex: 5,
                                child: TextField(
                                  controller: name,
                                  readOnly: false,
                                  decoration: InputDecoration(
                                    hintText: 'Name',
                                    icon: Icon(Icons.person),
                                  ),
                                ),
                              ),
                            ],
                          ),SizedBox(height: 20,),
                          Row(
                            children: [
                              Flexible(
                                flex: 5,
                                child: TextField(

                                  readOnly: true,
                                  controller: reported,
                                  decoration: InputDecoration(
                                    hintText: 'Reported on',
                                    icon: Icon(Icons.calendar_today_outlined),
                                  ),
                                  onTap: () async {
                                    var date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime(2100));
                                    reported.text =
                                        date.toString().substring(0, 10);
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                flex: 5,
                                child: TextField(
                                  controller: mobile,
                                  readOnly: false,
                                  decoration: InputDecoration(
                                    hintText: 'Mobile No.',
                                    icon: Icon(Icons.phone_android),
                                  ),
                                ),
                              ),
                            ],
                          ),SizedBox(height: 20,),
                          Row(
                            children: [
                              Flexible(
                                flex: 5,
                                child:   Container(
//margin: EdgeInsets.symmetric(vertical: 10),
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1.0, style: BorderStyle.solid),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                  ),
                                  child:DropdownButton<ContractModel>(
                                    dropdownColor: appdarkColor,
                                    isExpanded: true,

                                    value: selected,



                                    hint: Text("Contract"),
                                    items: contract.map((ContractModel category) {
                                      return new DropdownMenuItem<ContractModel>(

                                        value: category,
                                        child: Text(category.contract),
                                      );
                                    }).toList(),
                                    onChanged: (ContractModel category) {
                                      setState(() {
                                        selected = category;      // Problem here too, the element doesn’t show in the dropdown as selected
                                        // print("Selected: ${_feedCategory.title} (${_feedCategory.id})");
                                       contact.text = category.contract;
                                       contactid.text = category.id;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                flex: 5,
                                child:  TextField(
                                  controller: engineer,
                                  readOnly: false,
                                  decoration: InputDecoration(
                                    hintText: 'Engineer',
                                    icon: Icon(Icons.school),
                                  ),
                                ),

                              ),
                            ],
                          ),SizedBox(height: 20,),
                          Row(
                            children: [
                              Flexible(
                                flex: 5,
                                child: TextField(

                                  controller:
                                  timeinput, //editing controller of this TextField
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.timer), //icon of text field
                                      labelText: "Start Time" //label text of field
                                  ),
                                  readOnly:
                                  true, //set it true, so that user will not able to edit text
                                  onTap: () async {
                                    TimeOfDay pickedTime = await showTimePicker(
                                      initialTime: TimeOfDay.now(),
                                      context: context,
                                    );

                                    if (pickedTime != null) {
                                      print(
                                          pickedTime.format(context)); //output 10:51 PM
                                      DateTime parsedTime = DateFormat.jm()
                                          .parse(pickedTime.format(context).toString());
//converting to DateTime so that we can further format on different pattern.
                                      print(
                                          parsedTime); //output 1970-01-01 22:53:00.000
                                      String formattedTime =
                                      DateFormat('HH:mm:ss').format(parsedTime);
                                      print(formattedTime); //output 14:59:00
//DateFormat() is from intl package, you can format the time on any pattern you need.

                                      setState(() {
                                        timeinput.text =
                                            formattedTime; //set the value of text field.
                                      });
                                    } else {
                                      print("Time is not selected");
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                flex: 5,
                                child: TextField(
                                  controller:
                                  timeinput2, //editing controller of this TextField
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.timer), //icon of text field
                                      labelText: "End Time" //label text of field
                                  ),
                                  readOnly:
                                  true, //set it true, so that user will not able to edit text
                                  onTap: () async {
                                    TimeOfDay pickedTime = await showTimePicker(
                                      initialTime: TimeOfDay.now(),
                                      context: context,
                                    );

                                    if (pickedTime != null) {
                                      print(
                                          pickedTime.format(context)); //output 10:51 PM
                                      DateTime parsedTime = DateFormat.jm()
                                          .parse(pickedTime.format(context).toString());
//converting to DateTime so that we can further format on different pattern.
                                      print(
                                          parsedTime); //output 1970-01-01 22:53:00.000
                                      String formattedTime =
                                      DateFormat('HH:mm:ss').format(parsedTime);
                                      print(formattedTime); //output 14:59:00
//DateFormat() is from intl package, you can format the time on any pattern you need.

                                      setState(() {
                                        timeinput2.text =
                                            formattedTime; //set the value of text field.
                                      });
                                    } else {
                                      print("Time is not selected");
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),SizedBox(height: 20,),
                          Row(
                            children: [
                              Flexible(
                                flex: 5,
                                child: TextField(
                                  controller: description,
                                  keyboardType: TextInputType.multiline,
                                  maxLength: null,
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                      icon:
                                      Icon(Icons.text_snippet), //icon of text field
                                      labelText:
                                      "Desciption" //label text of field
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                flex: 5,
                                child: TextField(
                                  controller: resolution,
                                  keyboardType: TextInputType.multiline,
                                  maxLength: null,
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                      icon:
                                      Icon(Icons.text_snippet), //icon of text field
                                      labelText:
                                      "Resolution" //label text of field
                                  ),
                                ),
                              ),
                            ],
                          ),SizedBox(height: 20,),
                          SizedBox(height: 20,),
                          TextButton(
                            child: Text(" Add ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(20)),
                                foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                                backgroundColor:
                                MaterialStateProperty.all<Color>(appdarkColor),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: appdarkColor),
                                ))),
                            onPressed: ()  {

                              if(csono==""||dateController.text==""||email.text==""||reported.text==""||
                                  mobile.text==""||contact.text==""||engineer.text==""||timeinput.text==""||
                                  timeinput2.text==""||description.text==""||resolution.text==""){
                                Fluttertoast.showToast(msg: 'please enter details');

                              }else{
                                Navigator.pop(context);
                                _firestoreService.setCSO(csono.text, name.text, contact.text, email.text,
                                    dateController.text, description.text, timeinput2.text, timeinput.text, engineer.text,
                                    mobile.text, reported.text, resolution.text,contactid.text);
                              }

                            },
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void getcontracts() {
    FirebaseFirestore.instance
        .collection('contracts')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        print(doc.data());
        ContractModel _message = ContractModel.fromMap(doc.data());

        setState(() {
          contract.add(_message);
        });

      });
    });
  }
}
