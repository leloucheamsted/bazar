import 'package:bazar/TestFlutter/feed_screen.dart';
import 'package:bazar/main.dart';
import 'package:bazar/screens/create_post/camera_screen.dart';
import 'package:bazar/screens/home_screen.dart';
import 'package:bazar/screens/orders_screen.dart';
import 'package:bazar/screens/otp/otp1.dart';
import 'package:bazar/screens/profile/profile_screen.dart';
import 'package:bazar/screens/search_screen.dart';
import 'package:bazar/widgets/testFire.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/palette.dart';
import 'package:get/get.dart';
import '../../config/palette.dart';
import '../../config/palette.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({Key? key}) : super(key: key);

  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _counter;

  int currentTab = 0; // to keep track of active tab index
  final List<Widget> screens = [
    FeedScreen(),
    SearchScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = FeedScreen(); // Our first view in viewport

  //  Verifier si c'est la premiere fois que l'utilisateur install l'application
  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    final int counter = (prefs.getInt('counter') ?? 0) + 1;

    setState(() {
      _counter = prefs.setInt('counter', counter).then((bool success) {
        return counter;
      });
    });
    if (counter == 1) {
      WelcomePopup(context);
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 20), () {
      _incrementCounter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: currentTab,
        children: screens,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          decoration: BoxDecoration(),
          child: Column(
            children: [
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen =
                              FeedScreen(); // if user taps on this dashboard tab will be active
                          currentTab = 0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ImageIcon(
                            AssetImage('assets/nav_icons/home.png'),
                            size: 20.0,
                            color: currentTab == 0
                                ? Palette.primaryColor
                                : Palette.colorgray,
                          ),
                          Divider(
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
                        await availableCameras().then((value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CameraScreen(
                                  cameras: value,
                                ),
                              ),
                            ));
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
                          Divider(
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
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen =
                              OrdersScreen(); // if user taps on this dashboard tab will be active
                          currentTab = 2;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ImageIcon(
                            AssetImage('assets/nav_icons/orders.png'),
                            size: 20.0,
                            color: currentTab == 2
                                ? Palette.primaryColor
                                : Palette.colorgray,
                          ),
                          Divider(
                            height: 10.0,
                          ),
                          Text(
                            'Ordres',
                            style: TextStyle(
                              fontFamily: 'Prompt_Medium',
                              color: currentTab == 2
                                  ? Palette.primaryColor
                                  : Palette.colorgray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen =
                              ProfileScreen(); // if user taps on this dashboard tab will be active
                          currentTab = 3;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ImageIcon(
                            AssetImage('assets/nav_icons/profile.png'),
                            size: 20.0,
                            color: currentTab == 3
                                ? Palette.primaryColor
                                : Palette.colorgray,
                          ),
                          Divider(
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
  void WelcomePopup(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * .30,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              color: Palette.colorLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Welcome to basic',
                    style: TextStyle(
                      fontFamily: 'Prompt_Bold',
                      fontSize: 24.0,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Experience a new way of shopping with short videos feed. Just swipe for new items and if you found the one you like, tap buy now button to purchase it.',
                    style: TextStyle(
                      fontFamily: 'Prompt_Regular',
                      fontSize: 18.0,
                    ),
                  ),
                  Spacer(
                    flex: 3,
                  ),
                  SizedBox(
                    height: 40.0,
                    width: double.infinity,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Palette.primaryColor,
                      child: Text(
                        "Start",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Prompt_Medium',
                        ),
                      ),
                      onPressed: () async {
                        MaterialPageRoute(
                            builder: (context) => EnterNumberScreen());
                        // await availableCameras().then((value) => Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => CameraScreen(
                        //           cameras: value,
                        //         ),
                        //       ),
                        //     ));
                        //  Fermerture du popup
                        // Navigator.of(context).pop();
                        // Get.to(
                        //   CameraScreen(cameras),
                        // );
                      },
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15.0),
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
                          child: TextField(
                            autofocus: true,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: new InputDecoration.collapsed(
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
                            currentScreen = await SearchScreen();
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
                SizedBox(height: 10),
              ],
            ),
          );
        });
  }
}
