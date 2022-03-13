import 'dart:ui';

import 'package:bazar/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem>
    with AutomaticKeepAliveClientMixin {
  late VideoPlayerController videoPlayerController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        //  videoPlayerController.play();
        videoPlayerController.setVolume(1);
        videoPlayerController.setLooping(true);
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 115),
              width: size.width,
              height: size.height,
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: OverflowBox(
                maxWidth: double.infinity,
                child: AspectRatio(
                    aspectRatio: videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(videoPlayerController)),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 0),
                  color: Color.fromRGBO(245, 245, 245, 1),
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                        ),
                      ),
                      Row(
                        children: [
                          //  Follow button custom
                          FlatButton(
                            minWidth: 15,
                            onPressed: () {},
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/follow.svg'),
                                Text(
                                  'Follow',
                                  style: TextStyle(
                                      fontFamily: "Prompt_SemiBold",
                                      fontWeight: FontWeight.w600,
                                      color: Palette.colorText,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),

                          //  End follow button

                          //  details button
                          FlatButton(
                            minWidth: 15,
                            onPressed: () {},
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/details.svg'),
                                Text(
                                  'details',
                                  style: TextStyle(
                                      fontFamily: "Prompt_SemiBold",
                                      fontWeight: FontWeight.w600,
                                      color: Palette.colorText,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),

                          // End details button
                        ],
                      ),
                    ],
                  ),
                ),

                // Setion PEIX ET ACHAT
                Container(
                  padding: const EdgeInsets.only(bottom: 0),
                  color: Color.fromRGBO(41, 109, 252, 1),
                  height: 55,
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 8, 8, 8),
                        child: Row(
                          children: [
                            //  Prix du peoduits
                            Text(
                              '2,000',
                              style: TextStyle(
                                fontFamily: "Prompt_SemiBold",
                                fontWeight: FontWeight.w600,
                                color: Palette.colorLight,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'FCFA',
                              style: TextStyle(
                                fontFamily: "Prompt_SemiBold",
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      )),

                      //  Buton d'achat du produits
                      FlatButton(
                          height: 55,
                          minWidth: 50,
                          color: Palette.primaryColor,
                          onPressed: () {},
                          child: Text(
                            'Buy Now',
                            style: TextStyle(
                              fontFamily: "Prompt_Medium",
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Palette.colorLight,
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
//  OverflowBox(
//               maxWidth: double.infinity,
//               child: _controller.value.isInitialized
//                   ? AspectRatio(
//                       aspectRatio: _controller.value.aspectRatio,
//                       child: VideoPlayer(_controller),
//                     )
