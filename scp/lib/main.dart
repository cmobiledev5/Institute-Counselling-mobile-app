import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scp/cards.dart';
import 'package:scp/login.dart';
import 'package:scp/gradients.dart';
import 'package:scp/appointments.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:scp/userdata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'timetable/theorySection.dart';


import 'package:scp/time_table.dart';

//void main() => runApp(MyApp());
void main()=>runApp(
      MaterialApp(
        title: 'SCP Demo',
        routes: <String, WidgetBuilder>{
          '/homePage': (BuildContext context) => HomePage(title: 'SCP Home Page'),
          '/loginPage': (BuildContext context) => Login(),
          '/appointments': (BuildContext context) => Appointments(),
          '/timetable':(BuildContext context)=> TheorySection(),
          '/userdata':(BuildContext context)=>Userdata(),
          '/login':(BuildContext context)=>Login(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyApp(),
      ));

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      //statusBarColor: Colors.white70, //or set color with: Color(0xFF0000FF)
    //));
    return _handleCurrentScreen();
  }
}

Future<String> _fetchUserData(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}

Widget _handleCurrentScreen() {
  return new StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Login();
        } else {
          if (snapshot.hasData) {
            return FutureBuilder
              (
                future: _fetchUserData(context),
              builder: (_,snapshot){
                  print("Main.dart "+ snapshot.data.toString());
                  if(snapshot.data.toString()=="" || snapshot.data.toString()==null || snapshot.data.toString()=="null"){
                    return Userdata();
                  }
                  else{
                    return HomePage();
                  }
              },
            );
          }
          return Login();
        }
      });
}

class HomePage extends StatefulWidget {

  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform=const MethodChannel("FAQ_ACTIVITY");
  @override
  Widget build(BuildContext context) {
    Gradients().init(context);
    var queryWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      drawer: Drawer(
        child:ListTile(
          title: Text("Timetable"),
          onTap: (){
            Navigator.of(context).pop();
            Navigator.pushNamed(context, '/timetable');
          },

        ) ,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title:Text(
          'SCP',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
              fontSize: 40.0,
              fontWeight: FontWeight.w500,
              fontFamily: 'PfDin',
              letterSpacing: 2),
        ) ,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          appointmentCard(context, queryWidth, textScaleFactor),
          InkWell(
            onTap:()=> _startFAQActivity(),
              child: faqCard(context, queryWidth, textScaleFactor)),
          mentorsCard(context, queryWidth, textScaleFactor),
          timetableCard(context, queryWidth, textScaleFactor)
        ],
      ),
    );
  }
  
  _startFAQActivity() async{
    try {
      await platform.invokeMethod('startFaqActivity');
    } on PlatformException catch (e){
      print(e.message);
    }
  }
}
