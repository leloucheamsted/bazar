import 'package:bazar/screens/home_screen.dart';
import 'package:bazar/screens/orders_screen.dart';
import 'package:bazar/screens/profile_screen.dart';
import 'package:bazar/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../config/palette.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({Key? key}) : super(key: key);

  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int currentTab = 0; // to keep track of active tab index
  final List<Widget> screens = [
    HomeScreen(),
    SearchScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomeScreen(); // Our first view in viewport
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: HomeScreen(),
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.transparent,
        child: ImageIcon(
          AssetImage('assets/nav_icons/add.png'),
          size: 30.0,
          color: Palette.primaryColor,
        ),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        //shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            HomeScreen(); // if user taps on this dashboard tab will be active
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
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            Scaffold(); // if user taps on this dashboard tab will be active
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ImageIcon(
                          AssetImage('assets/nav_icons/search.png'),
                          size: 20.0,
                          color: currentTab == 1
                              ? Palette.primaryColor
                              : Palette.colorgray,
                        ),
                        Divider(
                          height: 10.0,
                        ),
                        Text(
                          'Search',
                          style: TextStyle(
                            color: currentTab == 1
                                ? Palette.primaryColor
                                : Palette.colorgray,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              // Right Tab bar icons

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            Scaffold(); // if user taps on this dashboard tab will be active
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
                          'Orders',
                          style: TextStyle(
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
                            Scaffold(); // if user taps on this dashboard tab will be active
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
                            color: currentTab == 3
                                ? Palette.primaryColor
                                : Palette.colorgray,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
