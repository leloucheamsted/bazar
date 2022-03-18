import 'package:bazar/config/palette.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String imgUrl;
  const ProfileAvatar({required this.imgUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: 20,
        backgroundColor: Palette.primaryColor,
        child: CircleAvatar(
          backgroundColor: Colors.grey[200],
          backgroundImage: CachedNetworkImageProvider(imgUrl),
        ));
  }
}
