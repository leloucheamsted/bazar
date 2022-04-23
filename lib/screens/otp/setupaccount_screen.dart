// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../config/palette.dart';
// Import the firebase_core and cloud_firestore plugin
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
  late String numero1 = Get.arguments.toString();
  bool isValid = false;
  bool visibilityError = false;
  bool visibilitySucces = false;

  @override
  initState() {
    super.initState();
    saveNumber();
  }

  saveNumber() async {
    numero1 = Get.arguments.toString();
    final prefs = await SharedPreferences.getInstance();
    const key = 'numero';
    final value = numero1;
    prefs.setString(key, value);
    if (kDebugMode) {
      print('numero:$value');
    }
  }

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
                })
              })
          // ignore: invalid_return_type_for_catch_error, avoid_print
          .catchError((error) => print("Failed to add user: $error"));
      if (kDebugMode) {
        print(prefs.getString('pseudo'));
      }
      if (kDebugMode) {
        print(prefs.getString('nom'));
      }
      if (kDebugMode) {
        print(prefs.getString('numero'));
      }
      // Call the user's CollectionReference to add a new user
    }

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Palette.colorLight,
        iconTheme: const IconThemeData(color: Palette.colorText),
        centerTitle: true,
        title: const Text('mokolo',
            style: TextStyle(
                fontSize: 40.0,
                fontFamily: 'Prompt_Bold',
                color: Palette.primaryColor)),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Align(
          alignment: Alignment.center,
          child: ListView(
            children: [
              const Align(
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
              const Align(
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
              const SizedBox(
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
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Prompt_Regular',
                  ),
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Full name (ex: Ben Biya)',
                    hintStyle: TextStyle(color: Palette.secondColor),
                  ),
                ),
              ),

              const SizedBox(
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
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Prompt_Regular',
                  ),
                  decoration: const InputDecoration.collapsed(
                    hintText: 'username (ex: benbiya)',
                    hintStyle: TextStyle(color: Palette.secondColor),
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              visibilityError
                  ? const Text(
                      'Username not available',
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: "Prompt_Regular",
                        fontSize: 14,
                      ),
                    )
                  : Container(),
              visibilitySucces
                  ? const Text(
                      'Username available',
                      style: TextStyle(
                        color: Palette.validNameColorStatut,
                        fontFamily: "Prompt_Regular",
                        fontSize: 14,
                      ),
                    )
                  : Container(),

              const SizedBox(
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
                  child: const Text(
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
                          if (kDebugMode) {
                            print('$Get.arguments');
                          }
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
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
