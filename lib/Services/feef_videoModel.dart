// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import '../data/video.dart';

class FeedViewModel extends BaseViewModel {
  //VideoPlayerController? controller;
  List<Video> videos = [];
  int prevVideo = 0;
  int actualScreen = 0;

  FeedViewModel() {
    load();
    notifyListeners();
  }

  void load() async {
    videos = await getVideoList();
    await videos[0].loadController();
    videos[0].controller!.play();
    // print(videos.length);
    notifyListeners();
  }

  Future<List<Video>> getVideoList() async {
    var videoList = <Video>[];
    var videos = (await FirebaseFirestore.instance.collection('Videos').get());

    for (var element in videos.docs) {
      Video video = Video.fromJson(element.data());
      videoList.add(video);
    }
    return videoList;
    // ignore: dead_code
    notifyListeners();
  }

  changeVideo(index) async {
    if (videos[prevVideo].controller != null) {
      videos[prevVideo].controller!.pause();
    }

    if (videos[index].controller == null) {
      await videos[index].loadController();
    }
    videos[index].controller!.play();
    prevVideo = index;
    if (prevVideo + 1 < videos.length) {
      await videos[prevVideo + 1].loadController();
    }
    notifyListeners();

    if (kDebugMode) {
      print(index);
    }
  }

  void loadVideo(int index) async {
    if (videos.length > index) {
      await videos[index].loadController();
      videos[index].controller?.play();

      notifyListeners();
    }
  }

  void setActualScreen(index) {
    actualScreen = index;
    if (index == 0) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    }
    notifyListeners();
  }
}
