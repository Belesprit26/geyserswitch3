import 'dart:io';
import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gs_21/utils/user_preferences.dart';
import 'package:gs_21/widget/background_image_widget.dart';
import 'package:gs_21/widget/button_widget.dart';
import 'package:gs_21/widget/units_buttons_widget.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  List<String> units = [];

  String? singleImage;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final dbRef = FirebaseDatabase.instance.ref().child('GeyserSwitch');

  late final user = _auth.currentUser!;
  get userid => user.uid;

  @override
  void initState() {
    super.initState();

    name = UserPreferences.getUsername() ?? '';
    email = UserPreferences.getEmail() ?? '';
    units = UserPreferences.getUnits() ?? [];
  }

  Widget build(BuildContext context) => BackgroundImageWidget(
        image: AssetImage('assets/wallcrack.jpg'),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              'My Profile',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                const SizedBox(height: 40),
                singleImage != null && singleImage!.isNotEmpty
                    ? Image.network(
                        singleImage!,
                        height: 300,
                      )
                    : const SizedBox.shrink(),
                MaterialButton(
                  onPressed: () async {
                    //
                    XFile? _image = await singleImagePicker();
                    if (_image != null && _image.path.isNotEmpty) {
                      singleImage = await uploadImage(_image);
                      //list of images - we only need 1.
                      // select the image url
                      setState(() {
                        singleImage;
                      });
                      print(await uploadImage(_image));
                    }
                  },
                  color: Colors.blueGrey,
                  textColor: Colors.black,
                  child: const Text("New Profile Picture"),
                ),
                const SizedBox(height: 32),
                buildName(),
                const SizedBox(height: 12),
                buildEmail(),
                const SizedBox(height: 30),
                //buildUnits(),
                const SizedBox(height: 15),
                buildButton(),
              ],
            ),
          ),
        ),
      );

  Widget buildName() => buildTitle(
        title: 'Lastname',
        child: TextFormField(
          initialValue: name,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Your Lastname',
          ),
          onChanged: (name) => setState(() => this.name = name),
        ),
      );

  Widget buildEmail() => buildTitle(
        title: 'Email address',
        child: TextFormField(
          initialValue: email,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Your User Email',
          ),
          onChanged: (email) => setState(() => this.email = email),
        ),
      );

  Widget buildUnits() => buildTitle(
        title: 'Units',
        child: UnitsButtonsWidget(
          units: units,
          onSelectedUnit: (unit) => setState(() =>
              units.contains(unit) ? units.remove(unit) : units.add(unit)),
        ),
      );

  Widget buildButton() => ButtonWidget(
        text: 'Save',
        onClicked: () async {
          await UserPreferences.setUsername(name);
          await UserPreferences.setEmail(email);
          await UserPreferences.setUnits(units);

          final snackBar = SnackBar(
            content: Text(
              'You have successfully saved all changes',
              style: TextStyle(fontSize: 24),
            ),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(snackBar);
        },
      );

  Widget buildTitle({
    required String title,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          child,
        ],
      );
}

Future<XFile?> singleImagePicker() async {
  return await ImagePicker().pickImage(source: ImageSource.gallery);
}

// Upload image to Firebase
Future<String> uploadImage(XFile image) async {
  //current user id
  final userid = FirebaseAuth.instance.currentUser!.uid;
  print(getImageName(image));
  Reference db = FirebaseStorage.instance
      .ref()
      .child("imageFolder/user/${userid}/profilePicture");
  await db.putFile(File(image.path));
  return await db.getDownloadURL();
}

// Return Image Name
String getImageName(XFile image) {
  return image.path.split("/").last;
}
