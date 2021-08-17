import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_tracker/constants/constants.dart';
import 'package:time_tracker/screens/manager/home_screen.dart';
class AnalyticsScreen extends StatefulWidget {

  final String uid;

  const AnalyticsScreen({Key key, this.uid}) : super(key: key);

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {


  List months =
  ['jan', 'feb', 'mar', 'apr', 'may','jun','jul','aug','sep','oct','nov','dec'];

  List<int> values = new List();

  List<FlSpot> flspot = [];

  String user="";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkDates();
    getUser();
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
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>HomeScreen())),
                      child: Icon(Icons.home,size: 40,color: Colors.blue,),
                    ),
                    Center(
                        widthFactor: 3.2,
                        child: Text("Analytics",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),

                  ],
                ),
                SizedBox(height: 20,),
                Expanded(
                  child: Container(
                    color: applightColor,
                    padding: EdgeInsets.all(20),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      child: flspot.length>0?LineChart(
                        LineChartData(
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 22,
                                getTextStyles: (value) =>
                                const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 14),
                                getTitles: (value) {
                                  switch (value.toInt()) {
                                    case 1:
                                      return 'Jan';
                                    case 2:
                                      return 'Feb';
                                    case 3:
                                      return 'Mar';

                                    case 4:
                                      return 'Apr';


                                    case 5:
                                      return 'May';


                                    case 6:
                                      return 'Jun';


                                    case 7:
                                      return 'Jul';


                                    case 8:
                                      return 'Aug';



                                    case 9:
                                      return 'Sep';



                                    case 10:
                                      return 'Oct';



                                    case 11:
                                      return 'Nov';



                                    case 12:
                                      return 'Dec';




                                  }
                                  return '';
                                },
                                margin: 8,
                              ),

                            ),
                            lineBarsData: [
                              LineChartBarData(
                                  colors: [Colors.blue],
                                  spots:flspot
                              )
                            ]
                        ),
                      ):Center(child: CircularProgressIndicator(),),
                    ),

                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkDates() async{

    var now = new DateTime. now();

    double jancount = 0;
    double febcount = 0;
    double marcount = 0;
    double aprcount = 0;
    double maycount = 0;
    double juncount = 0;
    double julcount = 0;
    double augcount = 0;
    double sepcount = 0;
    double octcount = 0;
    double novcount = 0;
    double deccount = 0;


   await FirebaseFirestore.instance.collection('timesheet')
       .where('userid',isEqualTo: widget.uid)
       // .where('date',isNull: false)
       .get().then((value){

        value.docs.forEach((timesheet) {
        String month = timesheet.data()['date'];
        DateTime date = DateTime.parse(month);



        switch(date.month){
          case 1:
          jancount = jancount+1;
            break;
          case 2:
            febcount = febcount+1;
            break;
          case 3:
            marcount = maycount+1;
            break;
          case 4:
            aprcount = aprcount+1;
            break;
          case 5:
            maycount = maycount+1;
            break;
          case 6:
            juncount = juncount+1;
            break;
          case 7:
            julcount = julcount+1;
            break;
          case 8:
            augcount = augcount+1;
            break;
          case 9:
            sepcount = sepcount+1;
            break;
          case 10:
            octcount = octcount+1;
            break;
          case 11:
            novcount = novcount+1;
            break;
          case 12:
            deccount = deccount+1;
            break;
        }
        });
   });

   FlSpot jan = new FlSpot(1, jancount);
    FlSpot feb = new FlSpot(2, febcount);
    FlSpot mar = new FlSpot(3, marcount);
    FlSpot apr = new FlSpot(4, aprcount);
    FlSpot may = new FlSpot(5, maycount);
    FlSpot jun = new FlSpot(6, juncount);
    FlSpot jul = new FlSpot(7, julcount);
    FlSpot aug = new FlSpot(8, augcount);
    FlSpot sep = new FlSpot(9, sepcount);
    FlSpot oct = new FlSpot(10, octcount);
    FlSpot nov = new FlSpot(11, novcount);
    FlSpot dec = new FlSpot(12, deccount);

    for(int i=1;i<=now.month;i++){
      switch(i){

        case 1:
          flspot.add(jan);
          break;
        case 2:

          flspot.add(feb);
         break;
        case 3:

          flspot.add(mar);
          break;
        case 4:

          flspot.add(apr);
          break;
        case 5:

          flspot.add(may);
          break;
        case 6:

          flspot.add(jun);
          break;
        case 7:

          flspot.add(jul);
          break;
        case 8:

          flspot.add(aug);
          break;
        case 9:

          flspot.add(sep);
          break;

        case 10:

          flspot.add(oct);
          break;
        case 11:

          flspot.add(nov);
          break;
        case 12:

          flspot.add(dec);
          break;

      }
    }

  setState(() {

  });
  }

  void getUser() async{
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      user = prefs.getString('user');
    });


  }
}
