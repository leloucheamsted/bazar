import 'package:bazar/Services/service_fire.dart';
import 'package:bazar/Services/service_video.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
//import 'package:video_player/video_player.dart';
import 'package:cached_video_player/cached_video_player.dart';

class FielModelFire extends BaseViewModel {
  VideoPlayerController? controller;

  ServiceFire? videoSource;

  int prevVideo = 0;

  int actualScreen = 0;
  FielModelFire() {
    videoSource = ServiceFire();
    loadfirst;

    //videoSource!.videoList[0].loadController();
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

  loadVideo(int index) async {
    if (videoSource!.videoList.length > index) {
      await videoSource!.videoList[index].loadController();
      videoSource!.videoList[index].controller?.play();
      print('index');
      notifyListeners();
    }
  }

  loadfirst(String url) async {
    controller = VideoPlayerController.network(url);
    await controller
        ?.initialize()
        .then((value) => debugPrint('Controller Initialiszed!!'));
    controller?.setLooping(true);
  }
}
