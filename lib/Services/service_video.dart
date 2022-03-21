import 'package:bazar/constants.dart';
import 'package:bazar/data/demo_data.dart';
import 'package:bazar/data/video.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class VideoService {
  List<Video> listVideos = <Video>[];
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  VideoService() {
    load();
  }
  void load() async {
    listVideos = await getVideoList();
    // listVideos[0].loadController();
  }

  Future<List<Video>> getVideoList() async {
    var data = await FirebaseFirestore.instance.collection("Videos").get();

    var videoList = <Video>[];
    var videos;

    if (data.docs.length == 0) {
      await addDemoData();
      videos = (await FirebaseFirestore.instance.collection("Videos").get());
    } else {
      videos = data;
    }

    videos.docs.forEach((element) {
      Video video = Video.fromJson(element.data());
      video.loadController();
      videoList.add(video);
    });

    return videoList;
  }

  Future<List<String>> getCategories() async {
    List<String> list = [];
    await FirebaseFirestore.instance
        .collection('Categories_Produits')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        list = doc["List"];
      });
    });
    return list;
  }

  Future<Null> addDemoData() async {
    for (var video in data) {
      await FirebaseFirestore.instance.collection("Videos").add(video);
    }
  }
}
