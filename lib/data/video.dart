import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
//import 'package:video_player/video_player.dart';
import 'package:cached_video_player/cached_video_player.dart';

class Video {
  String numeroVendeur;
  // ignore: non_constant_identifier_names
  String video_title;
  String prix;
  // ignore: non_constant_identifier_names
  String Category;
  String quantite;
  String url;
  String likes;
  String details;
  String nom;
  String profile;
  String username;
  VideoPlayerController? controller;

  Video(
      {required this.numeroVendeur,
      required this.prix,
      required this.nom,
      required this.username,
      // ignore: non_constant_identifier_names
      required this.video_title,
      // ignore: non_constant_identifier_names
      required this.Category,
      required this.likes,
      required this.details,
      required this.profile,
      required this.quantite,
      required this.url});

  Video.fromJson(Map<dynamic, dynamic> json)
      : numeroVendeur = json['numeroVendeur'],
        nom = json['nom'],
        username = json['username'],
        profile = json['profile'],
        video_title = json['video_title'],
        Category = json['Category'],
        quantite = json['quantite'],
        likes = json['likes'],
        details = json['details'],
        prix = json['prix'],
        url = json['url'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['numeroVendeur'] = numeroVendeur;
    data['nom'] = nom;
    data['username'] = username;
    data['profile'] = profile;
    data['video_title'] = video_title;
    data['Category'] = Category;
    data['quantite'] = quantite;
    data['likes'] = likes;
    data['details'] = details;
    data['prix'] = prix;
    data['url'] = url;
    return data;
  }

  static Video fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Video(
      numeroVendeur: snapshot['numeroVendeur'],
      nom: snapshot['nom'],
      username: snapshot['username'],
      profile: snapshot['profile'],
      likes: snapshot['likes'],
      video_title: snapshot['video_title'],
      Category: snapshot['Category'],
      quantite: snapshot['quantite'],
      //likes: snapshot['caption'],
      details: snapshot['details'],
      prix: snapshot['prix'],
      url: snapshot['url'],
    );
  }

  Future<void> loadController() async {
    controller = VideoPlayerController.network(url);
    await controller
        ?.initialize()
        .then((value) => debugPrint('Controller Initialiszed!!'));
    controller?.setLooping(true);
  }
}
