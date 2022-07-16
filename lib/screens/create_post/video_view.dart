import 'dart:io';

import 'package:bazar/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:video_player/video_player.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'dart:math' as math;

class VideoViewPage extends StatefulWidget {
  const VideoViewPage(
      {Key? key, required this.path, required this.isCamerafront})
      : super(key: key);
  final String path;
  final bool isCamerafront;

  @override
  _VideoViewPageState createState() => _VideoViewPageState();
}

class _VideoViewPageState extends State<VideoViewPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.play();
    _controller.setLooping(true);
    _controller.setVolume(1);
    setState(() {
      volume = true;
    });
  }

  bool volume = false;
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Palette.primaryColor,
          systemNavigationBarDividerColor: Palette.primaryColor,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light, // dark text for status bar
          statusBarColor: Colors.transparent));
    }
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness:
                Brightness.dark, // dark text for status bar
            statusBarColor: Colors.transparent));
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            OverflowBox(
              maxWidth: double.infinity,
              child: _controller.value.isInitialized
                  ? VisibilityDetector(
                      key: const Key("unique key"),
                      onVisibilityChanged: (VisibilityInfo info) {
                        debugPrint(
                            "${info.visibleFraction} of my widget is visible");
                        if (info.visibleFraction == 0) {
                          _controller.dispose();
                        } else {
                          _controller.play();
                        }
                      },
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: widget.isCamerafront == false
                              ? Matrix4.rotationY(math.pi)
                              : Matrix4.rotationY(0),
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    )
                  : Container(),
            ),
            Positioned(
              bottom: 0,
              child: Column(children: [
                Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                if (volume == true) {
                                  _controller.setVolume(0);
                                  setState(() {
                                    volume = false;
                                  });
                                } else {
                                  _controller.setVolume(1);
                                  setState(() {
                                    volume = true;
                                  });
                                }
                              },
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    volume == true
                                        ? 'assets/sound_on.svg'
                                        : 'assets/sound_off.svg',
                                    height: 25,
                                    width: 25,
                                  ),
                                  Text(
                                    volume == true ? "Sound on" : "Sound off",
                                    style: const TextStyle(
                                      color: Palette.colorLight,
                                      fontSize: 18,
                                      fontFamily: "Prompt_Regular",
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Palette.primaryColor,
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (_controller.value.duration >
                                  const Duration(seconds: 15)) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  // behavior: SnackBarBehavior.floating,
                                  backgroundColor: Palette.colorError,
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.only(bottom: 0.0),
                                  duration: const Duration(seconds: 3),
                                  content: SizedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        const Text(
                                          "Your video is longer than 15 seconds",
                                          style: TextStyle(
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
                              } else {
                                _controller.pause();
                                // _controller.dispose();
                                Navigator.of(context).pushReplacementNamed(
                                    '/add_details_screen',
                                    arguments: {
                                      'path': widget.path,
                                      'isCamerefront': widget.isCamerafront
                                    });
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (builder) => AddDetailsScreen(
                                //             path: widget.path,
                                //             isCamerefront:
                                //                 widget.isCamerafront)));
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(35.0, 0, 0, 0),
                              child: Center(
                                child: Text(
                                  'Next',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontFamily: "Prompt_Regular",
                                    color: Palette.colorLight,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                          child: InkWell(
                            onTap: () async {},
                            borderRadius: BorderRadius.circular(30),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SvgPicture.asset('assets/next.svg'),
                            ),
                            // onPressed: () {},
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
            ),
            Positioned(
              top: 30,
              child: Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: Row(
                    children: const <Widget>[
                      Expanded(
                        child: Center(
                          child: Text(
                            'Preview',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontFamily: "Prompt_Regular",
                              color: Palette.colorLight,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            Positioned(
                top: 34,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                  child: GestureDetector(
                    onTap: () {
                      SystemChrome.setSystemUIOverlayStyle(
                          const SystemUiOverlayStyle(
                              systemNavigationBarColor: Colors.transparent,
                              systemNavigationBarIconBrightness:
                                  Brightness.dark,
                              statusBarIconBrightness:
                                  Brightness.dark, // dark text for status bar
                              statusBarColor: Palette.primaryColor));
                      Navigator.of(context).pop();
                    },
                    child: const CircleAvatar(
                      radius: 27,
                      backgroundColor: Colors.transparent,
                      child: Text(
                        'Delete',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontFamily: "Prompt_Regular",
                          color: Colors.red,
                          // fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   //  _controller.pause();
  //   _controller.pause();
  //   // super.dispose();
  // }
}
