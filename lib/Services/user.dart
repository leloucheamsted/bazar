import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import 'package:shared_preferences/shared_preferences.dart';

class User with ChangeNotifier {
  User(
      {required this.name,
      required this.imgUrl,
      required this.username,
      required this.whatsapp,
      required this.uiud});

  String name;
  String username;
  String whatsapp;
  String imgUrl;
  String uiud;

  // final  User  _user=  User(name: 'name', imgUrl: 'imgUrl', username: 'username', whatsapp: 'whatsapp');
  var datas = {};
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  // User get user => _user;

  void getcurentuser() async {
    dynamic data;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = prefs.getString('uuid') ?? '';
    if (kDebugMode) {
      print(uuid);
      print(uiud.length);
    }
    if (uuid.length > 1) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(uuid)
          .get()
          .then((DocumentSnapshot event) {
        if (event.exists) {
          data = event.data();
          if (kDebugMode) {
            print('Document data: $data');
          }
          name = event['name'];
          username = data['username'];
          whatsapp = data['whatsapp'];
          imgUrl = data['avatarUrl'];
          uiud = data['uuid'];
        } else {
          if (kDebugMode) {
            print('Document does not exist on the database');
          }
        }
        // for (var doc in event.docs) {
        // print("My event is ======================" + event['name']);

        if (kDebugMode) {
          print("Mon nom utilisateur" + name);
          print("Mon username" + username);
          print("Mon whatapp" + whatsapp);
          print("Mon avatar" + imgUrl);
          print("Mon uiud " + uiud);
        }
      });
      notifyListeners();
    }
    notifyListeners();
  }

  void updateUserInfo(String name, username, whatsapp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = prefs.getString('uuid') ?? '';
    if (kDebugMode) {
      print(uuid);
      print(uiud.length);
    }
    users
        .doc(uuid)
        .update({
          'name': name,
          'username': '@' + username,
          'whatsapp': "+237" + whatsapp
        })
        .then((value) => {
              // ignore: avoid_print
              print("User Updated"),
              getcurentuser(),
            })
        // ignore: invalid_return_type_for_catch_error, avoid_print
        .catchError((error) => print("Failed to update user: $error"));
    getcurentuser();
    notifyListeners();
  }

  void main() {
    var _user = User(
        name: name,
        imgUrl: imgUrl,
        username: username,
        whatsapp: whatsapp,
        uiud: uiud);
    _user.getcurentuser();
  }
}
