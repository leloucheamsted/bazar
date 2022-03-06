import 'package:bazar/Services/service_video.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

class FeedViewModel extends BaseViewModel {
  VideoPlayerController? controller;

  VideoService? videoSource;

  int prevVideo = 0;
  int actualScreen = 0;
  FeedViewModel() {
    videoSource = VideoService();
  }

  changeVideo(index) async {
    if (videoSource!.listVideos[index].controller == null) {
      await videoSource!.listVideos[index].loadController();
    }
    videoSource!.listVideos[index].controller!.play();
    //videoSource.listVideos[prevVideo].controller.removeListener(() {});

    if (videoSource!.listVideos[prevVideo].controller != null)
      videoSource!.listVideos[prevVideo].controller!.pause();

    prevVideo = index;
    notifyListeners();

    print(index);
  }

  void loadVideo(int index) async {
    if (videoSource!.listVideos.length > index) {
      await videoSource!.listVideos[index].loadController();
      videoSource!.listVideos[index].controller?.play();
      print('index');
      notifyListeners();
    }
  }

  // void setActualScreen(index) {
  //   actualScreen = index;
  //   if (index == 0) {
  //     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  //   } else {
  //     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  //   }
  //   notifyListeners();
  // }
}
