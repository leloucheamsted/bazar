// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:bazar/Services/feef_videoModel.dart';
import 'package:bazar/Services/user.dart';
import 'package:bazar/TestFlutter/feed_screen.dart';
import 'package:bazar/screens/create_post/camera_screen.dart';
import 'package:bazar/screens/otp/otp1.dart';
import 'package:bazar/screens/profile/profile_screen.dart';
import 'package:bazar/screens/search_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/palette.dart';
import '../../config/palette.dart';
import 'orders/orders_screen.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({Key? key}) : super(key: key);
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  late int c;
  int currentTab = 0; // to keep track of active tab index
  final List<Widget> screens = [
    const FeedScreen(),
    const SearchScreen(),
    OrdersScreen(
      onClicked: () {
        if (kDebugMode) {
          print("show");
        }
      },
    ),
    const ProfileScreen(isUser: true),
  ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const FeedScreen(); // Our first view in viewport
  FeedViewModel feedViewModel = FeedViewModel();
  //  Verifier si c'est la premiere fois que l'utilisateur install l'application
  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    final int counter = (prefs.getInt('_counter') ?? 0);

    setState(() {});
    if (counter < 1) {
      WelcomePopup(context);
    }
  }

  selecter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    c = prefs.getInt('_counter') ?? 0;
    if (c == 0) {
      //  await prefs.setInt('_counter', 1);
      //return FirstPage();
    } else {
      //return SecondPage();
    }
  }

  @override
  void initState() {
    //  feedViewModel.getNumber();
    super.initState();
    selecter();

    Timer(const Duration(seconds: 20), () {
      _incrementCounter();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark, // dark text for status bar
          statusBarColor: Colors.white));
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: currentTab,
        children: screens,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          decoration: const BoxDecoration(),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen =
                              const FeedScreen(); // if user taps on this dashboard tab will be active
                          currentTab = 0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ImageIcon(
                            const AssetImage('assets/nav_icons/home.png'),
                            size: 20.0,
                            color: currentTab == 0
                                ? Palette.primaryColor
                                : Palette.colorgray,
                          ),
                          const Divider(
                            height: 10.0,
                          ),
                          Text(
                            'Home',
                            style: TextStyle(
                              fontFamily: 'Prompt_Medium',
                              color: currentTab == 0
                                  ? Palette.primaryColor
                                  : Palette.colorgray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String index = prefs.getString('counter') ?? "0";
                        if (kDebugMode) {
                          print('object');
                          print(index);
                        }
                        // int c = await counter();
                        if (index != "1") {
                          WelcomePopup(context);
                        } else {
                          try {
                            await availableCameras()
                                .then((value) => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CameraScreen(
                                          cameras: value,
                                        ),
                                      ),
                                    ));
                          } catch (e) {
                            if (kDebugMode) {
                              print(e);
                            }
                          }
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/nav_icons/add.svg',
                            height: 20,
                            width: 20,
                            color: currentTab == 1
                                ? Palette.primaryColor
                                : Palette.colorgray,
                          ),
                          const Divider(
                            height: 10.0,
                          ),
                          Text(
                            'Sell',
                            style: TextStyle(
                              fontFamily: 'Prompt_Medium',
                              color: currentTab == 1
                                  ? Palette.primaryColor
                                  : Palette.colorgray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // MaterialButton(
                    //   minWidth: 40,
                    //   onPressed: () async {
                    //    // int c = await counter();
                    //     if (c < 1) {
                    //       WelcomePopup(context);
                    //     } else {
                    //       setState(() {
                    //         currentScreen = new OrdersScreen(
                    //           onClicked: () {
                    //             print("clicked");
                    //           },
                    //         ); // if user taps on this dashboard tab will be active
                    //         currentTab = 2;
                    //       });
                    //     }
                    //   },
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: <Widget>[
                    //       ImageIcon(
                    //         AssetImage('assets/nav_icons/orders.png'),
                    //         size: 20.0,
                    //         color: currentTab == 2
                    //             ? Palette.primaryColor
                    //             : Palette.colorgray,
                    //       ),
                    //       Divider(
                    //         height: 10.0,
                    //       ),
                    //       Text(
                    //         'Operations',
                    //         style: TextStyle(
                    //           fontFamily: 'Prompt_Medium',
                    //           color: currentTab == 2
                    //               ? Palette.primaryColor
                    //               : Palette.colorgray,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    //
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () async {
                        Provider.of<User>(context, listen: false)
                            .getcurentuser();
                        // context.read<User>().getcurentuser();
                        if (kDebugMode) {
                          print("navScreen.dart / username pf user" +
                              context.read<User>().username);
                        }
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String index = prefs.getString('counter') ?? "0";
                        if (kDebugMode) {
                          //print('object');
                          print(
                              "navscree.dart / index of statut first load app" +
                                  index);
                          print(context.read<User>().username);
                        }
                        // feedViewModel!.getNumber();
                        // int c = await counter();
                        if (index != "1") {
                          WelcomePopup(context);
                        } else {
                          setState(() {
                            currentScreen = const ProfileScreen(
                              isUser: true,
                            ); // if user taps on this dashboard tab will be active
                            currentTab = 3;
                          });
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ImageIcon(
                            const AssetImage('assets/nav_icons/profile.png'),
                            size: 20.0,
                            color: currentTab == 3
                                ? Palette.primaryColor
                                : Palette.colorgray,
                          ),
                          const Divider(
                            height: 10.0,
                          ),
                          Text(
                            'Profile',
                            style: TextStyle(
                              fontFamily: 'Prompt_Medium',
                              color: currentTab == 3
                                  ? Palette.primaryColor
                                  : Palette.colorgray,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  Popup welcome
  // ignore: non_constant_identifier_names
  void WelcomePopup(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return IntrinsicHeight(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: Palette.colorLight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Welcome to mokolo',
                        style: TextStyle(
                          fontFamily: 'Prompt_Bold',
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      '1- Swipe up and down to discover new articles.',
                      style: TextStyle(
                        fontFamily: 'Prompt_Regular',
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    '2- Tap the Buy now button to place your order.',
                    style: TextStyle(
                      fontFamily: 'Prompt_Regular',
                      fontSize: 15.0,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Text(
                      '3- Enter your shipping details and pay.',
                      style: TextStyle(
                        fontFamily: 'Prompt_Regular',
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  const Spacer(
                    flex: 3,
                  ),
                  SizedBox(
                    height: 40.0,
                    width: double.infinity,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Palette.primaryColor,
                      child: const Text(
                        "Start",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Prompt_Medium',
                        ),
                      ),
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EnterNumberScreen())).then((value) {
                          setState(() {});

                          // Get.to(EnterNumberScreen(),
                          //     transition: Transition.rightToLeftWithFade);
                          // MaterialPageRoute(
                          //     builder: (context) => EnterNumberScreen());
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  //  Popup Search
  // ignore: non_constant_identifier_names
  void SearchPopup(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Palette.colorgray,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const TextField(
                            autofocus: true,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Search for an item …',
                              hintStyle: TextStyle(
                                fontFamily: "Prompt_Regular",
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color.fromRGBO(117, 117, 117, 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                        child: InkWell(
                          onTap: () async {
                            Navigator.of(context).pop();
                            // Allez a l'onglet 2
                            currentScreen = const SearchScreen();
                            currentTab = 1;
                            FocusScope.of(context).unfocus();
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SvgPicture.asset('assets/search.svg')),
                        ),
                      ),
                      // onPressed: () {},
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        });
  }
}
