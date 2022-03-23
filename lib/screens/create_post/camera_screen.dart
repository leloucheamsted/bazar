import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'package:bazar/config/palette.dart';
import 'package:bazar/main.dart';
import 'package:bazar/screens/camera_view.dart';
import 'package:bazar/screens/create_post/video_view.dart';
import 'package:bazar/widgets/button.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;
import 'package:image/image.dart' as img;
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

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
  // final double mirror = iscamerafront == true ? math.pi : 0;

  double transform = 0;
  late Timer _timer;
  int _start = 15;
  String NoRecordIcon = "assets/elipse2.svg";
  String RecordIcon = "assets/elipse3.svg";

  @override
  void initState() {
    super.initState();
    _cameraController =
        CameraController(cameras![0], ResolutionPreset.veryHigh);
    cameraValue = _cameraController.initialize();
  }

  void startTime() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (Timer timer) async {
      //  await _cameraController.startVideoRecording();
      if (_start == 0) {
        setState(() async {
          timer.cancel();
          setState(() {
            _start = 15;
          });
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
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

    if (Platform.isAndroid) {
      //  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light, // dark text for status bar
          statusBarColor: Colors.transparent));
    }
    // }
    return WillPopScope(
      onWillPop: () async {
//SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness:
                Brightness.dark, // dark text for status bar
            statusBarColor: Colors.transparent));
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(alignment: FractionalOffset.center, children: <Widget>[
            FutureBuilder(
                future: cameraValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return OverflowBox(
                      maxWidth: double.infinity,

                      // maxWidth: MediaQuery.of(context).size.width,
                      // maxHeight: MediaQuery.of(context).size.height,
                      child: AspectRatio(
                          aspectRatio: 1 / _cameraController.value.aspectRatio,
                          child: CameraPreview(_cameraController)),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            Positioned(
              top: 50.0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
                child: Container(
                  width: size,
                  child: Row(
                    children: [
                      Button(
                          iconImage: 'assets/backwhite.svg',
                          onPressed: () {
                            if (Platform.isAndroid) {
                              SystemChrome.setSystemUIOverlayStyle(
                                  SystemUiOverlayStyle(
                                      systemNavigationBarColor:
                                          Colors.transparent,
                                      systemNavigationBarIconBrightness:
                                          Brightness.dark,
                                      statusBarIconBrightness: Brightness
                                          .dark, // dark text for status bar
                                      statusBarColor: Colors.transparent));
                            }

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
                                ? _cameraController
                                    .setFlashMode(FlashMode.torch)
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
                            widget.cameras![cameraPos],
                            ResolutionPreset.max,
                          );
                          cameraValue = _cameraController.initialize();
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
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                child: Container(
                  width: size,
                  child: Row(children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 20, 0, 0),
                      child: GestureDetector(
                        onTap: () async {
                          const oneSec = const Duration(seconds: 1);
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.video,
                            allowCompression: false,
                          );
                          if (result != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VideoViewPage(
                                        path: result.files.single.path!)));
                          }
                        },
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
                              onTap: (() async {
                                if (isRecoring == false) {
                                  isRecoring = !isRecoring;
                                  await _cameraController.startVideoRecording();
                                } else {
                                  _timer.cancel();
                                  isRecoring = !isRecoring;
                                  _start = 15;
                                  XFile videopath = await _cameraController
                                      .stopVideoRecording();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) => VideoViewPage(
                                              path: videopath.path)));
                                }
                                const oneSec = const Duration(seconds: 1);
                                _timer = new Timer.periodic(oneSec,
                                    (Timer timer) async {
                                  if (_start == 0) {
                                    setState(() {
                                      setState(() {
                                        _start = 15;
                                      });
                                      timer.cancel();
                                      isRecoring = false;
                                    });
                                    XFile videopath = await _cameraController
                                        .stopVideoRecording();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) => VideoViewPage(
                                                path: videopath.path)));
                                  } else {
                                    setState(() {
                                      _start--;
                                    });
                                  }
                                });
                              }),
                              // onLongPressUp: (() async {
                              //   isRecoring = !isRecoring;
                              //   XFile videopath = await _cameraController
                              //       .stopVideoRecording();
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (builder) => VideoViewPage(
                              //               path: videopath.path)));
                              // }),

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
          ])),
    );
  }

  void startTimer(bool exc) {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1 && exc == false || exc == false) {
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

  void takePhoto(BuildContext context) async {
    XFile xfile = await _cameraController.takePicture();
    List<int> imageBytes = await xfile.readAsBytes();

    img.Image? originalImage = img.decodeImage(imageBytes);
    img.Image fixedImage = img.flipVertical(originalImage!);
    img.Image fixedImage1 = img.flipVertical(fixedImage);
    img.Image fixedImage2 = img.flipHorizontal(fixedImage1);

    File file = File(xfile.path);

    File fixedFile = await file.writeAsBytes(
      img.encodeJpg(fixedImage1),
      flush: true,
    );
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => CameraViewPage(
                  path: fixedFile.path,
                )));
  }

  Future<String> FlipVideo(XFile file) async {
    var id = Uuid().v4();

    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    final dir = _appDocDir.path;
    final outPath = "$dir/$id.mp4";
    await _flutterFFmpeg
        .execute("-i ${file.path} -vf hflip -c:a copy $outPath")
        .then((returnCode) => print("Return code $returnCode"));
    return outPath;
  }
}
