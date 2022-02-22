import 'package:flutter/material.dart';
import 'package:gs_21/navpages/alarms_page.dart';
import 'package:gs_21/navpages/home_page.dart';
import 'package:gs_21/navpages/profile_page.dart';
import 'package:gs_21/navpages/temp_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [
    HomePage(),
    TempPage(),
    AlarmsPage(),
    ProfilePage(),
  ];
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        enableFeedback: true,
        unselectedFontSize: 0,
        selectedFontSize: 13,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black.withOpacity(1.0),
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
        showUnselectedLabels: false,
        showSelectedLabels: true,
        elevation: 2,
        items: [
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.apps_sharp)),
          BottomNavigationBarItem(
              label: "Temperature",
              icon: Icon(Icons.local_fire_department_sharp)),
          BottomNavigationBarItem(
              label: "Alarms", icon: Icon(Icons.alarm_add_sharp)),
          BottomNavigationBarItem(label: "Profile", icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
