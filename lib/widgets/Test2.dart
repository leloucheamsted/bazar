import 'package:bazar/Services/feef_videoModel.dart';
import 'package:bazar/Services/fiel_model_fire.dart';
import 'package:bazar/Services/video_controller.dart';
import 'package:bazar/screens/otp/VideoWidget.dart';
import 'package:bazar/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../data/video.dart';

class Test2 extends StatefulWidget {
  const Test2({Key? key}) : super(key: key);
  @override
  _Test2State createState() => _Test2State();
}

class _Test2State extends State<Test2> {
//   TestFire({Key? key}) : super(key: key);
  final locator = GetIt.instance;
  final feedViewModel = GetIt.instance<FeedViewModel>();
  @override
  void initState() {
    feedViewModel.loadVideo(0);
    feedViewModel.loadVideo(1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FeedViewModel>.reactive(
        disposeViewModel: false,
        builder: (context, model, child) => videoScreen(),
        viewModelBuilder: () => feedViewModel);
  }

  Widget videoScreen() {
    // final size = MediaQuery.of(context).size;
    return CarouselSlider.builder(
      itemCount: feedViewModel.videoSource?.listVideos.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
        itemIndex = itemIndex % (feedViewModel.videoSource!.listVideos.length);
        return videoCard(feedViewModel.videoSource!.listVideos[itemIndex]);
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
          index = index % (feedViewModel.videoSource!.listVideos.length);
          feedViewModel.changeVideo(index);
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

  @override
  void dispose() {
    feedViewModel.controller?.dispose();
    super.dispose();
  }
}
