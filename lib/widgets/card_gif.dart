import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../config/palette.dart';

class CardGif extends StatelessWidget {
  final String urlGif;
  const CardGif({required this.urlGif, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('video selectionner');
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  urlGif,
                ),
              ),
            ),
            foregroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                end: Alignment.center,
                begin: Alignment.bottomRight,
                colors: [
                  Palette.colorInput,
                  Colors.transparent,
                ],
              ),
            ),
            alignment: Alignment.bottomRight,
          ),
        ],
      ),
    );
  }
}
