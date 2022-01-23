import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geyserswitch3/pages/HomePage.dart';

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    leading: BackButton(
        color: Colors.black,
        onPressed: () {
          Navigator.of(context).push(
              new MaterialPageRoute(builder: (context) => new HomePage()));
        }),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}
