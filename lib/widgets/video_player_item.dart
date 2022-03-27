import 'dart:ui';
import 'package:bazar/data/video.dart';
import 'package:bazar/widgets/profile_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bazar/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
//import 'package:video_player/video_player.dart';
import 'package:cached_video_player/cached_video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final Video element;
  const VideoPlayerItem({
    Key? key,
    required this.element,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.element.url)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
        videoPlayerController.setLooping(true);
      });
  }

  @override
  void dispose() {
    videoPlayerController.pause();
    videoPlayerController.dispose();
    super.dispose();
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
            GestureDetector(
              onTap: () {
                if (videoPlayerController.value.isPlaying) {
                  videoPlayerController.pause();
                } else {
                  videoPlayerController.play();
                }
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 55),
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
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 0),
                  color: Color.fromRGBO(0, 0, 0, 0.4),
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ProfileAvatar(imgUrl: widget.element.profile),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.element.nom,
                                    style: TextStyle(
                                      fontFamily: "Prompt_Medium",
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Palette.colorLight,
                                    ),
                                  ),
                                  Text(
                                    'jbij',
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
                                SvgPicture.asset(
                                  'assets/follow.svg',
                                  color: Palette.colorLight,
                                ),
                                Text(
                                  'Follow',
                                  style: TextStyle(
                                      fontFamily: "Prompt_SemiBold",
                                      fontWeight: FontWeight.w600,
                                      color: Palette.colorLight,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),

                          //  End follow button

                          //  details button
                          FlatButton(
                            minWidth: 15,
                            onPressed: () {
                              DetailsPopup(context);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/details.svg',
                                  color: Palette.colorLight,
                                ),
                                Text(
                                  'details',
                                  style: TextStyle(
                                      fontFamily: "Prompt_SemiBold",
                                      fontWeight: FontWeight.w600,
                                      color: Palette.colorLight,
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
                              widget.element.prix,
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
                          onPressed: () {
                            BuyPopup(context);
                          },
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

//  Popup  Details
  void DetailsPopup(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * .43,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              color: Palette.colorLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Product details',
                    style: TextStyle(
                      fontFamily: 'Prompt_Bold',
                      fontSize: 24.0,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.element.details,
                        style: TextStyle(
                          fontFamily: 'Prompt_Regular',
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  // quantity of product
                  Row(
                    children: [
                      Text(
                        'InStock: ',
                        style: TextStyle(
                          fontFamily: 'Prompt_Regular',
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        widget.element.quantite,
                        style: TextStyle(
                          fontFamily: 'Prompt_Regular',
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        ' articles',
                        style: TextStyle(
                          fontFamily: 'Prompt_Regular',
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 50.0,
                    width: double.infinity,
                    child: OutlineButton(
                      textColor: Palette.secondColor,
                      color: Palette.secondColor,
                      child: Text(
                        "Close",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Prompt_Medium',
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

// Buy Popup
  void BuyPopup(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * .30,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              color: Palette.colorLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Welcome to basic',
                    style: TextStyle(
                      fontFamily: 'Prompt_Bold',
                      fontSize: 24.0,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Experience a new way of shopping with short videos feed. Just swipe for new items and if you found the one you like, tap buy now button to purchase it.',
                    style: TextStyle(
                      fontFamily: 'Prompt_Regular',
                      fontSize: 18.0,
                    ),
                  ),
                  Spacer(
                    flex: 3,
                  ),
                  SizedBox(
                    height: 40.0,
                    width: double.infinity,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Palette.primaryColor,
                      child: Text(
                        "Start",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Prompt_Medium',
                        ),
                      ),
                      onPressed: () async {
                        // await availableCameras().then((value) => Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => CameraScreen(
                        //           cameras: value,
                        //         ),
                        //       ),
                        //     ));
                        //  Fermerture du popup
                        // Navigator.of(context).pop();
                        // Get.to(
                        //   CameraScreen(cameras),
                        // );
                      },
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
