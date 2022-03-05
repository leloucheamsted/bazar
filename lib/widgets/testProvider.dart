import 'package:bazar/Services/providerModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';

import '../data/video.dart';

class ProviderTest extends StatefulWidget {
  const ProviderTest({Key? key}) : super(key: key);

  @override
  State<ProviderTest> createState() => _ProviderTestState();
}

class _ProviderTestState extends State<ProviderTest> {
  @override
  Widget build(BuildContext context) {
    VideoModel videoModel = context.watch<VideoModel>();

    @override
    void initState() {
      videoModel.loadVideo(0);
      videoModel.loadVideo(1);

      super.initState();
    }

    return _ui(videoModel);
  }

  _ui(VideoModel videoModel) {
    return CarouselSlider.builder(
      itemCount: videoModel.videoSource?.videoList.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
        itemIndex = itemIndex % (videoModel.videoSource!.videoList.length);
        return videoCard(videoModel.videoSource!.videoList[itemIndex]);
      },
      options: CarouselOptions(
        viewportFraction: 1,
        initialPage: 0,
        // height: size.height,
        enableInfiniteScroll: false,
        reverse: false,
        autoPlay: false,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          index = index % (videoModel.videoSource!.videoList.length);
          videoModel.changeVideo(index);
        },
        //  onPageChanged: callbackFunction,
        scrollDirection: Axis.vertical,
      ),
    );
    //     ],
    //   ),
    // );
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
}
