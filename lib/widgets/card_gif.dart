import 'package:bazar/TestFlutter/show_video.dart';
import 'package:bazar/data/video.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../config/palette.dart';
import 'package:get/get.dart';

class CardGif extends StatelessWidget {
  final String urlGif;
  const CardGif({required this.urlGif, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Video video = Video(
        video_title: '',
        Category: '',
        likes: '',
        profile: '',
        details: '',
        nom: '',
        numeroVendeur: '',
        prix: '',
        quantite: '',
        url: '',
        username: '');
    return InkWell(
      onTap: () async {
        ;
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot;
        FirebaseFirestore.instance
            .collection("Videos")
            .where("gifUrl", isEqualTo: urlGif)
            .get()
            .then((value) {
          documentSnapshot = value.docs.first;
          video.nom = documentSnapshot.data()!["nom"];
          video.numeroVendeur = documentSnapshot.data()!["numeroVendeur"];
          video.prix = documentSnapshot.data()!["prix"];
          video.quantite = documentSnapshot.data()!["quantite"];
          video.url = documentSnapshot.data()!["url"];
          video.username = documentSnapshot.data()!["username"];
          video.video_title = documentSnapshot.data()!["video_title"];
          video.Category = documentSnapshot.data()!["Category"];
          video.likes = documentSnapshot.data()!["likes"];
          video.profile = documentSnapshot.data()!["profile"];
          video.details = documentSnapshot.data()!["details"];
          if (kDebugMode) {
            print(documentSnapshot.data()!["title"]);
          }
        });
        Get.to(ShowVideo(video: video),
            transition: Transition.cupertino,
            duration: const Duration(milliseconds: 500));
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
            foregroundDecoration: const BoxDecoration(
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
