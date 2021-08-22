import 'package:flutter/material.dart';
import 'package:geyserswitch_v66/utils/auth_helper.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My GeyserSwitch'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome Home'),
            ElevatedButton(
              child: Text("Log Out"),
                onPressed: () {
                AuthHelper.logOut();
                },
            )
          ],
        ),
      ),
    );
  }
}
