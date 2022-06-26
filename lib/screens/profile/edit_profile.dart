import 'dart:io';

import 'package:bazar/Services/user.dart';
import 'package:bazar/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
import '../../config/palette.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class EditProfile extends StatefulWidget {
  final String? name;
  final String? username;
  final String? whatsapp;
  const EditProfile(
      {required this.name,
      required this.username,
      required this.whatsapp,
      Key? key})
      : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nametextController = TextEditingController();
  TextEditingController pseudocontroller = TextEditingController();
  TextEditingController whatsappcontroller = TextEditingController();
  String lastStreet = "Douala";
  String choiceStreet = "Douala";
  late String lastUsername = widget.username!;
  late String lastname = widget.name!;
  late String lastWhatsapp = widget.whatsapp!;
  String name = "";
  String username = "";
  bool isValidName = true, isValidUsername = true, isValidWhatsapp = true;
  @override
  void initState() {
    // TODO: implement initState

    setState(() {
      pseudocontroller.text = lastUsername;
      nametextController.text = lastname;
      whatsappcontroller.text = lastWhatsapp;
      choiceStreet = "Douala";
      // lastname=context.watch<User>().name;
      // lastUsername =context.watch<User>().username;
    });

    getdata();
    super.initState();
  }

  List<String> pointlist = <String>[];
  List<String> list = <String>[];
  getdata() async {
    await FirebaseFirestore.instance
        .collection("Ville")
        .doc('0JLnCiTjqF8ZcbOAs20E')
        .get()
        .then((value) {
      setState(() {
        pointlist = List.from(value.data()!["Liste_ville"]);
        if (kDebugMode) {
          print(pointlist.length);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      // lastUsername = context.watch<User>().username.substring(1);
      //lastname = context.watch<User>().name;
    });

    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light, // dark text for status bar
          statusBarColor: Palette.primaryColor));
    }
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Palette.primaryColor,
        centerTitle: true,
        title: const Text(
          'Edit profile',
          style: TextStyle(
            fontFamily: "Prompt_SemiBold",
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Palette.colorLight,
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SizedBox(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 25, 15, 8),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username

                      Container(
                        padding: const EdgeInsets.all(8.0),
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Palette.colorInput,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              name = value;
                              if (name.length > 2 &&
                                  name.toLowerCase() != "mokolo") {
                                isValidName = true;
                                print(isValidName);
                              } else {
                                isValidName = false;
                                print(isValidName);
                              }
                            });
                          },
                          controller: nametextController,
                          autocorrect: false,
                          textAlign: TextAlign.start,
                          validator: (value) {},
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Prompt_Regular',
                          ),
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Full Name',
                            hintStyle: TextStyle(color: Palette.colorgray),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      // Full Name

                      Container(
                        padding: const EdgeInsets.all(8.0),
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Palette.colorInput,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              username = value;
                              if (username.length > 2 &&
                                  username.toLowerCase() != "mokolo") {
                                isValidUsername = true;
                                print(isValidUsername);
                              } else {
                                isValidUsername = false;
                                print(isValidUsername);
                              }
                            });
                          },
                          controller: pseudocontroller,
                          autocorrect: false,
                          textAlign: TextAlign.start,
                          validator: (value) {},
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Prompt_Regular',
                          ),
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Full Name',
                            hintStyle: TextStyle(color: Palette.colorgray),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // Country
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Palette.colorInput,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/Cameroon.svg'),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'Cameroon',
                                style: TextStyle(
                                  fontFamily: "Prompt_Regular",
                                  fontWeight: FontWeight.w500,
                                  color: Palette.colorText,
                                  fontSize: 20,
                                ),
                              ),
                              const Spacer(),
                              SvgPicture.asset(
                                'assets/plus.svg',
                                color: Palette.colorText,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      // City

                      GestureDetector(
                        onTap: () {
                          PopupListCity();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Palette.colorInput,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                Text(
                                  choiceStreet,
                                  style: const TextStyle(
                                    fontFamily: "Prompt_Regular",
                                    fontWeight: FontWeight.w500,
                                    color: Palette.colorText,
                                    fontSize: 20,
                                  ),
                                ),
                                const Spacer(),
                                SvgPicture.asset(
                                  'assets/plus.svg',
                                  color: Palette.colorText,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 10,
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
                                onChanged: (value) {
                                  if (value.length == 9 && value[0] == "6") {
                                    isValidWhatsapp = true;
                                    print(isValidWhatsapp);
                                  } else {
                                    isValidWhatsapp = false;
                                    print(isValidWhatsapp);
                                  }
                                },
                                inputFormatters: <TextInputFormatter>[
                                  // PhoneNumberFormatter(),
                                  LengthLimitingTextInputFormatter(9),
                                  FilteringTextInputFormatter.allow(RegExp(
                                    "[^,.-]",
                                  )),
                                ],
                                // onChanged: _onChanged_number,
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
                    ],
                  ),
                ),
              )
            ],
          )),

          // BOUTTON DE VALIDATION DE MODIFICATION
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    textStyle: const TextStyle(
                      color: Palette.colorLight,
                      fontSize: 20,
                    ),
                    padding: const EdgeInsets.all(5),
                  ),
                  // textColor: Palette.colorText,
                  // color: Palette.secondColor,
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Edit",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Palette.colorText,
                        fontFamily: 'Prompt_Medium',
                      ),
                    ),
                  ),
                  onPressed: () async {
                    print(isValidName.toString() +
                        isValidUsername.toString() +
                        isValidWhatsapp.toString());
                    String info = "Your information is being modified...";
                    if (lastUsername == pseudocontroller.text &&
                        lastname == nametextController.text &&
                        whatsappcontroller.text == lastWhatsapp) {
                      SnackPopup("Your information is already up to date ",
                          Palette.primaryColor);
                    } else {
                      if (isValidName == true &&
                          isValidUsername == true &&
                          isValidWhatsapp == true) {
                        SnackPopup(info, Palette.primaryColor);
                        await uploadInfo().whenComplete(() => {
                              info =
                                  "Your information has been successfully updated",
                              SnackPopup(info, Palette.primaryColor)
                            });
                        // call service function
                      } else if (isValidName == false &&
                          isValidUsername == false &&
                          isValidWhatsapp == true) {
                        SnackPopup("The name and username are incorrect",
                            Palette.colorError);
                      } else if (isValidName == false &&
                          isValidUsername == false &&
                          isValidWhatsapp == false) {
                        SnackPopup("The form is incorrect", Palette.colorError);
                      } else if (isValidName == true &&
                          isValidUsername == true &&
                          isValidWhatsapp == false) {
                        SnackPopup("Please enter a correct whatsapp number",
                            Palette.colorError);
                      } else if (isValidName == false &&
                          isValidUsername == true &&
                          isValidWhatsapp == true) {
                        SnackPopup(
                            "Please enter a correct  name", Palette.colorError);
                      } else if (isValidName == true &&
                          isValidUsername == false &&
                          isValidWhatsapp == true) {
                        SnackPopup("Please enter a correct username",
                            Palette.colorError);
                      }
                    }
                    if (kDebugMode) {
                      print(lastname);
                      print(lastUsername);
                      print(lastWhatsapp);
                      print(nametextController.text);
                      print(pseudocontroller.text);
                      print(whatsappcontroller.text);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// Snack Bar error show
  void SnackPopup(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      // behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      duration: const Duration(seconds: 6),
      content: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              msg,
              style: const TextStyle(
                  color: Palette.colorLight,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Prompt_Regular'),
            ),
            SvgPicture.asset(
              'assets/close.svg',
              color: Palette.colorLight,
            ),
          ],
        ),
      ),
    ));
  }

// Upload user info
  Future<void> uploadInfo() async {
    // call service providr function
    Provider.of<User>(context, listen: false).updateUserInfo(
        nametextController.text,
        pseudocontroller.text,
        whatsappcontroller.text);
    context.read<User>().getcurentuser();
    //eturn false;
  }

  // Popup List categories
  // ignore: non_constant_identifier_names
  void PopupListCity() async {
    //  Cat();

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              height: MediaQuery.of(context).size.height * 2,
              color: Colors.white,
              child: Column(
                children: [
                  Topbar(
                      title: 'City',
                      onpressed: () {
                        Navigator.of(context).pop();
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: pointlist.length,
                        itemBuilder: (BuildContext context, int index) {
                          // print(pointlist.length);
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              setState(() {
                                choiceStreet = pointlist[index];
                                if (kDebugMode) {
                                  print(choiceStreet);
                                }
                              });
                            },
                            child: ItemVille(
                                ville: pointlist[index],
                                Pop: () {
                                  setState(() {
                                    choiceStreet = pointlist[index];
                                    if (kDebugMode) {
                                      print(choiceStreet);
                                    }
                                    Navigator.of(context).pop(); // Close popup
                                  });
                                }),
                          );
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }
}
