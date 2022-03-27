import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../config/palette.dart';

class ItemVille extends StatelessWidget {
  final String ville;
  final VoidCallback Pop;
  const ItemVille({required this.ville, required this.Pop, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
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
                      ville,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: "Prompt_Regular",
                        fontSize: 18,
                        color: Palette.colorText,
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: Pop,
                      child: SvgPicture.asset(
                        'assets/plus.svg',
                        color: Palette.colorText,
                      )),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
