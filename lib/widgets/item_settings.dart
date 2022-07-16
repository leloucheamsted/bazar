import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../config/palette.dart';

class ItemSettings extends StatelessWidget {
  final String settings;
  // ignore: non_constant_identifier_names
  final VoidCallback Pop;
  // ignore: non_constant_identifier_names
  const ItemSettings({required this.settings, required this.Pop, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: Pop,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          height: 50,
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        settings,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: "Prompt_Regular",
                          fontSize: 18,
                          color: Palette.colorText,
                        ),
                      ),
                    ),
                    InkWell(
                        onTap: Pop,
                        child: SvgPicture.asset(
                          'assets/plus.svg',
                          color: Palette.colorText,
                        )),
                  ],
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
