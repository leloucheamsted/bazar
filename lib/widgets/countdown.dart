import 'package:bazar/config/palette.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Countdown extends AnimatedWidget {
  Countdown({Key? key, required this.animation})
      : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    if (kDebugMode) {
      print('animation.value  ${animation.value} ');
      print('inMinutes ${clockTimer.inMinutes.toString()}');
      print('inSeconds ${clockTimer.inSeconds.toString()}');
      print(
          'inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');
    }

    return Text(
      timerText,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        fontFamily: "Prompt_Regular",
        color: Palette.colorText,
      ),
    );
  }
}
