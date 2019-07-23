import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scp/cards.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:scp/firebase/firebaseDBHandler.dart';

class Appointments extends StatefulWidget {
  @override
  _AppointmentsState createState() => _AppointmentsState();
}

bool isBookingAnonymously;

class _AppointmentsState extends State<Appointments> {
  double queryWidth;
  double textScaleFactor;
  static String counselDay, counselorName, psychName, psychDay;
  StreamSubscription<Event> _onSlotsChangedSubscription;
  ScpDatabase scpDatabase;

  void _onSlotsUpdated(Event event) async {
    setState(() {});
  }

  @override
  void initState() {
    /*ScpDatabase().init();*/
    isBookingAnonymously = false;
    scpDatabase = ScpDatabase();
    scpDatabase.init();
    _onSlotsChangedSubscription =
        ScpDatabase.slotsRef.onChildChanged.listen(_onSlotsUpdated);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _onSlotsChangedSubscription.cancel();
  }

  /*Widget anonymousButton() =>
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: queryWidth * 0.05),
          child: RaisedButton(
            child: ListTile(
              leading: Visibility(
                  visible: isBookingAnonymously,
                  child: Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: queryWidth * 0.090,
                  )),
              title: Text(
                  'Book${isBookingAnonymously? 'ing' : ''} Anonymously',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: queryWidth * 0.047,
                      fontFamily: 'PfDin',
                      color: Colors.white),
                ),
            ),
            onPressed: () {
              setState(() {
                isBookingAnonymously = !isBookingAnonymously;
              });
            },
            color: isBookingAnonymously ? Colors.green : Colors.grey,
            shape: StadiumBorder(),
          ),
        );
      });*/

  @override
  Widget build(BuildContext context) {

    queryWidth = MediaQuery.of(context).size.width;
    textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            60.0,
          ),
          child: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
              ),
              child: Text(
                'Book your appointment',
                style: TextStyle(
                    fontSize: queryWidth * 0.065,
                    fontFamily: 'PfDin',
                    fontWeight: FontWeight.w500),
              ),
            ),
            backgroundColor: Color.fromRGBO(
              54,
              66,
              87,
              1.0,
            ),
            leading: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(
                Icons.arrow_back_ios,
              ),
            ),
            elevation: 0.0,
          ),
        ),
        body: FutureBuilder(
            future: _setupRemoteConfig(),
            builder:
                (BuildContext context, AsyncSnapshot<RemoteConfig> snapshot) {
              return Center(
                  child: snapshot.hasData
                      ? appointmentScreen(context, snapshot.data)
                      : CircularProgressIndicator());
            }));
  }

  Widget appointmentScreen(BuildContext context, RemoteConfig remoteConfig) {
    return ListView(
      physics: AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 30.0),
      children: <Widget>[
        //anonymousButton(),
        SizedBox(
          height: 20.0,
        ),
        slotCard(context, this.queryWidth, this.textScaleFactor, psychDay,
            psychName, 'Psychiatrist'),
        SizedBox(
          height: 40.0,
        ),
        slotCard(context, this.queryWidth, this.textScaleFactor, counselDay,
            counselorName, 'Counsellor'),
      ],
    );
  }

  Future<RemoteConfig> _setupRemoteConfig() async {
    RemoteConfig remoteConfig = await RemoteConfig.instance;
    // Enable developer mode to relax fetch throttling
    remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
    await remoteConfig.fetch(expiration: const Duration(seconds: 0));
    await remoteConfig.activateFetched();
    counselDay = remoteConfig.getString('counsel_day');
    counselorName = remoteConfig.getString('counselor_name');
    psychName = remoteConfig.getString('psych_name');
    psychDay = remoteConfig.getString('psych_day');
    print(counselDay + 'hola');
    return remoteConfig;
  }
}
