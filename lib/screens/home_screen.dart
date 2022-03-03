import 'package:bazar/config/palette.dart';
import 'package:bazar/widgets/button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import '../../widgets/widgets.dart';
import 'package:getwidget/getwidget.dart';
import 'package:video_player/video_player.dart';
import 'package:measured_size/measured_size.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../Services/feef_videoModel.dart';
import '../data/video.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final locator = GetIt.instance;
  final feedViewModel = GetIt.instance<FeedViewModel>();
  //late VideoPlayerController _controller1;

  @override
  void initState() {
    feedViewModel.loadVideo(0);
    feedViewModel.loadVideo(1);
    print('leleouche');
    // TODO: implement initState
    super.initState();
    // _controller1 = VideoPlayerController.network(
    //     'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {
    //       _controller1.play();
    //     });
    //   });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FeedViewModel>.reactive(
        disposeViewModel: false,
        builder: (context, model, child) => videoScreen(),
        viewModelBuilder: () => feedViewModel);
  }

  Widget videoScreen() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 40, 8, 0),
          child: Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(30),
                // When the user taps the button, show a snackbar.
                onTap: () {},
                child: BadgeButton(
                  iconImage: 'assets/user.svg',
                  color: Palette.iconColor,
                  //  iconSize: 30.0,
                  //onPressed: () {},
                ),
              ),
              Button(
                  iconImage: 'assets/fireShow.svg',
                  // iconSize: 30,
                  onPressed: () {}),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                ),
                //   color: Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Row(
                      children: [
                        Text(
                          '2,000',
                          style: TextStyle(
                            fontFamily: "Prompt_Regular",
                            fontWeight: FontWeight.w600,
                            color: Palette.colorText,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'FCFA',
                          style: TextStyle(
                            fontFamily: "Prompt_Regular",
                            fontWeight: FontWeight.w600,
                            color: Palette.secondColor,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Stack(
              children: [
                PageView.builder(
                  controller: PageController(
                    initialPage: 0,
                    viewportFraction: 1,
                  ),
                  itemCount: feedViewModel.videoSource?.listVideos.length,
                  onPageChanged: (index) {
                    index =
                        index % (feedViewModel.videoSource!.listVideos.length);
                    feedViewModel.changeVideo(index);
                  },
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    var _scale = index == index ? 1.0 : 0.8;
                    return TweenAnimationBuilder(
                      tween: Tween(begin: _scale, end: _scale),
                      curve: Curves.ease,
                      duration: const Duration(milliseconds: 350),
                      child: videoCard(
                          feedViewModel.videoSource!.listVideos[index]),
                      builder: (context, value, child) {
                        //return
                        return Transform.scale(
                          scale: double.parse(value.toString()),
                          child: child,
                        );
                      },
                    );

                    index =
                        index % (feedViewModel.videoSource!.listVideos.length);
                    // return videoCard(
                    //     feedViewModel.videoSource!.listVideos[index]);
                  },
                ),
              ],
            ),
            // child: CarouselSlider.builder(
            //   // items: items,
            //   itemCount: feedViewModel.videoSource?.listVideos.length,

            //   itemBuilder:
            //       (BuildContext context, int itemIndex, int pageViewIndex) =>
            //           (videoCard(
            //               feedViewModel.videoSource!.listVideos[pageViewIndex])

            //           //  },
            //           ),

            //   options: CarouselOptions(
            //     //height: 400,
            //     // height: h,
            //     aspectRatio: 2.0,
            //     viewportFraction: 1,
            //     enlargeCenterPage: true,
            //     initialPage: 0,
            //     scrollDirection: Axis.vertical,
            //     enableInfiniteScroll: false,
            //     reverse: false,
            //     // autoPlay: true,
            //   ),
            // ),
          ),

          //  ClipRRect( child: _controller.value.isInitialized
          //     ? AspectRatio(
          //         aspectRatio: _controller.value.aspectRatio,
          //         child: VideoPlayer(_controller),
          //       )
          //     : Container(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 8, 20),
          child: Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GFAvatar(
                    backgroundImage: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/basic-aede4.appspot.com/o/cabraule.jpg?alt=media&token=d43ea864-6f86-4b6f-b2cd-385ffb65b7b5"),
                    child: Text('l'),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lelouche',
                        style: TextStyle(
                          fontFamily: "Prompt_Medium",
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Palette.colorText,
                        ),
                      ),
                      Text(
                        '@amsted',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Prompt_Medium",
                          color: Palette.secondColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              SizedBox(
                height: 45,
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Palette.primaryColor,
                  disabledColor: Palette.disableButton,
                  disabledTextColor: Palette.colorLight,
                  child: Text(
                    "Buy Now",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Prompt_Regular',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {},
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // VIDEO CAERD

  Widget videoCard(Video video) {
    return video.controller != null
        ? VideoPlayer(video.controller!)
        // return ClipRRect(
        //   borderRadius: BorderRadius.circular(20),
        //   child: Stack(
        //     children: [
        //       video.controller != null
        //           ? GestureDetector(
        //               onTap: () {
        //                 if (video.controller!.value.isPlaying) {
        //                   video.controller?.pause();
        //                 } else {
        //                   video.controller?.play();
        //                 }
        //               },
        //               child: SizedBox.expand(
        //                   child: FittedBox(
        //                 fit: BoxFit.cover,
        //                 child: SizedBox(
        //                   width: video.controller?.value.size.width ?? 0,
        //                   height: video.controller?.value.size.height ?? 0,
        //                   child: VideoPlayer(video.controller!),
        //                 ),
        //               )),
        //             )
        //VideoPlayer(video.controller!)
        : Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            height: 700,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.grey,
                    Colors.white,

                    Colors.white,
                    Colors.grey,
                    //add more colors for gradient
                  ],
                  begin: Alignment.topCenter, //begin of the gradient color
                  end: Alignment.bottomCenter, //end of the gradient color
                  stops: [0, 0.2, 0.5, 0.8] //stops for individual color
                  //set the stops number equal to numbers of color
                  ),
            ),
            //),
            //  ],
            //  ),
          );
    // Column(
    //   mainAxisAlignment: MainAxisAlignment.end,
    //   children: <Widget>[
    //     Row(
    //       mainAxisSize: MainAxisSize.max,
    //       crossAxisAlignment: CrossAxisAlignment.end,
    //       children: <Widget>[
    //         VideoDescription(video.user, video.videoTitle, video.songName),
    //         ActionsToolbar(video.likes, video.comments,
    //             "https://www.andersonsobelcosmetic.com/wp-content/uploads/2018/09/chin-implant-vs-fillers-best-for-improving-profile-bellevue-washington-chin-surgery.jpg"),
    //       ],
    //     ),
  }

  @override
  void dispose() {
    feedViewModel.controller?.dispose();
    super.dispose();
  }
}
