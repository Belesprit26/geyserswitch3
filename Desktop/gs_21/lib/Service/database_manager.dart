import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:gs_21/navpages/profile_page.dart';

class FireStoreDataBase {
  String? downloadURL;

  Future getData() async {
    try {
      await downloadURLExample();
      return downloadURL;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<void> downloadURLExample() async {
    final userid = FirebaseAuth.instance.currentUser!.uid;
    downloadURL = await FirebaseStorage.instance
        .ref()
        .child("imageFolder/user/${userid}/profilePicture")
        .getDownloadURL();
    debugPrint(downloadURL.toString());
  }
}
