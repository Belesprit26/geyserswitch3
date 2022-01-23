import 'dart:async';
import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geyserswitch3/Service/Auth_Service.dart';
import 'package:geyserswitch3/Service/database_manager.dart';
import 'package:geyserswitch3/api/notification_api.dart';
import 'package:geyserswitch3/pages/Dashboard.dart';
import 'package:geyserswitch3/pages/SignInPage.dart';
import 'package:geyserswitch3/utils/user_preferences.dart';
import 'package:geyserswitch3/pages/edit_profile_page.dart';
import 'package:geyserswitch3/widget/background_image_widget.dart';

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
  bool isLoading = false;
  bool isOn = false;

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
        .child("switch")
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
  }

  onUpdate() {
    setState(() {
      value = !value; //Toggle between True and False
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
                  height: 30,
                ),

                SizedBox(
                  height: 30,
                ),
                //TODO Schedule Row of buttons
                const SizedBox(height: 30),

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
                  height: 30,
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
    await dbRef.child(userid).child("GeyserState").set({"switch": value});
  }
}
