import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../config/palette.dart';
// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SetupAccountScreen extends StatefulWidget {
  const SetupAccountScreen({Key? key}) : super(key: key);

  @override
  _SetupAccountScreenState createState() => _SetupAccountScreenState();
}

class _SetupAccountScreenState extends State<SetupAccountScreen> {
  TextEditingController nametextController = TextEditingController();
  TextEditingController pseudocontroller = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  late Future<String> nom, pseudo, numero;
  late int _count;
  bool isValid = false;
  bool visibilityError = false;
  bool visibilitySucces = false;
  _onChanged(String value) {
    setState(() {
      if (value.length <= 3) {
        isValid = false;
        visibilityError = false;
        visibilitySucces = false;
      } else {
        isValid = true;
        if (value == "basic" || value == "Basic" || value == "BASIC") {
          visibilityError = true;
          visibilitySucces = false;
        } else {
          visibilityError = false;
          visibilitySucces = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    Future addUser() async {
      final prefs = await SharedPreferences.getInstance();

      final user = {
        'name': nametextController.text,
        'username': '@' + pseudocontroller.text,
        'number': Get.arguments.toString(),
        'followers': [],
        'following': [],
        'publication': [],
        'balance': 0,
      };
      await users
          .add(user)
          .then((value) => {
                Navigator.of(context)
                    .popUntil(ModalRoute.withName(Navigator.defaultRouteName)),
                setState(() {
                  nom = prefs
                      .setString('nom', nametextController.text)
                      .then((bool success) {
                    return nametextController.text;
                  });
                  pseudo = prefs
                      .setString('pseudo', '@' + pseudocontroller.text)
                      .then((bool success) {
                    return '@' + pseudocontroller.text;
                  });
                  numero = prefs
                      .setString('numero', Get.arguments.toString())
                      .then((bool success) {
                    _count = prefs.setInt('count', 1) as int;
                    return Get.arguments.toString();
                  });
                })
              })
          .catchError((error) => print("Failed to add user: $error"));
      print(prefs.getString('pseudo'));
      print(prefs.getString('nom'));
      print(prefs.getString('numero'));
      // Call the user's CollectionReference to add a new user
    }

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Palette.colorLight,
        iconTheme: IconThemeData(color: Palette.colorText),
        centerTitle: true,
        title: Text('mokolo',
            style: TextStyle(
                fontSize: 40.0,
                fontFamily: 'Prompt_Bold',
                color: Palette.primaryColor)),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Align(
          alignment: Alignment.center,
          child: ListView(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Setup account',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontFamily: 'Prompt_Bold',
                    color: Palette.colorText,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Create a username to get started',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Prompt_Regular',
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),

// Full name of user
              Container(
                padding: const EdgeInsets.all(8.0),
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Palette.colorgray,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextFormField(
                  // onChanged: _onChanged,
                  controller: nametextController,
                  autocorrect: false,
                  textAlign: TextAlign.start,
                  focusNode: FocusNode(),
                  validator: (value) {},
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Prompt_Regular',
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Full name (ex: Ben Biya)',
                    hintStyle: TextStyle(color: Palette.secondColor),
                  ),
                ),
              ),

              SizedBox(
                height: 8,
              ),

              //   Textfield Name
              Container(
                padding: const EdgeInsets.all(8.0),
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Palette.colorgray,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextFormField(
                  onChanged: _onChanged,
                  controller: pseudocontroller,
                  autocorrect: false,
                  textAlign: TextAlign.start,
                  validator: (value) {
                    if (value == "base" || value == "basic") {
                      return "Username  not valid";
                    }
                  },
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Prompt_Regular',
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: 'username (ex: benbiya)',
                    hintStyle: TextStyle(color: Palette.secondColor),
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),
              visibilityError
                  ? Text(
                      'Username not available',
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: "Prompt_Regular",
                        fontSize: 14,
                      ),
                    )
                  : new Container(),
              visibilitySucces
                  ? Text(
                      'Username available',
                      style: TextStyle(
                        color: Palette.validNameColorStatut,
                        fontFamily: "Prompt_Regular",
                        fontSize: 14,
                      ),
                    )
                  : new Container(),

              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50.0,
                width: double.infinity,
                child: RaisedButton(
                  textColor: Colors.white,
                  color: isValid && visibilitySucces
                      ? Palette.primaryColor
                      : Palette.disableButton,
                  disabledColor: Palette.disableButton,
                  disabledTextColor: Palette.colorLight,
                  child: Text(
                    "Valid",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Prompt_Medium',
                    ),
                  ),
                  onPressed: isValid && visibilitySucces
                      ? () async {
                          FocusScope.of(context).unfocus();
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString(
                              'name', nametextController.text);
                          await prefs.setString(
                              'username', pseudocontroller.text);
                          await prefs.setString('number', Get.arguments);
                          addUser();
                          print('$Get.arguments');
                        }
                      : null,
                  //status
                  //     ? () {
                  //         Get.to(
                  //           EnterCodeScreen(),
                  //           transition: Transition.rightToLeft,
                  //           duration: Duration(seconds: 1),
                  //         );
                  //       }
                  //     : null,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// GO NEXT FOCUS

// Add Users in Firebase

}
