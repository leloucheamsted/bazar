// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
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
  TextEditingController whatsappcontroller = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  late Future<String> nom, pseudo, numero, whatsappNumber, uid, counter;
  late String numero1 = Get.arguments.toString();
  String uuid = const Uuid().v4();
  bool isValid = false;
  bool isValidName = false;
  bool visibilityError = false;
  bool visibilitySucces = false;
  int length = 0;
  bool status = false;
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

  // ignore: non_constant_identifier_names
  _onChanged_number(String value) {
    setState(() {
      length = value.length;
      if (length == 9 && whatsappcontroller.text[0] == "6") {
        status = true;
      } else {
        status = false;
      }
    });
  }

  // ignore: non_constant_identifier_names
  _onChanged_name(String value) {
    setState(() {
      if (value.length > 2) {
        isValidName = true;
        if (kDebugMode) {
          print(nametextController.text);
          print(isValidName);
        }
      } else {
        isValidName = false;
      }
    });
  }

  // ignore: non_constant_identifier_names
  _onChanged_username(String value) {
    setState(() {
      if (value.length <= 3) {
        isValid = false;
        visibilityError = false;
        visibilitySucces = false;
      } else {
        isValid = true;
        if (value == "mokolo" || value == "Mokolo" || value == "MOKOLO") {
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
    DocumentReference users =
        FirebaseFirestore.instance.collection('Users').doc(uuid);

    Future addUser() async {
      final user = {
        'name': nametextController.text,
        'username': '@' + pseudocontroller.text,
        'number': Get.arguments.toString(),
        'followers': [],
        'following': [],
        'publication': [],
        'balance': 0,
        'whatsapp': "+237" + whatsappcontroller.text,
        'uuid': uuid,
        'avatarUrl':
            'https://firebasestorage.googleapis.com/v0/b/basic-aede4.appspot.com/o/Group%20121.jpg?alt=media&token=aaa44834-ecd2-40f4-a19a-e1ee949433d6'
      };
      await users
          .set(user)
          .then((value) => {
                Navigator.of(context)
                    .popUntil(ModalRoute.withName(Navigator.defaultRouteName)),
              })
          // ignore: invalid_return_type_for_catch_error, avoid_print
          .catchError((error) => print("Failed to add user: $error"));
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
                  color: Palette.colorInput,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextFormField(
                  // onChanged: _onChanged_name,
                  controller: nametextController,
                  autocorrect: false,
                  textAlign: TextAlign.start,
                  // focusNode: FocusNode(),
                  onChanged: _onChanged_name,
                  // validator: (value) {},
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
                  color: Palette.colorInput,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextFormField(
                  onChanged: _onChanged_username,
                  controller: pseudocontroller,
                  autocorrect: false,
                  textAlign: TextAlign.start,
                  validator: (value) {
                    if (value == "base" || value == "basic") {
                      return "Username  not valid";
                    }
                    return null;
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
                height: 5,
              ),
              Row(
                children: [
                  GestureDetector(
                    child: Container(
                      height: 45,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Palette.colorInput,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset('assets/Cameroon.svg'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Palette.colorInput,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: whatsappcontroller,
                        inputFormatters: <TextInputFormatter>[
                          // PhoneNumberFormatter(),
                          LengthLimitingTextInputFormatter(9),
                          FilteringTextInputFormatter.allow(RegExp(
                            "[^,.-]",
                          )),
                        ],
                        onChanged: _onChanged_number,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Prompt_Regular',
                        ),
                        decoration: const InputDecoration.collapsed(
                            hintText: 'whatsapp number'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50.0,
                width: double.infinity,
                child: RaisedButton(
                  textColor: Colors.white,
                  color: isValid &&
                          visibilitySucces &&
                          status == true &&
                          isValidName == true
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
                  onPressed: isValid &&
                          visibilitySucces &&
                          status == true &&
                          isValidName == true
                      ? () async {
                          final prefs = await SharedPreferences.getInstance();
                          FocusScope.of(context).unfocus();
                          addUser();
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
                          whatsappNumber = prefs
                              .setString('whatsapp', whatsappcontroller.text)
                              .then((bool success) {
                            return whatsappcontroller.text;
                          });
                          uid = prefs
                              .setString('uuid', uuid)
                              .then((bool success) {
                            return uid;
                          });
                          counter = prefs
                              .setString('counter', "1")
                              .then((bool success) {
                            return counter;
                          });
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
}
