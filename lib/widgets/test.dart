import 'package:bazar/Services/feef_videoModel.dart';
import 'package:bazar/Services/video_controller.dart';
import 'package:bazar/screens/otp/VideoWidget.dart';
import 'package:bazar/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../data/video.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  // Test({Key? key}) : super(key: key);
  final locator = GetIt.instance;
  final feedViewModel = GetIt.instance<FeedViewModel>();
  late int prevVideo = 0;
  @override
  void initState() {
    feedViewModel.loadVideo(0);
    feedViewModel.loadVideo(1);
    setState(() {
      prevVideo;
    });
    super.initState();
  }

  final VideoController videoController = Get.put(VideoController());
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FeedViewModel>.reactive(
        disposeViewModel: false,
        builder: (context, model, child) => videoScreen(),
        viewModelBuilder: () => feedViewModel);
  }

  Widget videoScreen() {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Obx(() {
          return Stack(
            children: [
              videoController.videoList == null
                  ? Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.grey,
                              Colors.white,

                              Colors.white,
                              Colors.grey,
                              //add more colors for gradient
                            ],
                            begin: Alignment
                                .topCenter, //begin of the gradient color
                            end: Alignment
                                .bottomCenter, //end of the gradient color
                            stops: [
                              0,
                              0.2,
                              0.5,
                              0.8
                            ] //stops for individual color
                            //set the stops number equal to numbers of color
                            ),
                      ),
                    )
                  : CarouselSlider.builder(
                      itemCount: videoController.videoList.length,
                      itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) {
                        itemIndex =
                            itemIndex % (videoController.videoList.length);
                        return videoController.videoList != null
                            ? VideoPlayerItem(
                                videoUrl:
                                    videoController.videoList[itemIndex].url)
                            : Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Colors.grey,
                                        Colors.white,

                                        Colors.white,
                                        Colors.grey,
                                        //add more colors for gradient
                                      ],
                                      begin: Alignment
                                          .topCenter, //begin of the gradient color
                                      end: Alignment
                                          .bottomCenter, //end of the gradient color
                                      stops: [
                                        0,
                                        0.2,
                                        0.5,
                                        0.8
                                      ] //stops for individual color
                                      //set the stops number equal to numbers of color
                                      ),
                                ),
                              );
                      },
                      options: CarouselOptions(
                        viewportFraction: 1,
                        initialPage: 0,
                        height: size.height,
                        enableInfiniteScroll: false,
                        reverse: false,
                        autoPlay: false,
                        enlargeCenterPage: true,
                        //  onPageChanged: callbackFunction,
                        scrollDirection: Axis.vertical,
                        onPageChanged: (index, reason) {
                          index = index % (videoController.videoList.length);
                          changeVideo(index);
                          //  model.changeVideo(index);
                        },
                      ),
                    ),
            ],
          );
        }),
      ],
    );
  }

  @override
  void dispose() {
    feedViewModel.controller?.dispose();
    super.dispose();
  }

  void changeVideo(index) async {
    if (videoController.videoList[index].controller == null) {
      await videoController.videoList[index].loadController();
    }
    videoController.videoList[index].controller!.play();
    //videoSource.listVideos[prevVideo].controller.removeListener(() {});

    if (videoController.videoList[prevVideo].controller != null)
      videoController.videoList[prevVideo].controller!.pause();

    setState(() {
      prevVideo = index;
    });
  }

  Widget videoCard(Video video) {
    return Stack(
      children: [
        video.controller != null
            ? GestureDetector(
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
                  ),
                )),
              )
            : Container(
                color: Colors.black,
                child: Center(
                  child: Text("Loading"),
                ),
              ),
      ],
    );
  }
}
