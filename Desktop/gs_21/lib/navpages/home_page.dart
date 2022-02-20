import 'dart:async';
import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gs_21/Service/Auth_Service.dart';
import 'package:gs_21/Service/database_manager.dart';
import 'package:gs_21/api/notification_api.dart';
import 'package:gs_21/pages/Dashboard.dart';
import 'package:gs_21/pages/SignInPage.dart';
import 'package:gs_21/utils/user_preferences.dart';
import 'package:gs_21/pages/edit_profile_page.dart';
import 'package:gs_21/widget/background_image_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, String? payload}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final dbRef = FirebaseDatabase.instance.ref().child('GeyserSwitch');

  final formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  List<String> units = [];

  bool value = false;
  bool value2 = false;
  bool value4 = false;
  bool value13 = false;
  bool value15 = false;
  bool isLoading = false;
  bool isOn = false;
  var spot = "";

  //
  late final user = _auth.currentUser!;

  get userid => user.uid;

  //

  @override
  void initState() {
    super.initState();

    var spot = dbRef
        .child(userid)
        .child("GeyserState")
        .child("switch1")
        .get()
        .then((DataSnapshot snapshot) {
      bool? spot = snapshot.value! as bool?;

      isLoading = true;
      setState(() {
        value = spot!;
      });

      print('spot is');
      print(spot);
      print('so value is');
      print(value);
    });

    name = UserPreferences.getUsername() ?? '';
    email = UserPreferences.getEmail() ?? '';

    //Notifications
    NotificationApi.init(initScheduled: true);
    listenNotifications();

    /// Optionally schedule notification on app start
    // NotificationApi.showScheduledNotification(
    //   title: 'Dinner',
    //   body: 'Today at 6 PM',
    //   payload: 'dinner_6pm',
    //   scheduledDate: DateTime.now().add(Duration(seconds: 12)),
    // );

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

  onUpdate() {
    setState(() {
      value = !value; //Toggle between True and False
    });
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

  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) =>
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Dashboard(payload: payload),
      ));

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return BackgroundImageWidget(
      image: AssetImage('assets/wallcrack.jpg'),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.clear_all,
                        color: Colors.black,
                      ),
                      Text(
                        "      My GeyserSwitch",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.logout_outlined),
                        onPressed: () async {
                          await authClass.logout();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => SignInPage()),
                              (route) => false);
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 5,
                ),

                //TODO New Name & Email Framework
                Text(
                  "The " + name + " Household",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),

                const SizedBox(height: 4),
                Text(userid),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(color: Colors.black),
                ),

                SizedBox(
                  height: 5,
                ),

                getCircularImage(210),

                SizedBox(
                  height: 50,
                ),
                //TODO Schedule Row of buttons
                const SizedBox(height: 15),

                Center(
                    child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.local_fire_department_sharp,
                    color: Colors.white,
                    size: 27.0,
                  ),
                  label: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(
                      'Temperature  ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: () {
                    print('Temp clicked');
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new Dashboard()));
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blueGrey,
                      padding: const EdgeInsets.all(12.0),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(23.0),
                      ),
                      elevation: 15.0),
                )),

                SizedBox(
                  height: 25,
                ),

                // The on/off Button
                FloatingActionButton.extended(
                  onPressed: () {
                    onUpdate();
                    writeData();
                  },
                  label: value ? Text("ON") : Text("OFF"),
                  elevation: 20,
                  backgroundColor: value ? Colors.green : Colors.blueGrey,
                  icon: value
                      ? Icon(Icons.offline_bolt)
                      : Icon(Icons.offline_bolt_outlined),
                ),

                SizedBox(
                  height: 25,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton.extended(
                      onPressed: () {
                        onChange2();
                        writeAlarm2();
                      },
                      label:
                          value2 ? Text("2am Auto: ON") : Text("2am Auto: OFF"),
                      elevation: 20,
                      backgroundColor: value2 ? Colors.green : Colors.blueGrey,
                      icon: value2
                          ? Icon(Icons.access_time)
                          : Icon(Icons.access_alarms),
                    ),
                    FloatingActionButton.extended(
                      onPressed: () {
                        onChange();
                        writeAlarm();
                      },
                      label:
                          value4 ? Text("4am Auto: ON") : Text("4am Auto: OFF"),
                      elevation: 20,
                      backgroundColor: value4 ? Colors.green : Colors.blueGrey,
                      icon: value4
                          ? Icon(Icons.access_time)
                          : Icon(Icons.access_alarms),
                    ),
                  ],
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
                      backgroundColor: value13 ? Colors.green : Colors.blueGrey,
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
                      backgroundColor: value15 ? Colors.green : Colors.blueGrey,
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
      ),
    );
  }

  Widget getCircularImage(double size) {
    return FutureBuilder(
        future: FireStoreDataBase().getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text(
              "Something went wrong",
            );
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Center(
              child: Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius:
                      new BorderRadius.all(new Radius.circular(size / 2)),
                  border: new Border.all(
                    color: Colors.black45,
                    width: 4.0,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) =>
                            new EditProfilePage(idUser: userid)));
                  },
                  child: ClipOval(
                    child: Image.network(
                      snapshot.data.toString(),
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          }
          /*return Image.network(
              snapshot.data.toString(),);*/
          //

          else
            return Center(
              child: Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius:
                      new BorderRadius.all(new Radius.circular(size / 2)),
                  border: new Border.all(
                    color: Colors.black54,
                    width: 4.0,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) =>
                            new EditProfilePage(idUser: userid)));
                  },
                  child: ClipOval(
                    child: Image.asset(
                      'assets/GeyserSwitch.png',
                      width: 210,
                      height: 190,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
        });
  }

  //TODO Alarm widget
  Widget buildButton({
    required String title,
    required IconData icon,
    required VoidCallback onClicked,
  }) =>
      Center(
          child: ElevatedButton.icon(
        icon: Icon(
          Icons.notifications_active_outlined,
          color: Colors.white,
          size: 27.0,
        ),
        label: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Text(
            'Morning Notification  ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        onPressed: onClicked,
        style: ElevatedButton.styleFrom(
            primary: Colors.blueGrey,
            padding: const EdgeInsets.all(12.0),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(23.0),
            ),
            elevation: 15.0),
      ));

  //Method for updating the ON/OFF Button
  Future<void> writeData() async {
    await dbRef.child(userid).child("GeyserState").set({"switch1": value});
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
