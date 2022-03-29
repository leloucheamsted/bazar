import 'package:flutter/material.dart';
import '../config/palette.dart';

class Topbar extends StatelessWidget {
  final String title;
  final VoidCallback onpressed;
  const Topbar({required this.title, required this.onpressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.primaryColor,
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 8, 15, 8),
        child: Container(
          child: Center(
            child: Stack(children: [
              Container(
                child: InkWell(
                  onTap: onpressed,
                  child: Icon(
                    Icons.arrow_back_outlined,
                    color: Palette.colorLight,
                  ),
                ),
              ),
              Center(
                child: Container(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: "Prompt_SemiBold",
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: Palette.colorLight,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
