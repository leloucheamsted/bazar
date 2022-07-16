import 'package:bazar/Services/user.dart';
import 'package:bazar/screens/create_post/add_details.dart';
import 'package:bazar/screens/create_post/camera_screen.dart';
import 'package:bazar/screens/create_post/video_view.dart';
import 'package:bazar/service_locator.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import './screens/screens.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

List<CameraDescription>? cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white, // navigation bar color
    statusBarColor: Colors.white, // status bar color
    statusBarBrightness: Brightness.dark, //status bar brigtness
    statusBarIconBrightness: Brightness.dark, //status barIcon Brightness
    systemNavigationBarDividerColor:
        Colors.white, //Navigation bar divider color
    systemNavigationBarIconBrightness: Brightness.light, //navigation bar icon
  ));
  setup();
  // final rxPrefs = RxSharedPreferences(
  //   SharedPreferences.getInstance(),
  //   kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  // );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => User(
              name: 'name',
              imgUrl: 'imgUrl',
              username: 'username',
              whatsapp: 'whatsapp',
              uiud: 'uiud'),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const NavScreen(),
      routes: <String, WidgetBuilder>{
        '/nav_screen': (BuildContext context) => const NavScreen(),
        '/camera_screen': (BuildContext context) =>
            CameraScreen(cameras: cameras),
        '/video_view_screen': (BuildContext context) =>
            const VideoViewPage(path: 'path', isCamerafront: false),
        '/add_details_screen': (context) =>
            const AddDetailsScreen(path: 'path', isCamerefront: false),
      },
    );
  }
}
// flutter run --no-sound-null-safety