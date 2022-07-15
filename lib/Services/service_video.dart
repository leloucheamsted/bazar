import 'package:bazar/data/demo_data.dart';
import 'package:bazar/data/video.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class VideoService {
  List<Video> listVideos = <Video>[];
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  VideoService() {
    load();
  }
  void load() async {
    listVideos = await getVideoList();
  }

  Future<List<Video>> getVideoList() async {
    var data = await FirebaseFirestore.instance.collection('Videos').get();
    var videoList = <Video>[];
    QuerySnapshot<Map<String, dynamic>> videos;

    if (data.docs.isEmpty) {
      await addDemoData();
      videos = (await FirebaseFirestore.instance.collection('Videos').get());
    } else {
      videos = data;
    }

    // ignore: avoid_function_literals_in_foreach_calls
    videos.docs.forEach((element) {
      Video video = Video.fromJson(element.data());
      video.loadController();
      videoList.add(video);
    });

    return videoList;
  }

  Future<void> addDemoData() async {
    for (var video in data) {
      await FirebaseFirestore.instance.collection("Videos").add(video);
    }
  }
}
