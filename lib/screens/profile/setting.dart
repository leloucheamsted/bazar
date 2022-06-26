import 'dart:io';

import 'package:bazar/config/palette.dart';
import 'package:bazar/screens/profile/edit_profile.dart';
import 'package:bazar/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../../Services/user.dart';

class SettingsProfile extends StatefulWidget {
  const SettingsProfile(
      {required this.name,
      required this.username,
      required this.whatsapp,
      Key? key})
      : super(key: key);
  final String? name;
  final String? username;
  final String whatsapp;
  @override
  _SettingsProfileState createState() => _SettingsProfileState();
}

class _SettingsProfileState extends State<SettingsProfile> {
  late String name = widget.name!;
  late String username = widget.username!;
  @override
  void initState() {
    if (kDebugMode) {
      print(widget.name);
      print(widget.username);
    }
    super.initState();
  }

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
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness:
                Brightness.dark, // dark text for status bar
            statusBarColor: Colors.white));

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Palette.primaryColor,
          centerTitle: true,
          title: const Text(
            'Settings',
            style: TextStyle(
              fontFamily: "Prompt_SemiBold",
              fontWeight: FontWeight.w600,
              fontSize: 22,
              color: Palette.colorLight,
            ),
          ),
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: Palette.colorLight,
        body: SizedBox(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile
                      const SizedBox(
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
                                    Get.to(
                                        EditProfile(
                                          name: widget.name,
                                          username:
                                              widget.username!.substring(1),
                                          whatsapp: widget.whatsapp,
                                        ),
                                        transition:
                                            Transition.rightToLeftWithFade);
                                  }),
                              ItemSettings(
                                  settings: 'Share profile',
                                  Pop: () {
                                    if (kDebugMode) {
                                      print('object');
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      // Settings
                      const SizedBox(
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
