import 'dart:ffi';

// import 'package:bazar/Services/feef_videoModel.dart';
import 'package:bazar/Services/service_fire.dart';
import 'package:bazar/Services/service_video.dart';
import 'package:bazar/Services/video_controller.dart';
import 'package:bazar/screens/otp/VideoWidget.dart';
import 'package:bazar/widgets/loading_card.dart';
import 'package:bazar/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../data/video.dart';

class Test3 extends StatefulWidget {
  const Test3({Key? key}) : super(key: key);
  @override
  _Test3State createState() => _Test3State();
}

class _Test3State extends State<Test3> {
//   TestFire({Key? key}) : super(key: key);
  //final locator = GetIt.instance;
  late FielModelFire fielViewModel = new FielModelFire();
  ServiceFire? service;
  @override
  void initState() {
    loadVideo(0);
    fielViewModel.loadVideo(0);
    service = new ServiceFire();

    // TODO: implement initState
    setState(() {});
    // service = VideoService();
    // service?.load();
    //service?.listVideos[0].loadController();
    print('Initialised...........||||||||||||.>....');
    fielViewModel.loadfirst;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadVideo(0);
    //   Function VoidCallback;
    final size = MediaQuery.of(context).size.height;
    return ViewModelBuilder<FielModelFire>.reactive(
      viewModelBuilder: () => FielModelFire(),
      initialiseSpecialViewModelsOnce: true,
      disposeViewModel: false,
      onModelReady: (fielViewModel) => fielViewModel.loadVideo(0),
      builder: (context, model, child) => Scaffold(
        body: Stack(
          children: [
            Obx(
              (() {
                fielViewModel = model;

                //  model.loadVideo(0);
                return Stack(children: [
                  CarouselSlider.builder(
                    itemCount: fielViewModel.videoSource?.videoList.length,
                    itemBuilder: (BuildContext context, int itemIndex,
                        int pageViewIndex) {
                      //  fielViewModel.loadVideo(0);
                      itemIndex = itemIndex %
                          (fielViewModel.videoSource!.videoList.length);
                      return videoCard(
                        fielViewModel.videoSource!.videoList[itemIndex],
                      );
                    },
                    options: CarouselOptions(
                      viewportFraction: 1,
                      initialPage: 0,
                      height: size,
                      enableInfiniteScroll: false,
                      reverse: false,
                      autoPlay: false,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        index = index %
                            (fielViewModel.videoSource!.videoList.length);
                        model.changeVideo(index);
                      },
                      //  onPageChanged: callbackFunction,
                      scrollDirection: Axis.vertical,
                    ),
                  ),
                ]);
              }),
            )
          ],
        ),
      ),
    );
  }

  void loadVideo(int index) async {
    if (service!.videoList.length > index) {
      await service!.videoList[index].loadController();
      service!.videoList[index].controller?.play();
      print('index');
    }
  }

  Widget videoCard(Video video) {
    //  fielViewModel.loadVideo(0);
    return video.controller != null
        ? Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  GestureDetector(
                      onTap: () {
                        if (video.controller!.value.isPlaying) {
                          video.controller?.pause();
                        } else {
                          video.controller?.play();
                        }
                      },
                      child: SizedBox.expand(
                        child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: video.controller?.value.size.width ?? 0,
                              height: video.controller?.value.size.height ?? 0,
                              child: VideoPlayer(video.controller!),
                            )),
                      ))
                ],
              ),
            ),
          )
        : LoadingScreen();
  }

  // @override
  // void dispose() {
  //   model.controller?.dispose();
  //   super.dispose();
  // }
}

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

  void loadVideo(int index) async {
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
