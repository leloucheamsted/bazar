import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final VoidCallback onPressed;

  const CircleButton({
    Key? key,
    required this.icon,
    required this.iconSize,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 20.0,
        width: 20.0,
        child: new IconButton(
          alignment: Alignment.center,
          padding: new EdgeInsets.all(0.0),
          icon: Icon(icon),
          onPressed: onPressed,
        ));
  }
}
