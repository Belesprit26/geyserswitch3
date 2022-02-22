import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:gs_21/Service/CircularProgress.dart';
import 'package:gs_21/navpages/main_page.dart';

class TempPage extends StatefulWidget {
  const TempPage({Key? key, String? payload}) : super(key: key);
  @override
  _TempPageState createState() => _TempPageState();
}

class _TempPageState extends State<TempPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final databaseReference = FirebaseDatabase.instance.ref();

  late final User user = _auth.currentUser!;

  get userid => user.uid;

  late AnimationController progressController;
  late Animation<double> tempAnimation;
  late Animation<double> humidityAnimation;

  @override
  void initState() {
    super.initState();

    var temp = databaseReference
        .child('GeyserSwitch')
        .child(userid)
        .child("Data")
        .child("Temperature")
        .get()
        .then((DataSnapshot snapshot) {
      double? temp = snapshot.value! as double?;

      isLoading = true;
      setState(() {
        temp = temp!;
      });
      print(temp);
      _DashboardInit(temp!);
    });
  }

  // ignore: non_constant_identifier_names
  _DashboardInit(double temp) {
    progressController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500)); //1.5s

    tempAnimation =
        Tween<double>(begin: -25, end: temp).animate(progressController)
          ..addListener(() {
            setState(() {});
          });

    progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.black])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'My Temperature',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: new IconButton(
              icon: Icon(
                Icons.arrow_back_ios_sharp,
                color: Colors.transparent,
              ),
              onPressed: () {}),
        ),
        body: Center(
            child: isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CustomPaint(
                        foregroundPainter:
                            CircleProgress(tempAnimation.value, true),
                        child: Container(
                          width: 200,
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Temperature'),
                                Text(
                                  '${tempAnimation.value.toInt()}',
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '°C',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Text(
                    'Loading...',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )),
      ),
    );
  }

  Future<Null> handleGetBack() async {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (builder) => MainPage()), (route) => false);
  }
}
