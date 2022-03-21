import 'dart:ffi';

import 'package:bazar/Services/feef_videoModel.dart';
import 'package:bazar/Services/fiel_model_fire.dart';
import 'package:bazar/Services/providerModel.dart';
import 'package:bazar/Services/service_fire.dart';
import 'package:bazar/Services/service_video.dart';
import 'package:bazar/Services/video_controller.dart';
import 'package:bazar/config/palette.dart';
import 'package:bazar/widgets/button.dart';
import 'package:bazar/widgets/loading_card.dart';
import 'package:bazar/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:cached_video_player/cached_video_player.dart';

// import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../data/video.dart';

class TestProvider extends StatefulWidget {
  const TestProvider({Key? key}) : super(key: key);
  @override
  _TestProviderState createState() => _TestProviderState();
}

late VideoController videoController = Get.put(VideoController());

class _TestProviderState extends State<TestProvider>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
    }

    return _ui();
  }

  Widget _ui() {
    final size = MediaQuery.of(context).size.height;
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Palette.colorLight,
        body: Obx(
          (() {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 0, 2, 0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(1.0, 0, 0, 0),
                          child: Text(
                            ' Explore',
                            style: TextStyle(
                              fontFamily: "Prompt_SemiBold",
                              fontWeight: FontWeight.w600,
                              color: Palette.colorText,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        Spacer(),
                        Button(
                            iconImage: 'assets/userShow.svg',
                            //iconSize: 30,
                            onPressed: () {}),
                        Button(
                            iconImage: 'assets/chrono.svg',
                            // iconSize: 30,
                            onPressed: () {}),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CarouselSlider.builder(
                      itemCount: videoController.videoList.length,
                      itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) {
                        final data = videoController.videoList[itemIndex];
                        //  fielViewModel.loadVideo(0);
                        itemIndex =
                            itemIndex % (videoController.videoList.length);
                        return VideoPlayerItem(element: data);
                      },
                      options: CarouselOptions(
                        viewportFraction: 1,
                        initialPage: 0,
                        height: size,
                        enableInfiniteScroll: false,
                        reverse: false,
                        autoPlay: false,
                        enlargeCenterPage: true,
                        // onPageChanged: (index, reason) {
                        //   index = index % (fielViewModel.videoSource!.videoList.length);
                        //   fielViewModel.changeVideo(index);
                        // },
                        scrollDirection: Axis.vertical,
                      ),
                    ),
                    // ]),
                  ),
                ],
              ),
            );
          }),
        ));
  }

  Widget videoCard(Video video) {
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

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }
}
