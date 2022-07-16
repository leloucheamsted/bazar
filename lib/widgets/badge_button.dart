import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BadgeButton extends StatelessWidget {
  final String iconImage;
  // final double iconSize;
  final Color color;
  // final VoidCallback onPressed;
  const BadgeButton(
      {required this.iconImage,
      // required this.iconSize,
      required this.color,
      //   required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          SvgPicture.asset(iconImage),
          Positioned(
            right: 4,
            top: 0,
            child: SizedBox(
              height: 10,
              width: 10,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
