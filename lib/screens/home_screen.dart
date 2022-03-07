import 'dart:async';
import 'dart:io';

import 'package:bazar/Services/service_video.dart';
import 'package:bazar/widgets/Test3.dart';
import 'package:bazar/widgets/test.dart';
import 'package:bazar/config/palette.dart';
import 'package:bazar/screens/otp/VideoWidget.dart';
import 'package:bazar/widgets/Test2.dart';
import 'package:bazar/widgets/button.dart';
import 'package:bazar/widgets/loading_card.dart';
import 'package:bazar/widgets/testFire.dart';
import 'package:bazar/widgets/testProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../widgets/widgets.dart';
import 'package:getwidget/getwidget.dart';
import 'package:video_player/video_player.dart';
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
  final feedViewModel = GetIt.instance<FeedViewModel>();
  // final VideoService videoControlle = Get.put(VideoService());
  //final VideoController videoController = Get.put(VideoController());
  bool CarouselShow = false;
  //late VideoPlayerController _controller1;

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
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 40, 8, 0),
          child: Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(30),
                // When the user taps the button, show a snackbar.
                onTap: () {},
                child: BadgeButton(
                  iconImage: 'assets/user.svg',
                  color: Palette.iconColor,
                  //  iconSize: 30.0,
                  //onPressed: () {},
                ),
              ),
              Button(
                  iconImage: 'assets/fireShow.svg',
                  // iconSize: 30,
                  onPressed: () {}),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                ),
                //   color: Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Row(
                      children: [
                        Text(
                          '2,000',
                          style: TextStyle(
                            fontFamily: "Prompt_Regular",
                            fontWeight: FontWeight.w600,
                            color: Palette.colorText,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'FCFA',
                          style: TextStyle(
                            fontFamily: "Prompt_Regular",
                            fontWeight: FontWeight.w600,
                            color: Palette.secondColor,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Expanded(
          child: Stack(
            children: [
              //  CarouselShow ? LoadingScreen() : TestFire(),
              //Test()
            ],
          ),
        ),
        //  Expanded(child: Test()),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 8, 20),
          child: Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GFAvatar(
                    backgroundImage: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/basic-aede4.appspot.com/o/cabraule.jpg?alt=media&token=d43ea864-6f86-4b6f-b2cd-385ffb65b7b5"),
                    child: Text('l'),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lelouche',
                        style: TextStyle(
                          fontFamily: "Prompt_Medium",
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Palette.colorText,
                        ),
                      ),
                      Text(
                        '@amsted',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Prompt_Medium",
                          color: Palette.secondColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              SizedBox(
                height: 45,
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Palette.primaryColor,
                  disabledColor: Palette.disableButton,
                  disabledTextColor: Palette.colorLight,
                  child: Text(
                    "Buy Now",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Prompt_Regular',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {},
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // VIDEO CAERD

}
