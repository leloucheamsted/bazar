import 'dart:io';

import 'package:bazar/config/palette.dart';
import 'package:bazar/screens/profile/edit_profile.dart';
import 'package:bazar/widgets/item_ville.dart';
import 'package:bazar/widgets/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SettingsProfile extends StatelessWidget {
  const SettingsProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light, // dark text for status bar
          statusBarColor: Palette.primaryColor));
    }
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness:
                Brightness.dark, // dark text for status bar
            statusBarColor: Colors.white));

        return false;
      },
      child: Scaffold(
        backgroundColor: Palette.colorLight,
        body: Container(
          child: Column(
            children: [
              Topbar(
                  title: 'Settings',
                  onpressed: () {
                    if (Platform.isAndroid) {
                      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                          systemNavigationBarIconBrightness: Brightness.dark,
                          statusBarIconBrightness:
                              Brightness.dark, // dark text for status bar
                          statusBarColor: Colors.transparent));
                    }
                    Navigator.of(context).pop();
                  }),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile
                      Container(
                        width: double.infinity,
                        child: Text(
                          'Profile',
                          style: TextStyle(
                              fontFamily: "Prompt_SemiBold",
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              color: Palette.colorText),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Palette.colorInput,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Column(
                            children: [
                              ItemSettings(
                                  settings: 'Edit my profile',
                                  Pop: () {
                                    Get.to(EditProfile(),
                                        transition:
                                            Transition.rightToLeftWithFade);
                                  }),
                              ItemSettings(
                                  settings: 'Share profile',
                                  Pop: () {
                                    print('object');
                                  }),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      // Settings
                      Container(
                        width: double.infinity,
                        child: Text(
                          'Settings',
                          style: TextStyle(
                              fontFamily: "Prompt_SemiBold",
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              color: Palette.colorText),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Palette.colorInput,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Column(
                            children: [
                              ItemSettings(
                                  settings: 'Privacy policy', Pop: () {}),
                              ItemSettings(
                                  settings: 'Terms of use', Pop: () {}),
                              ItemSettings(
                                  settings: 'Rate the app', Pop: () {}),
                              ItemSettings(
                                  settings: 'Share the app', Pop: () {}),
                            ],
                          ),
                        ),
                      ),
                    ],
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
