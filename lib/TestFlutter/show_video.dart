import 'package:bazar/Services/user.dart';
import 'package:bazar/data/video.dart';
import 'package:bazar/widgets/profile_card.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../config/palette.dart';

class ShowVideo extends StatefulWidget {
  final Video video;
  const ShowVideo({required this.video, Key? key}) : super(key: key);

  @override
  _ShowVideoState createState() => _ShowVideoState();
}

class _ShowVideoState extends State<ShowVideo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            widget.video.controller != null
                ? VisibilityDetector(
                    key: const Key("unique key"),
                    onVisibilityChanged: (VisibilityInfo info) {
                      debugPrint(
                          "${info.visibleFraction} of my widget is visible");
                      if (info.visibleFraction == 0) {
                        widget.video.controller?.pause();
                      } else {
                        widget.video.controller?.play();
                      }
                    },
                    child: GestureDetector(
                      onTap: () {
                        if (widget.video.controller!.value.volume == 1) {
                          widget.video.controller?.setVolume(0);
                        } else {
                          widget.video.controller?.setVolume(1);
                        }
                      },
                      child: Container(
                        //   color: Palette.loadingColor,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 55),
                        width: widget.video.controller?.value.size.width,
                        height: widget.video.controller?.value.size.height,
                        decoration: const BoxDecoration(
                          color: Palette.loadingColor,
                        ),
                        child: OverflowBox(
                          maxWidth: double.infinity,
                          child: AspectRatio(
                              aspectRatio:
                                  widget.video.controller!.value.aspectRatio,
                              child: VideoPlayer(widget.video.controller!)),
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/loadingscreen.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    // decoration:const BoxDecoration(
                    //   gradient: LinearGradient(colors: [Color.fromRGBO(219, 219, 219, 0.05),Color.fromRGBO(230, 230, 230, 1)],stops: [0,1],transform: GradientRotation(3*math.pi / 2),)
                    // ),
                    child: Center(
                      child: Container(
                        height: 70,
                        width: 70,
                        // color: Palette.loadingColor,
                        child: const Center(
                            child: CircularProgressIndicator(
                          backgroundColor: Colors.transparent,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                        )),
                      ),
                    ),
                  ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 0),
                  color: const Color.fromRGBO(0, 0, 0, 0.4),
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ProfileAvatar(imgUrl: widget.video.profile),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.video.nom,
                                        style: const TextStyle(
                                          fontFamily: "Prompt_Medium",
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: Palette.colorLight,
                                        ),
                                      ),
                                      Text(
                                        widget.video.username,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Prompt_Medium",
                                          color: Palette.colorLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ),
                      Row(
                        children: [
                          //  Follow button custom
                          // FlatButton(
                          //   minWidth: 15,
                          //   onPressed: () {},
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       SvgPicture.asset(
                          //         'assets/follow.svg',
                          //         color: Palette.colorLight,
                          //       ),
                          //       Text(
                          //         'Follow',
                          //         style: TextStyle(
                          //             fontFamily: "Prompt_SemiBold",
                          //             fontWeight: FontWeight.w600,
                          //             color: Palette.colorLight,
                          //             fontSize: 14),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          //  End follow button

                          //  details button
                          FlatButton(
                            minWidth: 15,
                            onPressed: () {
                              DetailsPopup(
                                  widget.video.details,
                                  widget.video.quantite,
                                  widget.video.numeroVendeur);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/details.svg',
                                  color: Palette.colorLight,
                                ),
                                const Text(
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
                  color: const Color.fromRGBO(41, 109, 252, 1),
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
                              widget.video.prix,
                              style: const TextStyle(
                                fontFamily: "Prompt_SemiBold",
                                fontWeight: FontWeight.w600,
                                color: Palette.colorLight,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
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
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String count = prefs.getString('counter') ?? '';
                            String name = prefs.getString('uuid') ?? '';
                            String uuid = prefs.getString('uuid') ?? '';
                            if (kDebugMode) {
                              print('index');
                              print(count);
                              print(name);
                              print(uuid);
                            }
                            //  var counter = await _counter;
                            if (count != "1") {
                              //  print(counter);
                              // BuyPopup(context);
                            } else {
                              if (kDebugMode) {
                                print("open whatsapp");
                              }
                              // openwhatsapp(video);
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => BuyProcessOne(
                              //               video: video,
                              //             )));
                            }
                          },
                          child: const Text(
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

  void DetailsPopup(String details, String quantite, String number) {
    if (kDebugMode) {
      print(context.watch<User>().whatsapp);
      //print(numero);
    }
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
                  const Text(
                    'Product details',
                    style: TextStyle(
                      fontFamily: 'Prompt_Bold',
                      fontSize: 24.0,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        details,
                        style: const TextStyle(
                          fontFamily: 'Prompt_Regular',
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  // quantity of product
                  Row(
                    children: [
                      const Text(
                        'InStock: ',
                        style: TextStyle(
                          fontFamily: 'Prompt_Regular',
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        quantite,
                        style: const TextStyle(
                          fontFamily: 'Prompt_Regular',
                          fontSize: 18.0,
                        ),
                      ),
                      const Text(
                        ' articles',
                        style: TextStyle(
                          fontFamily: 'Prompt_Regular',
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 50.0,
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            width: 1, color: Palette.secondColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        textStyle: const TextStyle(
                          color: Palette.secondColor,
                          // fontSize: 20,
                        ),
                        backgroundColor: Palette.colorLight,
                        padding: const EdgeInsets.all(10),
                      ),
                      child: const Text(
                        "Close",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Palette.secondColor,
                          fontFamily: 'Prompt_Medium',
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  /// delete button if is user who had post product
                  if (widget.video == context.watch<User>().whatsapp)
                    SizedBox(
                      height: 50.0,
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              width: 0,
                              color: Color.fromRGBO(254, 240, 240, 1)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          textStyle: const TextStyle(
                            color: Color.fromRGBO(232, 38, 38, 1),
                            // fontSize: 20,
                          ),
                          backgroundColor:
                              const Color.fromRGBO(254, 240, 240, 1),
                          padding: const EdgeInsets.all(10),
                        ),
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Color.fromRGBO(232, 38, 38, 1),
                            fontFamily: 'Prompt_Medium',
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        });
  }
}
