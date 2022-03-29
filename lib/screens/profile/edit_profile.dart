import 'dart:io';

import 'package:bazar/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/palette.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nametextController = TextEditingController();
  TextEditingController pseudocontroller = TextEditingController();
  String lastStreet = "Douala";
  String choiceStreet = "Douala";
  String lastUsername = 'lelouche';
  String lastname = "amsted";
  String name = "";
  String username = "";
  @override
  void initState() {
    // TODO: implement initState

    setState(() {
      pseudocontroller.text = lastUsername;
      nametextController.text = lastname;
      choiceStreet = "Douala";
      username = lastUsername;
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
        print(pointlist.length);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light, // dark text for status bar
          statusBarColor: Palette.primaryColor));
    }
    return Scaffold(
      body: Stack(
        children: [
          Container(
              child: Column(
            children: [
              Topbar(
                  title: 'Edit profile',
                  onpressed: () {
                    Navigator.of(context).pop();
                  }),
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
                              username = value;
                              print(username);
                            });
                          },
                          controller: pseudocontroller,
                          autocorrect: false,
                          textAlign: TextAlign.start,
                          focusNode: FocusNode(),
                          validator: (value) {},
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Prompt_Regular',
                          ),
                          decoration: InputDecoration.collapsed(
                            hintText: 'Username',
                            hintStyle: TextStyle(color: Palette.colorgray),
                          ),
                        ),
                      ),

                      SizedBox(
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
                              name = value;
                              print(name);
                            });
                          },
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
                            hintText: 'Full Name',
                            hintStyle: TextStyle(color: Palette.colorgray),
                          ),
                        ),
                      ),
                      SizedBox(
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
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Cameroon',
                                style: TextStyle(
                                  fontFamily: "Prompt_Regular",
                                  fontWeight: FontWeight.w500,
                                  color: Palette.colorText,
                                  fontSize: 20,
                                ),
                              ),
                              Spacer(),
                              SvgPicture.asset(
                                'assets/plus.svg',
                                color: Palette.colorText,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
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
                                  style: TextStyle(
                                    fontFamily: "Prompt_Regular",
                                    fontWeight: FontWeight.w500,
                                    color: Palette.colorText,
                                    fontSize: 20,
                                  ),
                                ),
                                Spacer(),
                                SvgPicture.asset(
                                  'assets/plus.svg',
                                  color: Palette.colorText,
                                ),
                              ],
                            ),
                          ),
                        ),
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
              child: Container(
                width: double.infinity,
                child: OutlineButton(
                  textColor: Palette.colorText,
                  color: Palette.secondColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Edit",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Prompt_Medium',
                      ),
                    ),
                  ),
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                      // behavior: SnackBarBehavior.floating,
                      backgroundColor: Palette.colorError,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(bottom: 0.0),
                      duration: new Duration(seconds: 6),
                      content: Container(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text(
                              "Username not available",
                              style: TextStyle(
                                  color: Palette.colorLight,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Prompt_Regular'),
                            ),
                            new SvgPicture.asset(
                              'assets/close.svg',
                              color: Palette.colorLight,
                            ),
                          ],
                        ),
                      ),
                    ));
                    updateProfile();
                  },
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateProfile() {
    print('object');
  }

  // Popup List categories
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
                  SizedBox(
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
                                print(choiceStreet);
                              });
                            },
                            child: ItemVille(
                                ville: pointlist[index],
                                Pop: () {
                                  setState(() {
                                    choiceStreet = pointlist[index];
                                    print(choiceStreet);
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
