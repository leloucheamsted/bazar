import 'package:bazar/constants.dart';
import 'package:bazar/data/demo_data.dart';
import 'package:bazar/data/video.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked_services/stacked_services.dart';

class ServiceFire extends GetxController {
  late Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;
  ServiceFire() {
    load();
    //videoList[0].loadController();
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _videoList.bindStream(
        firestore.collection('Videos').snapshots().map((QuerySnapshot query) {
      List<Video> retVal = [];
      for (var element in query.docs) {
        retVal.add(
          Video.fromSnap(element),
        );
      }
      return retVal;
    }));
  }

  void load() async {
    getVideoList();
    // _videoList = (await getVideoList()) as Rx<List<Video>>;
    //_videoList.value[0].loadController();
    //videoList[0].loadController();
  }

  Future getVideoList() async {
    _videoList.bindStream(
        firestore.collection('Videos').snapshots().map((QuerySnapshot query) {
      List<Video> retVal = [];
      for (var element in query.docs) {
        retVal.add(
          Video.fromSnap(element),
        );
      }
      return retVal;
    }));
  }
}
