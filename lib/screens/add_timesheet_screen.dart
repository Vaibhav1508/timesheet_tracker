import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_tracker/constants/constants.dart';
import 'package:time_tracker/models/activity.dart';
import 'package:time_tracker/models/contract.dart';
import 'package:time_tracker/models/task.dart';
import 'package:time_tracker/screens/home_screen2.dart';
import 'package:time_tracker/screens/manager/home_screen.dart';
import 'package:time_tracker/screens/weeklylog_screen.dart';
import 'package:uuid/uuid.dart';

class AddTimeSheetScreen extends StatefulWidget {
  final String weekid;
  const AddTimeSheetScreen({Key key, this.weekid}) : super(key: key);

  @override
  _AddTimeSheetScreenState createState() => _AddTimeSheetScreenState();
}

class _AddTimeSheetScreenState extends State<AddTimeSheetScreen> {
  final dateController = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  TextEditingController timeinput2 = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController contractname = TextEditingController();
  TextEditingController contractid = TextEditingController();

  bool isManager = false;

  TextEditingController activityname = TextEditingController();
  TextEditingController activityid = TextEditingController();

  TextEditingController taskname = TextEditingController();
  TextEditingController taskid = TextEditingController();
  List<ContractModel> contract = new List();
  List<ActivityModel> activity = new List();
  List<TaskModel> task = new List();

  var v4 = Uuid().v4();
  String userid = "";

  ContractModel selected;
  ActivityModel selectedActivity;
  TaskModel selectedTask;


  @override
  void initState() {
    getuser();
    getcontracts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size _mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
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
                          Icons.arrow_back,
                          size: 40,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        "Timesheet Items",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(widget.weekid),
                      TextField(
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
                      TextField(
                        controller:
                        timeinput, //editing controller of this TextField
                        decoration: InputDecoration(
                            icon: Icon(Icons.timer), //icon of text field
                            labelText: "From" //label text of field
                        ),
                        readOnly:
                        true, //set it true, so that user will not able to edit text
                        onTap: () async {
                          TimeOfDay pickedTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );

                          if (pickedTime != null) {
                            print(pickedTime.format(context)); //output 10:51 PM
                            DateTime parsedTime = DateFormat.jm()
                                .parse(pickedTime.format(context).toString());
                            //converting to DateTime so that we can further format on different pattern.
                            print(parsedTime); //output 1970-01-01 22:53:00.000
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
                      TextField(
                        controller:
                        timeinput2, //editing controller of this TextField
                        decoration: InputDecoration(
                            icon: Icon(Icons.timer), //icon of text field
                            labelText: "To" //label text of field
                        ),
                        readOnly:
                        true, //set it true, so that user will not able to edit text
                        onTap: () async {
                          TimeOfDay pickedTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );

                          if (pickedTime != null) {
                            print(pickedTime.format(context)); //output 10:51 PM
                            DateTime parsedTime = DateFormat.jm()
                                .parse(pickedTime.format(context).toString());
                            //converting to DateTime so that we can further format on different pattern.
                            print(parsedTime); //output 1970-01-01 22:53:00.000
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
                      Container(
                        width: _mediaQuery.width * 0.7,
                        margin: EdgeInsets.symmetric(vertical: 10),
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
                              contractname.text = category.contract;
                              contractid.text = category.id;
                              getActivity();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: _mediaQuery.width * 0.7,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1.0, style: BorderStyle.solid),
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        child: DropdownButton<ActivityModel>(
                          dropdownColor: appdarkColor,
                          isExpanded: true,

                          value: selectedActivity,



                          hint: Text("Activity"),
                          items: activity.map((ActivityModel category) {
                            return new DropdownMenuItem<ActivityModel>(

                              value: category,
                              child: Text(category.activity),
                            );
                          }).toList(),
                          onChanged: (ActivityModel category) {
                            setState(() {
                              selectedActivity = category;      // Problem here too, the element doesn’t show in the dropdown as selected
                              // print("Selected: ${_feedCategory.title} (${_feedCategory.id})");
                              activityname.text = category.activity;
                              activityid.text = category.id;

                              getTask();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: _mediaQuery.width * 0.7,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1.0, style: BorderStyle.solid),
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        child: DropdownButton<TaskModel>(
                          dropdownColor: appdarkColor,
                          isExpanded: true,

                          value: selectedTask,



                          hint: Text("Task"),
                          items: task.map((TaskModel category) {
                            return new DropdownMenuItem<TaskModel>(

                              value: category,
                              child: Text(category.task),
                            );
                          }).toList(),
                          onChanged: (TaskModel category) {
                            setState(() {
                              selectedTask = category;      // Problem here too, the element doesn’t show in the dropdown as selected
                              // print("Selected: ${_feedCategory.title} (${_feedCategory.id})");
                              taskname.text = category.task;
                              taskid.text = category.id;
                            });
                          },
                        ),
                      ),
                      Center(
                        child: TextField(
                          controller: description,
                          keyboardType: TextInputType.multiline,
                          maxLength: null,
                          maxLines: 2,
                          decoration: InputDecoration(
                              icon: Icon(Icons.timer), //icon of text field
                              labelText:
                              "Write Desciption here" //label text of field
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: TextButton(
                          child: Text("Add",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(15)),
                              foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  appdarkColor),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: appdarkColor),
                                  ))),
                          onPressed: ()async {
                            if(dateController.text==""||timeinput.text==""||timeinput2.text==""||contractid.text==""||
                            activityid.text==""||taskid.text==""||description.text==""){
                              Fluttertoast.showToast(msg: 'Please enter details');
                            }else{
                              int aprooved = 0;
                              final prefs = await SharedPreferences.getInstance();
                              if(prefs.getBool('isManager')){
                                aprooved = 1;
                              }else{

                              }
                              FirebaseFirestore.instance.collection('weeks')
                                  .doc(widget.weekid)
                                  .set({
                                'timesheet': 1
                              }, SetOptions(merge: true));


                              FirebaseFirestore.instance
                                  .collection('timesheet')
                                  .doc(v4.toString())
                                  .set({
                                'id': v4.toString(),
                                'weekid': widget.weekid, // John Doe
                                'date': dateController.text, // Stokes and Sons
                                'from': timeinput.text,
                                'to': timeinput2.text,
                                'contract': contractname.text,
                                'activity': activityname.text,
                                'task': taskname.text,
                                'contractid':contractid.text,
                                'activityid':activityid.text,
                                'taskid':taskid.text,
                                'description': description.text,
                                'approved': aprooved,
                                'userid': userid,
                              }).then((value) {
                                Fluttertoast.showToast(msg: "timesheet created");
                                if(isManager){
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => HomeScreen()));
                                }else{
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => HomeScreen2()));

                                }
                              }).catchError((error) =>
                                  print("Failed to add user: $error"));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2021));
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

  Future<void> getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('user');
    isManager = prefs.getBool('isManager');
  }

  void getActivity() {
    FirebaseFirestore.instance
        .collection('activity')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        print(doc.data());
        ActivityModel _message = ActivityModel.fromMap(doc.data());

        setState(() {
          activity.add(_message);
        });

      });
    });
  }

  void getTask() {
    FirebaseFirestore.instance
        .collection('tasks')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        print(doc.data());
        TaskModel _message = TaskModel.fromMap(doc.data());

        setState(() {
          task.add(_message);
        });

      });
    });
  }
}