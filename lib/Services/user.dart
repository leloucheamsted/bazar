import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../data/user.dart';

class User with ChangeNotifier{
  User({required this.name,required this.imgUrl,required this.username,required this.whatsapp,required this.uiud});

  String name;
  String username;
  String whatsapp;
  String imgUrl;
  String uiud;


  // final  User  _user=  User(name: 'name', imgUrl: 'imgUrl', username: 'username', whatsapp: 'whatsapp');
  var datas={};

  // User get user => _user;

 void getcurentuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid =  prefs.getString('uuid')?? '';
    if(kDebugMode){
      print(uuid);
    }
      if(uuid.length>1){
        await FirebaseFirestore.instance.collection("Users").doc("e0CPkvCtazKCgTUAWP1U").get().then((event) {
          // for (var doc in event.docs) {
           name=event['name'];
            username=event['username'];
            whatsapp=event['whatsapp'];
            imgUrl=event['avatarUrl'];
            uiud=event['uiud'];
            print(name);
            print(username);
            print(whatsapp);
            print(imgUrl);
            print(uiud);
        //  }
        });
        notifyListeners();
      }
      notifyListeners();
    }

    void main(){
      var _user = User(name: name, imgUrl: imgUrl, username: username, whatsapp: whatsapp,uiud: uiud);
      _user.getcurentuser();
    }

}