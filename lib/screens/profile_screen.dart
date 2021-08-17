import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_tracker/constants/constants.dart';
import 'package:time_tracker/screens/login_screen.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key  key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String email,name;
  bool manager = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetails();
  }
  @override
  Widget build(BuildContext context) {
    Size _mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Container(
          color: applightColor,
          height: _mediaQuery.height,
          child: Container(
            height: _mediaQuery.height,
            child: Column(
              children: [
                SizedBox(height: 100,),
                Center(
                  child: CircleAvatar(child: Icon(Icons.person,size: 50,),radius: 50,),
                ),
                SizedBox(height: 10,),
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                ),
                SizedBox(height: 10,),
                Text(
                  email,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                ),
                SizedBox(height: 10,),
               manager==true? Text(
              'Manager' ,
               style: TextStyle(
               fontSize: 20,
               color: Colors.blue,
               fontWeight: FontWeight.bold,
               letterSpacing: 2),
          ): Text('Engineer'
          ,
          style: TextStyle(
              fontSize: 20,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
        ),
                SizedBox(height: 100,),
                TextButton(
                    child: Text(
                        "Logout",
                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)
                    ),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        backgroundColor: MaterialStateProperty.all<Color>(appdarkColor),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: appdarkColor),
                            )
                        )
                    ),
                    onPressed: ()async{

                      final prefs = await SharedPreferences.getInstance();

                      await prefs.setBool("isLogin", true);
                      await prefs.setString("user", '');
                      await prefs.setString("email", '');
                      await prefs.setBool("isManager", null);
                      await prefs.setString("name", '');

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
    (Route<dynamic> route) => false);


                    }
                ),
              ],
            )
          ),
        ),
      ),
    );
  }

  void getDetails() async{
    final prefs = await SharedPreferences.getInstance();
  setState(() {
    name = prefs.getString('name');
    email = prefs.getString('email');
    manager = prefs.getBool('isManager');
  });


  }
}
