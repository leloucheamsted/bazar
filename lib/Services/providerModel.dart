import 'package:bazar/Services/service_fire.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoModel extends ChangeNotifier {
  VideoPlayerController? controller;

  ServiceFire? videoSource;

  int prevVideo = 0;

  int actualScreen = 0;

  FielModelFire() {
    videoSource = ServiceFire();
  }

  changeVideo(index) async {
    if (videoSource!.videoList[index].controller == null) {
      await videoSource!.videoList[index].loadController();
    }
    videoSource!.videoList[index].controller!.play();
    //videoSource.listVideos[prevVideo].controller.removeListener(() {});

    if (videoSource!.videoList[prevVideo].controller != null)
      videoSource!.videoList[prevVideo].controller!.pause();

    prevVideo = index;
    notifyListeners();

    // print(index);
  }

  void loadVideo(int index) async {
    if (videoSource!.videoList.length > index) {
      var i = videoSource!.videoList[index];
      i.controller = VideoPlayerController.network(i.url);
      await controller
          ?.initialize()
          .then((value) => debugPrint('Controller Initialiszed!!'));
      controller?.setLooping(true);
      ;
      videoSource!.videoList[index].controller?.play();
      print('index');
      notifyListeners();
    }
  }
}
