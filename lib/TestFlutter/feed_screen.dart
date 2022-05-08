// ignore_for_file: deprecated_member_use
// ignore: non_constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
// import 'package:bazar/screens/PayProcess/buy_process1.dart';
import 'package:bazar/screens/profile/profile_screen.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../Services/feef_videoModel.dart';
import '../config/palette.dart';
import '../data/video.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/otp/otp1.dart';
import '../widgets/button.dart';
import '../widgets/profile_card.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late Future<int> _counter;
  late int c;
  late String number;
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
    selecter();
    super.initState();
  }

  selecter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    c = prefs.getInt('_counter') ?? 0;
    numero = prefs.getString('numero') ?? "";
    if (c == 0) {
      // await prefs.setInt('counter', 1);
      // return FirstPage();
    } else {
      //return SecondPage();
    }
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

    return Scaffold(
      backgroundColor: Palette.colorLight,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4.0, 0, 2, 0),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(1.0, 0, 0, 0),
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
                  const Spacer(),
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
                    key: const Key("unique key"),
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
                              onTap: (){
                                ProfileUser(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ProfileAvatar(imgUrl: video.profile),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        video.nom,
                                        style: const TextStyle(
                                          fontFamily: "Prompt_Medium",
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: Palette.colorLight,
                                        ),
                                      ),
                                      Text(
                                        video.username,
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
                              DetailsPopup(video.details, video.quantite,
                                  video.numeroVendeur);
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
                              video.prix,
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
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            String count =  prefs.getString('counter')?? '';
                            String name= prefs.getString('uuid')?? '';
                            String uuid= prefs.getString('uuid')?? '';
                            if(kDebugMode){
                              print('index');
                              print(count);
                              print(name);
                              print(uuid);

                            }
                            //  var counter = await _counter;
                            if (count != "1") {
                              //  print(counter);
                              BuyPopup(context);
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

  ///  Popup Achat du produit
  Future<void> openwhatsapp(Video video) async {
    var whatsapp = "+" + video.numeroVendeur;
    var whatsappURlAndroid =
        "whatsapp://send?phone=" + whatsapp + "&text=*hello*\n How are you?";
    var whatappURLIos =
        "https://wa.me/$whatsapp?text=${Uri.parse("*hello*\n How are you?")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURLIos)) {
        await launch(whatappURLIos, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURlAndroid)) {
        await launch(whatsappURlAndroid);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("whatsapp no installed")));
      }
    }
  }

  /// Connection init
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Error Occurred: ${e.toString()} ");
      }
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _UpdateConnectionState(result);
  }

  // ignore: non_constant_identifier_names
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
        duration: const Duration(seconds: 4),
        content: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                status
                    ? "The connection has been re-established"
                    : "Your network connection has been interrupted",
                style: const TextStyle(
                    color: Palette.colorLight,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Prompt_Regular'),
              ),
              SvgPicture.asset(
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
  // ignore: non_constant_identifier_names
  void DetailsPopup(String details, String quantite, String number) {
    if (kDebugMode) {
      print(number);
      print(numero);
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
                  if (number == numero)
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

// Buy Popup
  // ignore: non_constant_identifier_names
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
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child:
                  Text(
                    'Welcome to mokolo',
                    style: TextStyle(
                      fontFamily: 'Prompt_Bold',
                      fontSize: 24.0,
                    ),
                  ),

                ),
                const Spacer(),
                const Text(
                  '1- Swipe up and down to discover new articles.',
                  style: TextStyle(
                    fontFamily: 'Prompt_Regular',
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox(height: 4,),
                const Text(
                  '2- Tap the Buy now button to place your order.',
                  style: TextStyle(
                    fontFamily: 'Prompt_Regular',
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox(height: 4,),
                const Text(
                  '3- Enter your shipping details and pay.',
                  style: TextStyle(
                    fontFamily: 'Prompt_Regular',
                    fontSize: 15.0,
                  ),
                ),
                const Spacer(
                  flex: 3,
                ),
                SizedBox(
                  height: 40.0,
                  width: double.infinity,
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Palette.primaryColor,
                    child: const Text(
                      "Start",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Prompt_Medium',
                      ),
                    ),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const EnterNumberScreen())).then((value) {
                        setState(() {});

                        // Get.to(EnterNumberScreen(),
                        //     transition: Transition.rightToLeftWithFade);
                        // MaterialPageRoute(
                        //     builder: (context) => EnterNumberScreen());
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  // ignore: non_constant_identifier_names
  void ProfileUser(context) {
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
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child:
                     Text(
                      'Welcome to mokolo',
                      style: TextStyle(
                        fontFamily: 'Prompt_Bold',
                        fontSize: 24.0,
                      ),
                    ),

                  ),
                  const Spacer(),
                  const Text(
                    '1- Swipe up and down to discover new articles.',
                    style: TextStyle(
                      fontFamily: 'Prompt_Regular',
                      fontSize: 15.0,
                    ),
                  ),
                  const SizedBox(height: 4,),
                  const Text(
                    '2- Tap the Buy now button to place your order.',
                    style: TextStyle(
                      fontFamily: 'Prompt_Regular',
                      fontSize: 15.0,
                    ),
                  ),
                  const SizedBox(height: 4,),
                  const Text(
                    '3- Enter your shipping details and pay.',
                    style: TextStyle(
                      fontFamily: 'Prompt_Regular',
                      fontSize: 15.0,
                    ),
                  ),
                  const Spacer(
                    flex: 3,
                  ),
                  SizedBox(
                    height: 40.0,
                    width: double.infinity,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Palette.primaryColor,
                      child: const Text(
                        "Start",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Prompt_Medium',
                        ),
                      ),
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EnterNumberScreen())).then((value) {
                          setState(() {});

                          // Get.to(EnterNumberScreen(),
                          //     transition: Transition.rightToLeftWithFade);
                          // MaterialPageRoute(
                          //     builder: (context) => EnterNumberScreen());
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ],
              ),

          );
        });
  }
}
