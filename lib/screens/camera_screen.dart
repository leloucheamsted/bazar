import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'package:bazar/config/palette.dart';
import 'package:bazar/main.dart';
import 'package:bazar/screens/camera_view.dart';
import 'package:bazar/screens/video_view.dart';
import 'package:bazar/widgets/button.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CameraScreen extends StatefulWidget {
  List<CameraDescription>? cameras;
  CameraScreen({required this.cameras, Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> cameraValue;
  bool isRecoring = false;
  bool flash = false;
  bool iscamerafront = true;
  double transform = 0;
  late Timer _timer;
  int _start = 15;
  String NoRecordIcon = "assets/elipse2.svg";
  String RecordIcon = "assets/elipse3.svg";

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(cameras![0], ResolutionPreset.high);
    cameraValue = _cameraController.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    //SystemChrome.setEnabledSystemUIOverlays([]);

    // if (!controller.value.isInitialized) {
    //   return const SizedBox(
    //     child: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }
    return Scaffold(
        body: Stack(children: [
      FutureBuilder(
          future: cameraValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: CameraPreview(_cameraController));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      Positioned(
        top: 50.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Container(
            width: size,
            child: Row(
              children: [
                Button(
                    iconImage: 'assets/backwhite.svg',
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Record a new product',
                      style: TextStyle(
                          color: Palette.colorLight,
                          fontFamily: "Prompt_Regular",
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(
                      flash ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      setState(() {
                        flash = !flash;
                      });
                      flash
                          ? _cameraController.setFlashMode(FlashMode.torch)
                          : _cameraController.setFlashMode(FlashMode.off);
                    }),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () async {
                    setState(() {
                      iscamerafront = !iscamerafront;
                      transform = transform + pi;
                    });
                    int cameraPos = iscamerafront ? 0 : 1;
                    _cameraController = CameraController(
                      widget.cameras![1],
                      ResolutionPreset.high,
                    );
                    _cameraController.initialize();
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset('assets/reverse.svg'),
                  ),
                  // onPressed: () {},
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 50.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Container(
            width: size,
            child: Row(children: [
              Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/upload.svg',
                          ),
                          Text(
                            'upload',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: "Prompt_Regular",
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '$_start Sec',
                        style: TextStyle(
                            fontFamily: "Prompt_Regular",
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            color: Palette.colorLight),
                      ),
                      // ElevatedButton(onPressed: (), ON child: Text('BOUTTON'),),
                      GestureDetector(
                        onLongPress: () async {
                          await _cameraController.startVideoRecording();
                          const oneSec = const Duration(seconds: 1);

                          setState(() {
                            isRecoring = true;
                          });
                          _timer = new Timer.periodic(
                            oneSec,
                            (Timer timer) => setState(
                              () {
                                if (_start < 1) {
                                  timer.cancel();
                                  _cameraController.stopVideoRecording();
                                } else {
                                  setState(() {
                                    _start = _start - 1;
                                  });
                                }
                              },
                            ),
                          );
                        },
                        onLongPressUp: () async {
                          XFile videopath =
                              await _cameraController.stopVideoRecording();
                          setState(() {
                            isRecoring = false;
                          });

                          //  startTimer(false);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => VideoViewPage(
                                        path: videopath.path,
                                      )));
                        },
                        onTap: () {
                          if (!isRecoring) takePhoto(context);
                        },
                        child: AbsorbPointer(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset('assets/elipse1.svg'),
                              isRecoring == true
                                  ? SvgPicture.asset(RecordIcon)
                                  : SvgPicture.asset(NoRecordIcon),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Spacer(
                flex: 2,
              ),
            ]),
          ),
        ),
      ),
    ]));
  }

  void takePhoto(BuildContext context) async {
    XFile file = await _cameraController.takePicture();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => CameraViewPage(
                  path: file.path,
                )));
  }

  void startTimer(bool exc) {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1 && exc == false) {
            timer.cancel();
          } else if (exc == true) {
            setState(() {
              _start = _start - 1;
            });
          }
        },
      ),
    );
  }
}
