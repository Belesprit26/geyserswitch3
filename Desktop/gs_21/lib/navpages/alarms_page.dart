import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gs_21/Service/Auth_Service.dart';
import 'package:gs_21/widget/background_image_widget.dart';

class AlarmsPage extends StatefulWidget {
  const AlarmsPage({Key? key}) : super(key: key);

  @override
  _AlarmsPageState createState() => _AlarmsPageState();
}

class _AlarmsPageState extends State<AlarmsPage> {
  AuthClass authClass = AuthClass();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final dbRef = FirebaseDatabase.instance.ref().child('GeyserSwitch');

  bool value2 = false;
  bool value4 = false;
  bool value13 = false;
  bool value15 = false;
  bool isLoading = false;
  bool isOn = false;

  late final user = _auth.currentUser!;

  get userid => user.uid;

  @override
  void initState() {
    super.initState();

    var times4 = dbRef
        .child(userid)
        .child("TimerState")
        .child("alarm4")
        .get()
        .then((DataSnapshot snapshot) {
      bool? times4 = snapshot.value! as bool?;

      isLoading = true;
      setState(() {
        value4 = times4!;
      });

      print('alarm4 is');
      print(times4);
      print('so value4 is');
      print(value4);
    });

    var times2 = dbRef
        .child(userid)
        .child("Timer2State")
        .child("alarm2")
        .get()
        .then((DataSnapshot snapshot) {
      bool? times2 = snapshot.value! as bool?;

      isLoading = true;
      setState(() {
        value2 = times2!;
      });

      print('alarm2 is');
      print(times2);
      print('so value2 is');
      print(value2);
    });

    var times13 = dbRef
        .child(userid)
        .child("Timer13State")
        .child("alarm13")
        .get()
        .then((DataSnapshot snapshot) {
      bool? times13 = snapshot.value! as bool?;

      isLoading = true;
      setState(() {
        value13 = times13!;
      });

      print('alarm13 is');
      print(times13);
      print('so value13 is');
      print(value13);
    });

    var times15 = dbRef
        .child(userid)
        .child("Timer15State")
        .child("alarm15")
        .get()
        .then((DataSnapshot snapshot) {
      bool? times15 = snapshot.value! as bool?;

      isLoading = true;
      setState(() {
        value15 = times15!;
      });

      print('alarm15 is');
      print(times13);
      print('so value15 is');
      print(value15);
    });
    isLoading = false;
  }

  onChange() {
    setState(() {
      value4 = !value4; //Toggle between True and False
    });
  }

  onChange2() {
    setState(() {
      value2 = !value2; //Toggle between True and False
    });
  }

  onChange13() {
    setState(() {
      value13 = !value13; //Toggle between True and False
    });
  }

  onChange15() {
    setState(() {
      value15 = !value15; //Toggle between True and False
    });
  }

  Widget build(BuildContext context) {
    return BackgroundImageWidget(
        image: AssetImage('assets/wallcrack.jpg'),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "My Timers",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 110,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(40.0),
                                  ),
                                  title: Text(
                                      "Set & Forget/Automatic Time Scheduler"),
                                  content: Text(
                                      "These settings allow you to set an automated timer for your geyser to heat up daily at set times."
                                      "The geyser will heat up from start time for a duration of 2hours before automatically turning itself off."
                                      "These settings will run daily until your timer is turned off. All time schedules are set outside of peak hours to maximise your total savings. Set your morning & evening times and let GeyserSwitch handle the rest"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Got it"))
                                  ],
                                ));
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          padding: const EdgeInsets.all(11.0),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(55.0),
                          ),
                          elevation: 15.0),
                      child: Icon(
                        Icons.info_outline_rounded,
                      )),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "My Morning Schedules",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {
                          onChange2();
                          writeAlarm2();
                        },
                        label: value2
                            ? Text("2am Auto: ON")
                            : Text("2am Auto: OFF"),
                        elevation: 20,
                        enableFeedback: true,
                        backgroundColor:
                            value2 ? Colors.green : Colors.blueGrey,
                        icon: value2
                            ? Icon(Icons.access_time)
                            : Icon(Icons.access_alarms),
                      ),
                      FloatingActionButton.extended(
                        onPressed: () {
                          onChange();
                          writeAlarm();
                        },
                        label: value4
                            ? Text("4am Auto: ON")
                            : Text("4am Auto: OFF"),
                        elevation: 20,
                        enableFeedback: true,
                        backgroundColor:
                            value4 ? Colors.green : Colors.blueGrey,
                        icon: value4
                            ? Icon(Icons.access_time)
                            : Icon(Icons.access_alarms),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Text(
                    "My Evening Schedules",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {
                          onChange13();
                          writeAlarm13();
                        },
                        label: value13
                            ? Text("1pm Auto: ON")
                            : Text("1pm Auto: OFF"),
                        elevation: 20,
                        enableFeedback: true,
                        backgroundColor:
                            value13 ? Colors.green : Colors.blueGrey,
                        icon: value13
                            ? Icon(Icons.access_time)
                            : Icon(Icons.access_alarms),
                      ),
                      FloatingActionButton.extended(
                        onPressed: () {
                          onChange15();
                          writeAlarm15();
                        },
                        label: value15
                            ? Text("3pm Auto: ON")
                            : Text("3pm Auto: OFF"),
                        elevation: 20,
                        enableFeedback: true,
                        backgroundColor:
                            value15 ? Colors.green : Colors.blueGrey,
                        icon: value15
                            ? Icon(Icons.access_time)
                            : Icon(Icons.access_alarms),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> writeAlarm() async {
    await dbRef.child(userid).child("TimerState").set({"alarm4": value4});
  }

  Future<void> writeAlarm2() async {
    await dbRef.child(userid).child("Timer2State").set({"alarm2": value2});
  }

  Future<void> writeAlarm13() async {
    await dbRef.child(userid).child("Timer13State").set({"alarm13": value13});
  }

  Future<void> writeAlarm15() async {
    await dbRef.child(userid).child("Timer15State").set({"alarm15": value15});
  }
}
