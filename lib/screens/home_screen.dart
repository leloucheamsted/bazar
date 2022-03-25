import 'dart:async';
import 'dart:io';

import 'package:bazar/Services/service_video.dart';
import 'package:bazar/config/palette.dart';
import 'package:bazar/widgets/button.dart';
import 'package:bazar/widgets/loading_card.dart';
import 'package:bazar/widgets/testFire.dart';
import 'package:bazar/widgets/testProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../widgets/widgets.dart';
import 'package:getwidget/getwidget.dart';
import '../../TestFlutter/feed_screen.dart';
// import 'package:video_player/video_player.dart';
import 'package:measured_size/measured_size.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../Services/feef_videoModel.dart';
import '../Services/video_controller.dart';
import '../data/video.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final locator = GetIt.instance;

  bool CarouselShow = false;

  @override
  void initState() {
    print('leleouche');
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark, // dark text for status bar
          statusBarColor: Colors.transparent));
    }
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 4), () {
      CarouselShow = true;
    });
    CarouselShow = false;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
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
              FeedScreen(),
            ],
          ),
        ),
      ],
    );
  }

  // VIDEO CAERD

}
