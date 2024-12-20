import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:bazar/screens/PayProcess/buy_process1.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../Services/feef_videoModel.dart';
import '../Services/fiel_model_fire.dart';
import '../config/palette.dart';
import '../data/video.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/button.dart';
import '../widgets/profile_card.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class FeedScreen extends StatefulWidget {
  FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late Future<int> _counter;
  late int c;
  final locator = GetIt.instance;
  final feedViewModel = GetIt.instance<FeedViewModel>();
  late int position;
  @override
  void initState() {
    feedViewModel.loadVideo(0);
    feedViewModel.loadVideo(1);
    feedViewModel.setInitialised(true);
    if (kDebugMode) {
      print('Nombre de videos' + feedViewModel.videos.length.toString());
    }
    setState(() {
      position = 0;
    });
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_UpdateConnectionState);
    counter();
    super.initState();
  }

  Future<void> counter() async {
    final prefs = await SharedPreferences.getInstance();
    final int counter = (prefs.getInt('count') ?? 0);

    setState(() {
      _counter = prefs.setInt('count', counter).then((bool success) {
        return counter;
      });
    });
    c = await _counter;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FeedViewModel>.reactive(
      disposeViewModel: false,
      builder: (context, model, child) => videoScreen(),
      viewModelBuilder: () => feedViewModel,
    );
  }

  Widget videoScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: feedVideos(),
    );
  }

  Widget feedVideos() {
    if (kDebugMode) {
      print(feedViewModel.videos.length.toString());
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
      child: Stack(
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
                    iconImage: 'assets/chrono.svg',
                    // iconSize: 30,
                    onPressed: () {}),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: CarouselSlider.builder(
              itemCount: feedViewModel.videos.length,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) {
                itemIndex = itemIndex % (feedViewModel.videos.length);
                // return Text(feedViewModel.videos[itemIndex].nom);
                return videoCard(feedViewModel.videos[itemIndex]);
              },
              options: CarouselOptions(
                viewportFraction: 1,
                initialPage: 0,
                height: MediaQuery.of(context).size.height,
                enableInfiniteScroll: false,
                reverse: false,
                autoPlay: false,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  index = index % (feedViewModel.videos.length);
                  feedViewModel.changeVideo(index);
                },
                scrollDirection: Axis.vertical,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget videoCard(Video video) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            video.controller != null
                ? VisibilityDetector(
                    key: Key("unique key"),
                    onVisibilityChanged: (VisibilityInfo info) {
                      debugPrint(
                          "${info.visibleFraction} of my widget is visible");
                      if (info.visibleFraction == 0) {
                        video.controller?.pause();
                      } else {
                        video.controller?.play();
                      }
                    },
                    child: GestureDetector(
                      onTap: () {
                        if (video.controller!.value.volume == 1) {
                          video.controller?.setVolume(0);
                        } else {
                          video.controller?.setVolume(1);
                        }
                      },
                      child: Container(
                        //   color: Palette.loadingColor,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 55),
                        width: video.controller?.value.size.width,
                        height: video.controller?.value.size.height,
                        decoration: const BoxDecoration(
                          color: Palette.loadingColor,
                        ),
                        child: OverflowBox(
                          maxWidth: double.infinity,
                          child: AspectRatio(
                              aspectRatio: video.controller!.value.aspectRatio,
                              child: VideoPlayer(video.controller!)),
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Palette.loadingColor,
                    child: Center(
                      child: Container(
                        height: 70,
                        width: 70,
                        color: Palette.loadingColor,
                        child: Center(
                            child: CircularProgressIndicator(
                          backgroundColor: Colors.grey,
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Colors.blueAccent),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ProfileAvatar(imgUrl: video.profile),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    video.nom,
                                    style: TextStyle(
                                      fontFamily: "Prompt_Medium",
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Palette.colorLight,
                                    ),
                                  ),
                                  Text(
                                    video.username,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Prompt_Medium",
                                      color: Palette.colorLight,
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
                              DetailsPopup(video.details, video.quantite);
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
                              video.prix,
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
                            if (c < 1) {
                              BuyPopup(context);
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BuyProcessOne(
                                            video: video,
                                          )));
                            }
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

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print("Error Occurred: ${e.toString()} ");
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _UpdateConnectionState(result);
  }

  Future<void> _UpdateConnectionState(ConnectivityResult result) async {
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      showStatus(result, true);
    } else {
      showStatus(result, false);
    }
  }

  void showStatus(ConnectivityResult result, bool status) {
    final snackBar = SnackBar(
        duration: new Duration(seconds: 4),
        content: Container(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                status
                    ? "The connection has been re-established"
                    : "Your network connection has been interrupted",
                style: TextStyle(
                    color: Palette.colorLight,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Prompt_Regular'),
              ),
              new SvgPicture.asset(
                'assets/close.svg',
                color: Palette.colorLight,
              ),
            ],
          ),
        ),
        backgroundColor: status ? Palette.primaryColor : Palette.colorError);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    // feedViewModel.controller!.dispose();
    super.dispose();
  }

  //  Popup  Details
  void DetailsPopup(String details, String quantite) {
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
                        details,
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
                        quantite,
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
