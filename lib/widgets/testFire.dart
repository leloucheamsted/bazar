// ignore_for_file: file_names
import 'package:bazar/Services/fiel_model_fire.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';
//import 'package:video_player/video_player.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../data/video.dart';

class TestFire extends StatefulWidget {
  const TestFire({Key? key}) : super(key: key);
  @override
  _TestFireState createState() => _TestFireState();
}

class _TestFireState extends State<TestFire> {
  final locator = GetIt.instance;
  final feedViewModel = GetIt.instance<FielModelFire>();

  @override
  void initState() {
    feedViewModel.loadVideo(0);
    feedViewModel.loadVideo(1);
    feedViewModel.setInitialised(true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FielModelFire>.reactive(
      disposeViewModel: false,
      builder: (context, model, child) => videoScreen(),
      viewModelBuilder: () => feedViewModel,
    );
  }

  Widget videoScreen() {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: feedViewModel.videoSource!.listVideos.length,
          itemBuilder:
              (BuildContext context, int itemIndex, int pageViewIndex) {
            itemIndex =
                itemIndex % (feedViewModel.videoSource!.listVideos.length);
            return videoCard(feedViewModel.videoSource!.listVideos[itemIndex]);
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
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
      ],
    );
  }

  @override
  void dispose() {
    //feedViewModel.con?.dispose();
    super.dispose();
  }
}
