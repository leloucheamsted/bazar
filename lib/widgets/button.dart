import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config/palette.dart';

class Button extends StatelessWidget {
  final String iconImage;
  //final double iconSize;
  final VoidCallback onPressed;
  const Button(
      {required this.iconImage,
      // required this.iconSize,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SvgPicture.asset(iconImage),
      ),
      // onPressed: () {},
    );
  }
}
