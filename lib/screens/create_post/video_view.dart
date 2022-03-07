import 'dart:io';

import 'package:bazar/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';

class VideoViewPage extends StatefulWidget {
  const VideoViewPage({Key? key, required this.path}) : super(key: key);
  final String path;

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
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light, // dark text for status bar
          statusBarColor: Colors.transparent));
    }
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
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
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
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
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
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
                                    style: TextStyle(
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
                Container(
                    color: Palette.primaryColor,
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
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
                      ],
                    )),
              ]),
            ),
            Positioned(
              top: 30,
              child: Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: Row(
                    children: [
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
                      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                          systemNavigationBarColor: Colors.transparent,
                          systemNavigationBarIconBrightness: Brightness.dark,
                          statusBarIconBrightness:
                              Brightness.dark, // dark text for status bar
                          statusBarColor: Colors.transparent));
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
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
            Positioned(
                bottom: 4,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                  child: CircleAvatar(
                    radius: 27,
                    backgroundColor: Colors.transparent,
                    child: SvgPicture.asset(
                      'assets/next.svg',
                      height: 25,
                      width: 25,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
