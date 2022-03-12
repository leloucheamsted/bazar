import 'package:bazar/Services/feef_videoModel.dart';
import 'package:bazar/Services/fiel_model_fire.dart';
import 'package:bazar/Services/video_controller.dart';
import 'package:bazar/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../data/video.dart';

class TestFire extends StatefulWidget {
  const TestFire({Key? key}) : super(key: key);
  @override
  _TestFireState createState() => _TestFireState();
}

class _TestFireState extends State<TestFire> {
//   TestFire({Key? key}) : super(key: key);
  final locator = GetIt.instance;
  final fielModelFire = GetIt.instance<FielModelFire>();

  @override
  void initState() {
    fielModelFire.loadVideo(0);
    fielModelFire.loadVideo(1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FielModelFire>.reactive(
        disposeViewModel: false,
        onModelReady: (viewModel) => viewModel.loadVideo(0),
        builder: (context, model, child) => videoScreen(),
        viewModelBuilder: () => FielModelFire());
  }

  Widget videoScreen() {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            return Stack(
              children: [
                Container(
                  height: size.height,
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
                        begin:
                            Alignment.topCenter, //begin of the gradient color
                        end: Alignment.bottomCenter, //end of the gradient color
                        stops: [0, 0.2, 0.5, 0.8] //stops for individual color
                        //set the stops number equal to numbers of color
                        ),
                  ),
                ),
                CarouselSlider.builder(
                  itemCount: fielModelFire.videoSource?.videoList.length,
                  itemBuilder:
                      (BuildContext context, int itemIndex, int pageViewIndex) {
                    itemIndex = itemIndex %
                        (fielModelFire.videoSource!.videoList.length);
                    return videoCard(
                        fielModelFire.videoSource!.videoList[itemIndex]);
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
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
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
                  child: Text(
                    video.nom,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
      ],
    );
  }

  @override
  void dispose() {
    fielModelFire.controller?.dispose();
    super.dispose();
  }
}
