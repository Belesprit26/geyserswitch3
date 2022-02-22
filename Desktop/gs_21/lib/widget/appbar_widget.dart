import 'package:flutter/material.dart';
import 'package:gs_21/navpages/main_page.dart';

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    leading: BackButton(
        color: Colors.black,
        onPressed: () {
          Navigator.of(context).push(
              new MaterialPageRoute(builder: (context) => new MainPage()));
        }),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}
