import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import '../../TestFlutter/feed_screen.dart';
// import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final locator = GetIt.instance;

  // ignore: non_constant_identifier_names
  bool CarouselShow = false;

  @override
  void initState() {
    if (kDebugMode) {
      print('leleouche');
    }
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark, // dark text for status bar
          statusBarColor: Colors.transparent));
    }
    super.initState();
    Timer(const Duration(seconds: 4), () {
      CarouselShow = true;
    });
    CarouselShow = false;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark, // dark text for status bar
          statusBarColor: Colors.transparent));
    }
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                color: Colors.black,
              ),
              const FeedScreen(),
              // TestFire(),
              //TestProvider(),
            ],
          ),
        ),
      ],
    );
  }

  // VIDEO CAERD

}
